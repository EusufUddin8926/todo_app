import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as datatTimePicker;
import '../models/db_models/note_database.dart';
import '../services/notification_service.dart';
import '../storage/app_database_manager.dart';
import '../storage/app_prefs.dart';
import '../helpers/di.dart';

class NoteController extends GetxController {


  final AppDatabaseManager _databaseManager = AppDatabaseManager();
  var notes = <NoteData>[].obs;
  final descriptionController = TextEditingController().obs;
  final titleController = TextEditingController().obs;
  final ImagePicker _picker = ImagePicker();
  final _image = Rxn<File>();
  late DateTime initialDate;
  RxBool isDateSelected = false.obs;
  Rx<DateTime> scheduleTime = DateTime.now().obs;
  RxBool isTimeSelected = false.obs;
  // RxString selectedTime = ''.obs;
  final imageBytes = Rxn<Uint8List>();
  static final appDatabaseManager = AppDatabaseManager();
  // Getter for image
  File? get image => _image.value;

  void setImage(File? file) {
    _image.value = file;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllNotes();
  }


  Future<bool> addNoteOnIsarDataBase(NoteData note) async{
    final success = await appDatabaseManager.insertNoteData(note);
    if (success) {
      return true;
    } else {
      return false;
    }

  }

  Future<bool> updateNoteOnDataBase(Id noteId, NoteData task) async{
    int validId = (task.id.toInt() & 0x7FFFFFFF);
    await NotificationService().scheduleNotification(
        id: validId,
        title: task.title,
        payLoad: validId.toString(),
        body: '${task.remainderDateTime}',
        scheduledNotificationDateTime: DateTime.parse(task.remainderDateTime));

    final success = await appDatabaseManager.updateNoteById(noteId, task);
    if (success) {
      return true;
    } else {
      return false;
    }

  }


  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image.value = File(pickedFile.path);
      Uint8List imageData = (await image?.readAsBytes()) as Uint8List;
      imageBytes.value = imageData;
    }
  }

  Future<void> selectDatePickerDate(BuildContext context) async {
    datatTimePicker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onChanged: (date){
        scheduleTime.value = date;
        isDateSelected.value = true;
      },
      onConfirm: (date) {},
    );
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

  Future<NoteData> fetchNoteById(Id noteId) async {
    try {
      // Fetch notes from the database
      final note = await _databaseManager.fetchNoteById(noteId);
      // Check if note is null and throw an exception if it is
      return note;
        } catch (e) {
      // Handle any errors that occur during fetching
      if (kDebugMode) {
        print('Error fetching note: $e');
      }
      // Rethrow the exception or handle it according to your requirements
      throw Exception('Failed to fetch note with ID $noteId');
    }
  }


  Future<bool> logoutUser() async{
    try {
      instance<AppPreferences>().setUserTokenData("");
      return true;
    } catch (e) {
      // Handle any errors that occur during fetching
      if (kDebugMode) {
        print('Error fetching notes: $e');
      }
      return false;
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
  int validId = (task.id.toInt() & 0x7FFFFFFF);

    await NotificationService().scheduleNotification(
      id: validId,
      title: task.title,
      payLoad: validId.toString(),
      body: '${task.remainderDateTime}',
      scheduledNotificationDateTime: DateTime.parse(task.remainderDateTime));

    final success = await _databaseManager.updateNoteRemainderById(noteId, true);
    if (success) {
      return true;
    } else {
      return false;
    }

  }

  Future<bool> updateNoteCompletedOnDataBase(Id noteId) async{

    final success = await _databaseManager.updateNoteCompletedById(noteId, true);
    if (success) {
      return true;
    } else {
      return false;
    }

  }


}