import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:todo_app/resources/colors/app_color.dart';
import 'package:todo_app/utils/Utils.dart';
import '../controller/login_controller.dart';
import '../helpers/constant.dart';
import '../resources/assets/asset_icon.dart';
import '../resources/font/app_fonts.dart';
import '../resources/routes/routes_name.dart';
import '../utils/theme.dart';

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
      resizeToAvoidBottomInset: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: AppColor.white,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child:_loginBody(),
        ),
      ),
    );
  }


 Widget _loginBody() {
    return  Column(
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
                fontSize: 16,
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
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: Constants.dp_24),
        ElevatedButton(
          onPressed: () async{
            String emailPattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
            RegExp emailRegExp = RegExp(emailPattern);

            if (loginVM.emailController.value.text.isEmpty) {
              Utils.warningToastMessage("Email cannot be empty!");
              return;
            }

            if (!emailRegExp.hasMatch(loginVM.emailController.value.text)) {
              Utils.warningToastMessage("Email format is not valid!");
              return;
            }

            if (loginVM.passwordController.value.text.isEmpty) {
              Utils.warningToastMessage("Password cannot be empty!");
              return;
            }

            if (loginVM.passwordController.value.text.length < 4) {
              Utils.warningToastMessage("Password must be at least 4 characters long!");
              return;
            }


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
            backgroundColor: primaryClr,
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
    );
  }

}
