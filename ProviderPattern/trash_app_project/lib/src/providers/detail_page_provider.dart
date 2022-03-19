import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../services/rest_api_services.dart';

class DetailPageProvider extends ChangeNotifier {
  Uint8List? _staticMapImage;

  NaverMapAPI _naverMapAPI = NaverMapAPI();

  Uint8List? get staticMapImage => _staticMapImage;

  updateMapImage(double? x, double? y) async {
    if (x == null || y == null)
      _staticMapImage = null;
    else
      _staticMapImage = await _naverMapAPI.getStaticMapImage(x, y);
    notifyListeners();
  }
}
