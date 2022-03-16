import 'package:flutter/material.dart';
import 'trash_can_list_widget.dart';

class TrashCanListPage extends StatefulWidget {
  @override
  _TrashCanListPage createState() => _TrashCanListPage();
}

class _TrashCanListPage extends State<TrashCanListPage> {
  @override
  Widget build(BuildContext context) {
    return TrashCanListWidget(favoriteOnly: false);
  }
}
