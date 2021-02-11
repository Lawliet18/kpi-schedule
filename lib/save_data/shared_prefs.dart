import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPreferences;

  static Future init() async {
    if (_sharedPreferences == null) {
      _sharedPreferences = await SharedPreferences.getInstance();
    }
  }

  static saveBool(String key, bool value) {
    _sharedPreferences!.setBool(key, value);
  }

  static saveString(String key, String value) {
    _sharedPreferences!.setString(key, value);
  }

  static saveListString(String key, List<String> value) {
    _sharedPreferences!.setStringList(key, value);
  }

  static Future<bool> loadBool(String key) async {
    return _sharedPreferences!.getBool(key) ?? true;
  }

  static Future<String> loadString(String key) async {
    return _sharedPreferences!.getString(key) ?? '';
  }

  static Future<List<String>> loadListString(String key) async {
    return _sharedPreferences!.getStringList(key) ?? [];
  }

  static remove(String key) {
    _sharedPreferences!.remove(key);
  }
}
