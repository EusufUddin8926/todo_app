import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/resources/getx_localization/languages.dart';
import 'package:todo_app/resources/routes/routes.dart';
import 'package:todo_app/screen/login_screen.dart';
import 'package:todo_app/utils/di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initAppModule();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TODO App',
      debugShowCheckedModeBanner: false,
      translations: Languages(),
      locale:  const Locale('en' ,'US'),
      fallbackLocale:  const Locale('en' ,'US'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      getPages: AppRoutes.appRoutes(),
    );
  }
}


