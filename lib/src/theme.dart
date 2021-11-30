import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_app/src/persistence_service.dart';
import 'package:learn_app/src/service_locator.dart';

/// Manages the theme settings and provides change notifications.
class ThemeNotifier extends ChangeNotifier {
  final PersistenceService _persistenceService = getIt<PersistenceService>();

  Color _accentColor = Colors.blue;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeNotifier() {
    // load persisted theme information, fallback to default values (blue, system)
    _accentColor = Color(_persistenceService.getInt("accentColor") ?? Colors.blue.value);
    _themeMode = ThemeMode.values[_persistenceService.getInt("themeMode") ?? ThemeMode.system.index];
  }

  Color get accentColor {
    return _accentColor;
  }

  ThemeMode get themeMode {
    return _themeMode;
  }

  Future<void> changeAccentColor(Color accentColor) async {
    _accentColor = accentColor;
    await _persistenceService.setInt("accentColor", accentColor.value);
    notifyListeners();
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _persistenceService.setInt("themeMode", themeMode.index);
    notifyListeners();
  }
}
