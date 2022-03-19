import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/detail_page.dart';
import '../providers/trash_cans_provider.dart';
import '../models/trash_can_model.dart';

class TrashCanListWidget extends StatelessWidget {
  final bool favoriteOnly;
  late final TrashCansProvider _trashCansProvider;

  TrashCanListWidget({Key? key, required this.favoriteOnly}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _trashCansProvider = Provider.of<TrashCansProvider>(context, listen: false);
    _trashCansProvider.loadTrashCans(favoriteOnly);

    return Column(
      children: <Widget>[
        TextField(
          keyboardType: TextInputType.text,
          onChanged: (text) {
            _trashCansProvider.searchTrashCans(text);
          },
          decoration: InputDecoration(
            hintText: '검색',
            border: InputBorder.none,
            icon: Padding(
                padding: EdgeInsets.only(left: 13), child: Icon(Icons.search)),
          ),
        ),
        Divider(),
        Consumer<TrashCansProvider>(
          builder: (_, provider, widget) => Expanded(
            child: ListView.builder(
              itemCount: provider.trashCansOnList.length,
              itemBuilder: (_, index) {
                return Column(
                  children: [
                    _buildRow(
                        context, provider.trashCansOnList[index], provider),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
      BuildContext ctx, TrashCan trashCan, TrashCansProvider provider) {
    final title = trashCan.districtName ?? '';
    final subtitle = '${trashCan.streetName} ${trashCan.location}';
    final hash = trashCan.hash;
    final isFavorite = provider.favoriteList.contains(hash);

    return InkWell(
      onTap: () => Navigator.push(
        ctx,
        MaterialPageRoute(builder: (context) => DetailPage(trashCan: trashCan)),
      ),
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
                isFavorite
                    ? _trashCansProvider.removeFavorite(hash)
                    : _trashCansProvider.addFavorite(hash);
              },
            ),
          ],
        ),
      ),
    );
  }
}
