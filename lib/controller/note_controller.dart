import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:todo_app/models/note_data_model.dart';

import '../models/db_models/note_database.dart';
import '../storage/app_database_manager.dart';

class NoteController extends GetxController {

  var notes = <NoteData>[].obs;

  final AppDatabaseManager _databaseManager = AppDatabaseManager();

  @override
  void onInit() {
    super.onInit();
    fetchAllNotes();
  }


  Future<void> fetchAllNotes() async {
    try {
      // Fetch notes from the database
      final fetchedNotes = await _databaseManager.getAllNotes();
      // Update the observable list
      notes.value = fetchedNotes;
    } catch (e) {
      // Handle any errors that occur during fetching
      if (kDebugMode) {
        print('Error fetching notes: $e');
      }
      // Optionally handle errors, e.g., show a toast or dialog
    }
  }

}