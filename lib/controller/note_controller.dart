import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:isar/isar.dart';

import '../models/db_models/note_database.dart';
import '../services/notifi_service.dart';
import '../storage/app_database_manager.dart';

class NoteController extends GetxController {


  final AppDatabaseManager _databaseManager = AppDatabaseManager();
  var notes = <NoteData>[].obs;

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


  Future<bool> deleteNote(Id noteId) async {
    try {
      final isNoteDeleted = await _databaseManager.deleteNoteById(noteId);
      if (isNoteDeleted) {
        // Update the observable list by removing the deleted note
        notes.removeWhere((note) => note.id == noteId);
        return true; // Note successfully deleted
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting note: $e');
      }
      return false;
    }
    return false;
  }

Future<bool> updateNoteRemainderOnDataBase(Id noteId, NoteData task) async{


    await NotificationService().scheduleNotification(
      id: task.id,
      title: task.title,
      body: '${task.remainderDateTime}',
      scheduledNotificationDateTime: DateTime.parse(task.remainderDateTime));

    final success = await _databaseManager.updateNoteRemainderById(noteId, true);
    if (success) {
      return true;
    } else {
      return false;
    }

  }


}