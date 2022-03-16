import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrashCanListWidget extends StatefulWidget {
  final List<List<dynamic>> trashCans;

  TrashCanListWidget({Key? key, required this.trashCans}) : super(key: key);

  @override
  _TrashCanListWidget createState() => _TrashCanListWidget(trashCans);
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

  _TrashCanListWidget(List<List<dynamic>> trashCans) {
    _trashCans = trashCans;
    _trashCansOnList = trashCans;
    _loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: _trashCansOnList.length,
        itemBuilder: (_, index) {
          return Column(children: [
            _buildRow(
              _trashCansOnList[index][1],
              '${_trashCansOnList[index][2].toString().replaceAll('\n', ' ')} ${_trashCansOnList[index][3].toString().replaceAll('\n', ' ')}',
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
