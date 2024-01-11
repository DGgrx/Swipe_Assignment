import 'package:flutter/material.dart';

class DarkThemeVm with ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    notifyListeners();
  }

  void toggleTheme(){
    _darkTheme = !_darkTheme;
    notifyListeners();
  }

}