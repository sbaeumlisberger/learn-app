import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  Color accentColor = Colors.blue;
  ThemeMode themeMode = ThemeMode.system;

  void changeAccentColor(Color accentColor) {
    this.accentColor = accentColor;
    notifyListeners();
  }

  void changeThemeMode(ThemeMode themeMode) {
    this.themeMode = themeMode;
    notifyListeners();
  }
}
