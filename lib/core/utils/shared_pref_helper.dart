import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper{
  static late final SharedPreferences _sharedPreferences;

  static Future<void> initialize() async{
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future addInt(String key,int value) async{
     await _sharedPreferences.setInt(key, value);
  }

  static int? getInt(String key){
    return _sharedPreferences.getInt(key);
  }
}