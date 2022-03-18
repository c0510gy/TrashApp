import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trash_can_model.dart';

class TrashCansManager {
  SharedPreferences? prefs;

  TrashCansManager() {}

  Future<List<TrashCan>> loadTrashCans() async {
    final _rawData = await rootBundle.loadString("assets/trashcanlist.csv");
    final _trashCans = const CsvToListConverter().convert(_rawData).sublist(1);
    return _trashCans.map((e) => TrashCan.fromCSVRow(e)).toList();
  }

  Future<List<String>> loadFavoriteList() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    final _favoriteList = prefs?.getStringList('favoriteList') ?? [];
    return _favoriteList;
  }

  void updateFavoriteList(List<String> newFavoriteList) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    await prefs?.setStringList('favoriteList', newFavoriteList);
  }
}
