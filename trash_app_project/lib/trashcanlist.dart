import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class TrashCanListPage extends StatefulWidget {
  @override
  _TrashCanListPage createState() => _TrashCanListPage();
}

class _TrashCanListPage extends State<TrashCanListPage> {
  List<List<dynamic>> _trashCans = [];
  List<List<dynamic>> _trashCansOnList = [];

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/trashcanlist.csv");
    _trashCans = const CsvToListConverter().convert(_rawData);
    setState(() {
      _trashCansOnList = _trashCans;
    });
  }

  _TrashCanListPage() {
    _loadCSV();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        keyboardType: TextInputType.text,
        onChanged: (text) {
          List<List<dynamic>> newData = [
            _trashCans[0],
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
                padding: EdgeInsets.only(left: 13), child: Icon(Icons.search))),
      ),
      Expanded(
          child: ListView.builder(
        itemCount: _trashCansOnList.length,
        itemBuilder: (_, index) {
          return Card(
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
          );
        },
      )),
    ]);
  }
}
