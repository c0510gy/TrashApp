import 'package:flutter/material.dart';
import 'trash_can_list_widget.dart';

class FavoriteteTrashCanListPage extends StatefulWidget {
  @override
  _FavoriteteTrashCanListPage createState() => _FavoriteteTrashCanListPage();
}

class _FavoriteteTrashCanListPage extends State<FavoriteteTrashCanListPage> {
  @override
  Widget build(BuildContext context) {
    return TrashCanListWidget(favoriteOnly: true);
  }
}
