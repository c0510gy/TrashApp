import 'package:flutter/material.dart';
import '../components/trash_can_list_widget.dart';

class FavoriteteTrashCanListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TrashCanListWidget(favoriteOnly: true);
  }
}
