import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String USER_TOKEN= "USER_TOKEN";


class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  /*Future<void> saveCredential(SharedPrefDto value) async {
    await _sharedPreferences.setString(PREFS_KEY_CRENDENTIAL, jsonEncode(value.toJson()));
  }

  SharedPrefDto? getCredential() {
    String? jsonString = _sharedPreferences.getString(PREFS_KEY_CRENDENTIAL);
    SharedPrefDto? data =
    jsonString != null ? SharedPrefDto.fromJson(jsonDecode(jsonString)) : null;
    return data;
  }

Future<void> removeCredential() async {
   _sharedPreferences.remove(PREFS_KEY_CRENDENTIAL);
}*/


Future<void> setUserTokenData(String value) async {
    await _sharedPreferences.setString(USER_TOKEN, value);
  }

  String getuserInfoAlldata() {
    String? token = _sharedPreferences.getString(USER_TOKEN);
    return token ?? "";
  }



}