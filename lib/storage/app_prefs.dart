import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String USER_TOKEN= "USER_TOKEN";


class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);




Future<void> setUserTokenData(String value) async {
    await _sharedPreferences.setString(USER_TOKEN, value);
  }

  String getuserToken() {
    String? token = _sharedPreferences.getString(USER_TOKEN);
    return token ?? "";
  }



}