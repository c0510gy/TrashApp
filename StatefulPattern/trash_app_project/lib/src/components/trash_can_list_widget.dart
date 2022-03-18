import 'package:flutter/material.dart';
import '../pages/detail_page.dart';
import '../services/local_storage_services.dart';
import '../models/trash_can_model.dart';

class TrashCanListWidget extends StatefulWidget {
  final bool favoriteOnly;

  TrashCanListWidget({Key? key, required this.favoriteOnly}) : super(key: key);

  @override
  _TrashCanListWidget createState() => _TrashCanListWidget();
}

class _TrashCanListWidget extends State<TrashCanListWidget> {
  List<TrashCan> _trashCans = [];
  List<TrashCan> _trashCansOnList = [];
  List<String> _favoriteList = [];

  TrashCansManager _trashCansManager = TrashCansManager();

  void _loadTrashCans() async {
    _trashCans = await _trashCansManager.loadTrashCans();
    final favoriteList = await _trashCansManager.loadFavoriteList();
    setState(() {
      _trashCansOnList = _trashCans;
      _favoriteList = favoriteList;
    });
  }

  _TrashCanListWidget() {
    _loadTrashCans();
  }

  @override
  Widget build(BuildContext context) {
    final trashCansOnList = widget.favoriteOnly
        ? _trashCansOnList.where((e) {
            return _favoriteList.contains(e.hash);
          }).toList()
        : _trashCansOnList;

    return Column(children: <Widget>[
      TextField(
        keyboardType: TextInputType.text,
        onChanged: (text) {
          List<TrashCan> newData = [
            ..._trashCans
                .where((e) => '${e.districtName}${e.streetName}${e.location}'
                    .contains(text))
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
              padding: EdgeInsets.only(left: 13), child: Icon(Icons.search)),
        ),
      ),
      Divider(),
      Expanded(
          child: ListView.builder(
        itemCount: trashCansOnList.length,
        itemBuilder: (_, index) {
          return Column(children: [
            _buildRow(trashCansOnList[index]),
            Divider(),
          ]);
        },
      )),
    ]);
  }

  Widget _buildRow(TrashCan trashCan) {
    final title = trashCan.districtName ?? '';
    final subtitle = '${trashCan.streetName} ${trashCan.location}';
    final hash = trashCan.hash;
    final isFavorite = _favoriteList.contains(hash);

    return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(address: subtitle))),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.star,
                    color: isFavorite ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite
                          ? _favoriteList.remove(hash)
                          : _favoriteList.add(hash);
                      _trashCansManager.updateFavoriteList(_favoriteList);
                    });
                  }),
            ],
          ),
        ));
  }
}
