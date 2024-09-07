import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/models/db_models/note_database.dart';
import 'package:todo_app/storage/app_database_manager.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as datatTimePicker;
import '../resources/colors/app_color.dart';
import '../services/notifi_service.dart';

class AddNoteController extends GetxController {

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

  void setImage(File file) {
    _image.value = file;
  }



  Future<bool> addNoteOnIsarDataBase(NoteData note) async{
    final success = await appDatabaseManager.insertNoteData(note);
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
   /* initialDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
        barrierDismissible: false,
        builder: (context, child) {
          return Localizations.override(
            context: context,
            delegates: const [
              DefaultMaterialLocalizations.delegate
            ],
            child: Theme(
              data: ThemeData(
                useMaterial3: true,
                colorScheme: const ColorScheme.dark(
                    primary: AppColor.primaryColor,
                    onPrimary: AppColor.white,
                    surface: AppColor.white,
                    onSurface: AppColor.black,
                    primaryContainer: AppColor.primaryColor),
              ),
              child: child ?? const SizedBox(),
            ),
          );
        },
        context: context,

        initialDate: initialDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2100));



    if (picked != null) {
      isDateSelected.value = true;
      var formatter = DateFormat('yyyy-MM-dd');
      String formattedDate = formatter.format(picked);
      selectedDate.value = formattedDate;
    }else{
      isDateSelected.value = false;
    }*/
    datatTimePicker.DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onChanged: (date) => scheduleTime.value = date,
      onConfirm: (date) {},
    );
  }

 /* Future<void> selectRemainderTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      builder: (context, child) {
        return Localizations.override(
          context: context,
          delegates: const [
            DefaultMaterialLocalizations.delegate
          ],
          child: Theme(
            data: ThemeData(
              useMaterial3: true,
              colorScheme:const ColorScheme.dark(
                  primary: AppColor.primaryColor,
                  onPrimary: AppColor.white,
                  surface: AppColor.white,
                  onSurface: AppColor.black,
                  primaryContainer: AppColor.primaryColor),
            ),
            child: child ?? const SizedBox(),
          ),
        );
      },
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      isTimeSelected.value = true;
      selectedTime.value = picked.format(context);
    } else {
      isTimeSelected.value = false;
    }
  }*/


  Future<bool> updateNoteOnDataBase(Id noteId, NoteData task) async{
    int validId = (task.id.toInt() & 0x7FFFFFFF);
    await NotificationService().scheduleNotification(
        id: validId,
        title: task.title,
        body: '${task.remainderDateTime}',
        scheduledNotificationDateTime: DateTime.parse(task.remainderDateTime));

    final success = await appDatabaseManager.updateNoteById(noteId, task);
    if (success) {
      return true;
    } else {
      return false;
    }

  }



}