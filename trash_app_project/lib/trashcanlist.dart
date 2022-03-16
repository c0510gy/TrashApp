import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrashCanListPage extends StatefulWidget {
  @override
  _TrashCanListPage createState() => _TrashCanListPage();
}

class _TrashCanListPage extends State<TrashCanListPage> {
  List<List<dynamic>> _trashCans = [];
  List<List<dynamic>> _trashCansOnList = [];
  List<String> _favoriteList = [];

  late SharedPreferences prefs;

  void _loadPrefs() async {
    print('helloeoofoefoeofo');
    prefs = await SharedPreferences.getInstance();
    print(prefs);

    setState(() {
      _favoriteList = prefs.getStringList('favoriteList') ?? [];
    });
  }

  void _setPrefs() async {
    await prefs.setStringList('favoriteList', _favoriteList);
  }

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/trashcanlist.csv");
    _trashCans = const CsvToListConverter().convert(_rawData);
    setState(() {
      _trashCansOnList = _trashCans.sublist(1);
    });
  }

  _TrashCanListPage() {
    _loadCSV();
    _loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        keyboardType: TextInputType.text,
        onChanged: (text) {
          List<List<dynamic>> newData = [
            //_trashCans[0],
            ..._trashCans
                .sublist(1)
                .where((row) =>
                    '${row[1]}${row[2]}${row[3]}'.toString().contains(text))
                .toList()
          ];
          setState(() {
            _trashCansOnList = newData;
          });
        },
        decoration: InputDecoration(
          hintText: '검색',
          border: InputBorder.none,
          icon: Padding(
              padding: EdgeInsets.only(left: 13), child: Icon(Icons.search)),
        ),
      ),
      Divider(),
      Expanded(
          child: ListView.builder(
        itemCount: _trashCansOnList.length,
        itemBuilder: (_, index) {
          return Column(children: [
            _buildRow(
              _trashCansOnList[index][1],
              '${_trashCansOnList[index][2].toString().replaceAll('\n', ' ')} ${_trashCansOnList[index][3].toString().replaceAll('\n', ' ')}',
            ),
            Divider(),
          ]);
          /*Card(
            margin: const EdgeInsets.all(3),
            color: index == 0 ? Colors.lightBlueAccent : Colors.white,
            child: ListTile(
              leading: Text(_trashCansOnList[index][0].toString()),
              title: Text(_trashCansOnList[index][1]),
              subtitle: Text(
                  _trashCansOnList[index][2].toString().replaceAll('\n', ' ')),
              trailing: Text(
                  _trashCansOnList[index][3].toString().replaceAll('\n', ' ')),
            ),
          ); */
        },
      )),
    ]);
  }

  Widget _buildRow(String title, String subtitle) {
    final hash = '${title}${subtitle}';
    final isFavorite = _favoriteList.contains(hash);

    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
              icon: Icon(
                Icons.star,
                color: isFavorite ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  isFavorite
                      ? _favoriteList.remove(hash)
                      : _favoriteList.add(hash);
                  _setPrefs();
                });
              }),
        ],
      ),
    );
  }
}
