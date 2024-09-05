import 'dart:convert';
import 'dart:math';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_app/resources/colors/app_color.dart';
import '../controller/login_controller.dart';
import '../helpers/constant.dart';
import '../resources/assets/asset_icon.dart';
import '../resources/font/app_fonts.dart';
import '../resources/routes/routes_name.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final loginVM = Get.put(LoginViewModel()) ;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.white,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: SvgPicture.asset(
                ImageAssets.app_icon,
                width: Constants.dp_110,
                height: Constants.dp_110,
              ),
            ),
            SizedBox(height: Constants.dp_60,),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 58,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
              child: TextField(
                controller: loginVM.emailController.value,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: "Email",
                  hintStyle: const TextStyle(
                    color: Colors.black45,
                    fontSize: 19,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 58,
              margin: EdgeInsets.only(left: 16, right: 16, top: 12),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                controller: loginVM.passwordController.value,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    color: Colors.black45,
                    fontSize: 19,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Constants.dp_24),
            ElevatedButton(
              onPressed: () async{
                bool isSignedIn = await loginVM.getSignIn(
                  loginVM.emailController.value.text,
                  loginVM.passwordController.value.text,
                );

                if (isSignedIn) {
                  Future.delayed(Duration.zero, () {
                    Get.offNamed(RouteName.noteScreen);
                  });
                } else {

                  Get.snackbar('Error', 'Sign-in failed, please try again');
                }

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.yellow,
                disabledBackgroundColor: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.dp_8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(Constants.dp_8),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: AppFonts.schylerRegular,
                    color: Colors.white,
                    fontSize: Constants.dp_20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
