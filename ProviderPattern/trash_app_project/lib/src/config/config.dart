import 'dart:convert';
import 'dart:io';

class Config {
  static late final config;

  static loadConfig() async {
    final configFile = File('assets/config.json');
    final jsonString = await configFile.readAsString();
    final dynamic jsonMap = jsonDecode(jsonString);
    config = jsonMap;
  }
}
