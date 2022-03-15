import 'package:flutter/material.dart';


class TrashCanListPage extends StatelessWidget {

  final _listTextStyle = TextStyle(color: Colors.black, fontFamily: 'GyeonggiLight');
  final mocklist = [
    'hello, world',
    'trash can 1',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: mocklist.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Text(mocklist[index], style: _listTextStyle),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
    );

  }
}
