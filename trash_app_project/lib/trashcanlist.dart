import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class TrashCanListPage extends StatefulWidget {
  @override
  _TrashCanListPage createState() => _TrashCanListPage();
}

class _TrashCanListPage extends State<TrashCanListPage> {

  List<List<dynamic>> _data = [];

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/trashcanlist.csv");
    List<List<dynamic>> _listData = const CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listData;
    });
  }

  _TrashCanListPage(){
    _loadCSV();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return Card(
            margin: const EdgeInsets.all(3),
            color: index == 0 ? Colors.amber : Colors.white,
            child: ListTile(
              leading: Text(_data[index][0].toString()),
              title: Text(_data[index][1]),
              subtitle: Text(_data[index][2].toString().replaceAll('\n', ' ')),
              trailing: Text(_data[index][3].toString().replaceAll('\n', ' ')),
            ),
          );
        },
      );
  }
}
