import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'trash_can_list_widget.dart';

class TrashCanListPage extends StatefulWidget {
  @override
  _TrashCanListPage createState() => _TrashCanListPage();
}

class _TrashCanListPage extends State<TrashCanListPage> {
  List<List<dynamic>> _trashCans = [];

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/trashcanlist.csv");
    final trashCans = const CsvToListConverter().convert(_rawData);
    setState(() {
      _trashCans = trashCans.sublist(1);
    });
  }

  _TrashCanListPage() {
    _loadCSV();
  }

  @override
  Widget build(BuildContext context) {
    return _trashCans.length > 0
        ? TrashCanListWidget(
            trashCans: _trashCans,
          )
        : Container();
  }
}
