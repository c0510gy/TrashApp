import 'package:flutter/material.dart';
import '../models/trash_can_model.dart';
import '../services/local_storage_services.dart';

class TrashCansProvider extends ChangeNotifier {
  List<TrashCan> _trashCans = [];
  List<TrashCan> _trashCansOnList = [];
  List<String> _favoriteList = [];

  List<TrashCan> get trashCans => _trashCans;
  List<TrashCan> get trashCansOnList => _trashCansOnList;
  List<String> get favoriteList => _favoriteList;

  TrashCansManager _trashCansManager = TrashCansManager();

  loadTrashCans(bool favoriteOnly) async {
    _trashCans = await _trashCansManager.loadTrashCans();
    _favoriteList = await _trashCansManager.loadFavoriteList();
    _trashCans = favoriteOnly
        ? _trashCans.where((e) {
            return _favoriteList.contains(e.hash);
          }).toList()
        : _trashCans;
    _trashCansOnList = _trashCans;
    notifyListeners();
  }

  searchTrashCans(String query) async {
    List<TrashCan> newData = [
      ..._trashCans
          .where((e) =>
              '${e.districtName}${e.streetName}${e.location}'.contains(query))
          .toList()
    ];
    _trashCansOnList = newData;
    notifyListeners();
  }

  addFavorite(String hash) {
    _favoriteList.add(hash);
    _trashCansManager.updateFavoriteList(_favoriteList);
    notifyListeners();
  }

  removeFavorite(String hash) {
    _favoriteList.remove(hash);
    _trashCansManager.updateFavoriteList(_favoriteList);
    notifyListeners();
  }
}
