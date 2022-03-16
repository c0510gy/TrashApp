import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrashCanListWidget extends StatefulWidget {
  final bool favoriteOnly;

  TrashCanListWidget({Key? key, required this.favoriteOnly}) : super(key: key);

  @override
  _TrashCanListWidget createState() => _TrashCanListWidget();
}

class _TrashCanListWidget extends State<TrashCanListWidget> {
  List<List<dynamic>> _trashCans = [];
  List<List<dynamic>> _trashCansOnList = [];
  List<String> _favoriteList = [];

  late SharedPreferences prefs;

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      _favoriteList = prefs.getStringList('favoriteList') ?? [];
    });
  }

  void _setPrefs() async {
    await prefs.setStringList('favoriteList', _favoriteList);
  }

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/trashcanlist.csv");
    _trashCans = const CsvToListConverter().convert(_rawData).sublist(1);
    setState(() {
      _trashCansOnList = _trashCans;
    });
  }

  _TrashCanListWidget() {
    _loadCSV();
    _loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final trashCansOnList = widget.favoriteOnly
        ? _trashCansOnList.where((row) {
            final title = row[1];
            final subtitle =
                '${row[2].toString().replaceAll('\n', ' ')} ${row[3].toString().replaceAll('\n', ' ')}';
            return _favoriteList.contains('${title}${subtitle}');
          }).toList()
        : _trashCansOnList;

    return Column(children: <Widget>[
      TextField(
        keyboardType: TextInputType.text,
        onChanged: (text) {
          List<List<dynamic>> newData = [
            ..._trashCans
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
        itemCount: trashCansOnList.length,
        itemBuilder: (_, index) {
          return Column(children: [
            _buildRow(
              trashCansOnList[index][1],
              '${trashCansOnList[index][2].toString().replaceAll('\n', ' ')} ${trashCansOnList[index][3].toString().replaceAll('\n', ' ')}',
            ),
            Divider(),
          ]);
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
