import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_app/src/persistence_service.dart';
import 'package:learn_app/src/service_locator.dart';

class ThemeNotifier extends ChangeNotifier {
  final PersistenceService _persistenceService = getIt<PersistenceService>();

  Color _accentColor = Colors.blue;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeNotifier() {
    _accentColor = Color(_persistenceService.getInt("accentColor") ?? Colors.blue.value);
    _themeMode = ThemeMode.values[_persistenceService.getInt("themeMode") ?? ThemeMode.system.index];
  }

  Color get accentColor {
    return _accentColor;
  }

  ThemeMode get themeMode {
    return _themeMode;
  }

  void changeAccentColor(Color accentColor) {
    _accentColor = accentColor;
    _persistenceService.setInt("accentColor", accentColor.value);
    notifyListeners();
  }

  void changeThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    _persistenceService.setInt("themeMode", themeMode.index);
    notifyListeners();
  }
}
