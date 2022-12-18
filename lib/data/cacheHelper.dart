import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future saveStringData({String key, String value}) async {
    return sharedPreferences.setString(key, value);
  }

  static Future saveBoolData({String key, bool value}) async {
    return sharedPreferences.setBool(key, value);
  }

  static getData({String key}) {
    return sharedPreferences.get(key);
  }
}
