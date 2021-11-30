import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized(); // needed to access SharedPreferences
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  bool existsKey(String key) {
    return _sharedPreferences.containsKey(key);
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  int? getInt(String key) {
    return _sharedPreferences.getInt(key);
  }

  Future setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }

  Future setInt(String key, int value) {
    return _sharedPreferences.setInt(key, value);
  }
}
