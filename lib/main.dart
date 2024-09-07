import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/resources/localization/languages.dart';
import 'package:todo_app/resources/routes/routes.dart';
import 'package:todo_app/resources/routes/routes_name.dart';
import 'package:todo_app/storage/app_prefs.dart';
import 'package:todo_app/helpers/di.dart';
import 'package:todo_app/helpers/theme.dart';

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
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      initialRoute: initialRoute,
      getPages: AppRoutes.appRoutes(),
    );
  }
}


Future<String> getInitialRoute() async {
  final userToken = instance<AppPreferences>().getuserToken();

  if (userToken.isNotEmpty) {
    return RouteName.noteScreen;
  } else {
    return RouteName.loginView;
  }
}


