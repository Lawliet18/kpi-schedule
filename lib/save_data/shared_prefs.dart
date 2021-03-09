import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._();

  static SharedPreferences? _sharedPreferences;

  static Future init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveBool(String key, {required bool value}) async {
    await _sharedPreferences!.setBool(key, value);
  }

  static Future<void> saveString(String key, String value) async {
    await _sharedPreferences!.setString(key, value);
  }

  static Future<void> saveListString(String key, List<String> value) async {
    await _sharedPreferences!.setStringList(key, value);
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

  static void remove(String key) {
    _sharedPreferences!.remove(key);
  }
}
