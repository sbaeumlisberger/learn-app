import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
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

  void setString(String key, String value) {
    _sharedPreferences.setString(key, value);
  }

  void setInt(String key, int value) {
    _sharedPreferences.setInt(key, value);
  }
}
