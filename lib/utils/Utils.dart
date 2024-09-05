import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../resources/colors/app_color.dart';

class Utils {
  static const double EARTH_RADIUS = 6371000;

  static void fieldFocusChange(BuildContext context , FocusNode current , FocusNode  nextFocus ){
    current.unfocus();
    Future.delayed(const Duration(milliseconds: 500), () => FocusScope.of(context).requestFocus(nextFocus));

  }


  static void successToastMessage(String message){
    Fluttertoast.showToast(
      msg: message ,
      backgroundColor: AppColor.primaryColor ,
      textColor: AppColor.whiteColor,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static errorToastMessage(String message){
    Fluttertoast.showToast(
      msg: message ,
      backgroundColor: AppColor.red,
      textColor: AppColor.whiteColor,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  static warningToastMessage(String message){
    Fluttertoast.showToast(
      msg: message ,
      backgroundColor: AppColor.yellow ,
      textColor: AppColor.whiteColor,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,


    );
  }


}