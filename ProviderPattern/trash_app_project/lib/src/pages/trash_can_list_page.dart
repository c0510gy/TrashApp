import 'package:flutter/material.dart';
import '../components/trash_can_list_widget.dart';

class TrashCanListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TrashCanListWidget(favoriteOnly: false);
  }
}
