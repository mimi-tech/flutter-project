import 'package:flutter/cupertino.dart';

class MarketProductDetailStateManager extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void resetValue() {
    _currentIndex = 0;
    notifyListeners();
  }
}
