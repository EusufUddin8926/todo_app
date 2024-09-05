import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/resources/getx_localization/languages.dart';
import 'package:todo_app/resources/routes/routes.dart';
import 'package:todo_app/resources/routes/routes_name.dart';
import 'package:todo_app/storage/app_prefs.dart';
import 'package:todo_app/utils/di.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

 await initAppModule();

  String initialRoute = await getInitialRoute();

  runApp( MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});


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
      initialRoute: initialRoute,
      getPages: AppRoutes.appRoutes(),
    );
  }
}


Future<String> getInitialRoute() async {
  final userToken = instance<AppPreferences>().getuserToken();

  if (userToken.isNotEmpty) {
    return RouteName.noteScreen; // Navigate to Dashboard if user is already signed in
  } else {
    return RouteName.loginView; // Navigate to Login if no user token is found
  }
}


