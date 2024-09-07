import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/helpers/theme_services.dart';
import 'package:todo_app/resources/getx_localization/languages.dart';
import 'package:todo_app/resources/routes/routes.dart';
import 'package:todo_app/resources/routes/routes_name.dart';
import 'package:todo_app/services/notifi_service.dart';
import 'package:todo_app/storage/app_prefs.dart';
import 'package:todo_app/utils/di.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/utils/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

 await initAppModule();
  await GetStorage.init();
  NotificationService().initNotification();
  tz.initializeTimeZones();
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


