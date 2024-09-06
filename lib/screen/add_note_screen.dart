import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/controller/add_note_controller.dart';
import 'package:todo_app/helpers/constant.dart';
import 'package:todo_app/models/note_data_model.dart';
import 'package:todo_app/resources/routes/routes_name.dart';
import 'package:todo_app/utils/Utils.dart';

import '../models/db_models/note_database.dart';
import '../resources/colors/app_color.dart';
import '../resources/font/app_fonts.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final addNoteController = Get.put(AddNoteController());
  var noteData;

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null) {
      noteData = Get.arguments as NoteData;
    }

    if (noteData != null) {
      addNoteController.titleController.value.text = noteData.title;
      addNoteController.descriptionController.value.text = noteData.description;
      addNoteController.selectedDate.value = noteData.remainderDate;
      addNoteController.selectedTime.value = noteData.remainderTime;

      if (noteData.imageBytes != null) {
        addNoteController.imageBytes.value = base64Decode(noteData.imageBytes);
        // Convert Base64 string to File
        convertUint8ListToFile(
                base64Decode(noteData.imageBytes), 'note_image.jpg')
            .then((file) {
          addNoteController.setImage(file);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: AppColor.white,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Constants.dp_30,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColor.gray.withOpacity(0.3),
                ),
                margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
                constraints: const BoxConstraints(
                  minHeight: 54, // Set your minimum height here
                ),
                child: TextField(
                  controller: addNoteController.titleController.value,
                  maxLines: null, // Makes the TextField's height dynamic
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintText: "Add Title",
                    hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Constants.dp_16,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColor.gray.withOpacity(0.3),
                ),
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                constraints: const BoxConstraints(
                  minHeight: 220, // Set your minimum height here
                ),
                child: TextField(
                  autofocus: true,
                  controller: addNoteController.descriptionController.value,
                  maxLines: null,
                  // Makes the TextField's height dynamic
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    fillColor: Colors.transparent,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    hintText: "Add Title",
                    hintStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Constants.dp_16,
              ),
              Container(
                height: 54,
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColor.gray.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          addNoteController.selectedDate.isEmpty
                              ? "Select date"
                              : addNoteController.selectedDate.value,
                          style: const TextStyle(color: AppColor.gray),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await addNoteController.selectDatePickerDate(context);
                        },
                        child: const Icon(
                          Icons.calendar_month,
                          color: AppColor.gray,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Constants.dp_16,
              ),
              Container(
                height: 54,
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: AppColor.gray.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          addNoteController.selectedTime.isEmpty
                              ? "Select Time"
                              : addNoteController.selectedTime.value,
                          style: const TextStyle(color: AppColor.gray),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await addNoteController.selectRemainderTime(context);
                        },
                        child: const Icon(
                          Icons.access_alarm,
                          color: AppColor.gray,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Constants.dp_16,
              ),
              InkWell(
                onTap: () {
                  addNoteController.pickImageFromGallery();
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColor.gray.withOpacity(0.3),
                  ),
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  constraints: const BoxConstraints(
                    minHeight: 180, // Set your minimum height here
                  ),
                  child: Obx(() {
                    if (addNoteController.image == null) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: AppColor.gray,
                            size: 80,
                          ),
                        ],
                      );
                    } else {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          addNoteController.image!,
                          fit: BoxFit.cover,
                          width: MediaQuery.sizeOf(context).width,
                          height:
                              180, // Adjust the height according to your requirement
                        ),
                      );
                    }
                  }),
                ),
              ),
              SizedBox(
                height: Constants.dp_40,
              ),
              noteData != null
                  ? ElevatedButton(
                      onPressed: () async {
                        final Uint8List imageBytes = addNoteController.imageBytes.value!;
                        final String encodedImage = base64Encode(imageBytes);

                        final note = NoteDataModel(
                          title: addNoteController.titleController.value.text,
                          description: addNoteController
                              .descriptionController.value.text,
                          remainderDate: addNoteController.selectedDate.value,
                          remainderTime: addNoteController.selectedTime.value,
                          imageUri: encodedImage ?? "",
                        );

                        var isUpdated = await addNoteController.updateNoteOnIsarDataBase(noteData.id,note);

                        if (isUpdated) {
                          Utils.successToastMessage("Success");
                          Get.offNamed(RouteName.noteScreen, arguments: 'back');
                        } else {
                          Utils.errorToastMessage("Error");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.yellow,
                        disabledBackgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constants.dp_8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(
                            left: 32, right: 32, bottom: 8, top: 8),
                        child: Text(
                          "Update Note",
                          style: TextStyle(
                            fontFamily: AppFonts.schylerRegular,
                            color: Colors.white,
                            fontSize: Constants.dp_20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        final Uint8List imageBytes =
                            addNoteController.imageBytes.value!;
                        final String encodedImage = base64Encode(imageBytes);

                        final note = NoteDataModel(
                          title: addNoteController.titleController.value.text,
                          description: addNoteController
                              .descriptionController.value.text,
                          remainderDate: addNoteController.selectedDate.value,
                          remainderTime: addNoteController.selectedTime.value,
                          imageUri: encodedImage ?? "",
                        );

                        var isInserted =
                            await addNoteController.addNoteOnIsarDataBase(note);

                        if (isInserted) {
                          Utils.successToastMessage("Success");
                          Get.offNamed(RouteName.noteScreen, arguments: 'back');
                        } else {
                          Utils.errorToastMessage("Error");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.yellow,
                        disabledBackgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constants.dp_8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(
                            left: 32, right: 32, bottom: 8, top: 8),
                        child: Text(
                          "Add Note",
                          style: TextStyle(
                            fontFamily: AppFonts.schylerRegular,
                            color: Colors.white,
                            fontSize: Constants.dp_20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> convertUint8ListToFile(Uint8List data, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$fileName').create();
    file.writeAsBytesSync(data);
    return file;
  }
}
