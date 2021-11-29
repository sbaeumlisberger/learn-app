import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_app/src/persistence_service.dart';
import 'package:learn_app/src/service_locator.dart';

class ThemeNotifier extends ChangeNotifier {
  final PersistenceService _persistenceService = getIt<PersistenceService>();

  Color accentColor = Colors.blue;
  ThemeMode themeMode = ThemeMode.system;

  ThemeNotifier() {
    accentColor = Color(_persistenceService.getInt("accentColor") ?? Colors.blue.value);
    themeMode = ThemeMode.values[_persistenceService.getInt("themeMode") ?? ThemeMode.system.index];
  }

  void changeAccentColor(Color accentColor) {
    this.accentColor = accentColor;
    _persistenceService.setInt("accentColor", accentColor.value);
    notifyListeners();
  }

  void changeThemeMode(ThemeMode themeMode) {
    this.themeMode = themeMode;
    _persistenceService.setInt("themeMode", themeMode.index);
    notifyListeners();
  }
}
