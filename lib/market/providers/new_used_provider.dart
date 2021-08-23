import 'package:flutter/material.dart';

class NewUsedProvider with ChangeNotifier {
  // Boolean for the AppBar NewUsed Switch. The button is toggled to 'true' by default ('true' == New)
  bool _newUsedSwitch = true;

  // Getter for the _newUsedSwitch
  bool get newUsedSwitch => _newUsedSwitch;

  void newSwitch() {
    if (!_newUsedSwitch) {
      _newUsedSwitch = true;
      notifyListeners();
    }
  }

  void usedSwitch() {
    if (_newUsedSwitch) {
      _newUsedSwitch = false;
      notifyListeners();
    }
  }
}
