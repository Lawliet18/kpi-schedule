import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._() {
    init();
  }
  SharedPreferences? _sharedPreferences;
  static SharedPref sharedPref = SharedPref._();

  Future init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  Future<void> saveBool(String key, {required bool value}) async {
    await _sharedPreferences!.setBool(key, value);
  }

  Future<void> saveString(String key, String value) async {
    await _sharedPreferences!.setString(key, value);
  }

  Future<void> saveListString(String key, List<String> value) async {
    await _sharedPreferences!.setStringList(key, value);
  }

  Future<bool> loadBool(String key) async {
    return _sharedPreferences!.getBool(key) ?? true;
  }

  Future<String> loadString(String key) async {
    return _sharedPreferences!.getString(key) ?? '';
  }

  Future<List<String>> loadListString(String key) async {
    return _sharedPreferences!.getStringList(key) ?? [];
  }

  void remove(String key) {
    _sharedPreferences!.remove(key);
  }
}
