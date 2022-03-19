import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/key_value_table_widget.dart';
import '../models/trash_can_model.dart';
import '../providers/detail_page_provider.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final TrashCan trashCan;
  late final DetailPageProvider _detailPageProvider;

  DetailPage({Key? key, this.title = '쓰레기통 정보', required this.trashCan})
      : super(key: key);

  topContent(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/garbage-cans.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: Text(
              this.title,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 20.0,
          top: 30.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
      ],
    );
  }

  mainContent(context) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(40.0),
      child: Column(
        children: [
          KeyValueTableWidget(
            keys: ['설치장소', '자치구명', '도로(가로)명', '도로명주소', '지번주소', '영문주소'],
            values: [
              '${trashCan.location ?? ''}',
              '${trashCan.districtName ?? ''}',
              '${trashCan.streetName ?? ''}',
              '${trashCan.roadAddress ?? ''}',
              '${trashCan.jibunAddress ?? ''}',
              '${trashCan.englishAddress ?? ''}',
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 40,
            ),
            child: Consumer<DetailPageProvider>(
              builder: (_, provider, widget) => provider.staticMapImage != null
                  ? Image.memory(provider.staticMapImage!)
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _detailPageProvider =
        Provider.of<DetailPageProvider>(context, listen: false);
    _detailPageProvider.updateMapImage(trashCan.x, trashCan.y);

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            topContent(context),
            mainContent(context),
          ],
        ),
      ),
    );
  }
}
