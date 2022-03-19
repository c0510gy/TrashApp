import 'package:flutter/material.dart';

class KeyValueTableWidget extends StatelessWidget {
  final List<String> keys;
  final List<String> values;
  final double height;

  KeyValueTableWidget(
      {Key? key, required this.keys, required this.values, this.height = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: keys
                .map((e) => SizedBox(child: Text(e), height: height))
                .toList(),
          ),
          Column(
            children: keys
                .map((_) => SizedBox(
                      child: VerticalDivider(color: Colors.black),
                      height: height,
                    ))
                .toList(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: values
                .map((e) => SizedBox(child: Text(e), height: height))
                .toList(),
          )
        ],
      ),
    );
  }
}
