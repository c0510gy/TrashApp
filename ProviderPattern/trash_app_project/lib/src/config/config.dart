import 'dart:convert';
import 'package:flutter/services.dart';

class Config {
  static dynamic config;

  static loadConfig() async {
    final jsonString = await rootBundle.loadString("assets/config.json");
    final dynamic jsonMap = jsonDecode(jsonString);
    config = jsonMap;

    await Future.delayed(Duration(seconds: 1));
  }
}
