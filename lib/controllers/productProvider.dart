import 'package:flutter/material.dart';

class ProductNotifier extends ChangeNotifier {
  int _activePage = 0;
  List<dynamic> _shoeSize = [];

  int get activePage => _activePage;

  set activePage(int newIndex) {
    _activePage = newIndex;
    notifyListeners();
  }

  List<dynamic> get shoeSize => _shoeSize;

  set shoeSize(List<dynamic> newSize) {
    _shoeSize = newSize;
    notifyListeners();
  }

  void toggleCheck(int index) {
    for (int i = 0; i < _shoeSize.length; i++) {
      if (i == index) {
        _shoeSize[i]['isSelected'] = !_shoeSize[i]['isSelected'];
      }
    }
    notifyListeners();
  }
}
