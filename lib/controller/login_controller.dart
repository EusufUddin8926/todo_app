

import 'dart:convert';
import 'dart:math';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../storage/app_prefs.dart';
import '../utils/di.dart';

class LoginViewModel extends GetxController {

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;


  Future<bool> getSignIn(String email, String password) async{
    try{
      if(instance<AppPreferences>().getuserToken().isEmpty){
        final secretKeyString = generateSecretKey(32);
        final secretKey = SecretKey(secretKeyString);
        final jwt = JWT(
          {
            'id': DateTime.now().second,
            'email': email,
            'password': password,
            'role': 'User',
          },
        );
        final token = jwt.sign(secretKey);
        instance<AppPreferences>().setUserTokenData(token);
        return true;
      }else{
        return true;
      }

    }catch(e){
      print('Sign in error occurred: $e');
      return false;
    }
  }


  String generateSecretKey(int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

}