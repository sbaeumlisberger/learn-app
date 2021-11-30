import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to persist data as simple key value pairs. Call the init method before accessing any other method.
class PersistenceService {
  late SharedPreferences _sharedPreferences;

  /// Initializes the persistence service.
  /// This method must be called before calling any other method.
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
