import 'package:get/get.dart';
import 'package:todo_app/resources/routes/routes_name.dart';
import 'package:todo_app/screen/login_screen.dart';
import 'package:todo_app/screen/note_screen.dart';

class AppRoutes {

  static appRoutes() => [

    GetPage(
      name: RouteName.loginView,
      page: () => const LoginScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      transition: Transition.leftToRightWithFade ,
    ) ,

    GetPage(
      name: RouteName.noteScreen,
      page: () => const NoteScreen(),
      transitionDuration: const Duration(milliseconds: 500),
      transition: Transition.leftToRightWithFade ,
    ) ,

  ];

}