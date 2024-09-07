import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/note_controller.dart';
import '../models/db_models/note_database.dart';
import '../services/notification_service.dart';
import '../storage/app_prefs.dart';
import 'package:timezone/data/latest.dart' as tz;

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // Initialize Isar database
  final directory = await getApplicationDocumentsDirectory();
  final databasePath = directory.path;
  final database = await Isar.open(
    [NoteDataSchema],
    directory: databasePath,
    inspector: true,
  );
  instance.registerLazySingleton<Isar>(() => database);

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance<SharedPreferences>()));

  Get.lazyPut(()=>NoteController());

  // Initialize time zones
  tz.initializeTimeZones();

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initNotification();


}
