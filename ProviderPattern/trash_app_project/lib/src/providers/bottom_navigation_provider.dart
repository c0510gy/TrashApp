import 'package:flutter/material.dart';

class BottomNavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
