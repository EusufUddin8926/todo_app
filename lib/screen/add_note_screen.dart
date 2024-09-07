import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/controller/note_controller.dart';
import 'package:todo_app/helpers/constant.dart';
import 'package:todo_app/resources/assets/asset_icon.dart';
import '../models/db_models/note_database.dart';
import '../resources/colors/app_color.dart';
import '../resources/components/input_field.dart';
import '../resources/routes/routes_name.dart';
import '../utils/Utils.dart';
import '../utils/theme.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final noteController = Get.put(NoteController());
  var noteData;
  int _selectedColor = 0;
  String _selectedRepeat = 'Remainder Status';
  List<String> repeatList = [
    'Remainder Status',
    'Daily',
    'Weekly',
    'Monthly',
  ];
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null) {
      noteData = Get.arguments as NoteData;
    }

    if (noteData != null) {
      noteController.titleController.value.text = noteData.title;
      noteController.descriptionController.value.text = noteData.description;
      noteController.scheduleTime.value =
          DateTime.parse(noteData.remainderDateTime);
      _selectedRepeat = noteData.repeat;
      _selectedColor = noteData.color;

      if (noteData.imageBytes != null) {
        noteController.imageBytes.value = base64Decode(noteData.imageBytes);
        // Convert Base64 string to File
        convertUint8ListToFile(
                base64Decode(noteData.imageBytes), 'note_image.jpg')
            .then((file) {
          noteController.setImage(file);
        });
      }
    } else {
      noteController.titleController.value.text = "";
      noteController.descriptionController.value.text = "";
      noteController.scheduleTime.value = DateTime.now();
      _selectedRepeat = "Remainder Status";
      _selectedColor = 0;
      noteController.setImage(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: _appBar(),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Constants.dp_16,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColor.yellow.withOpacity(0.1),
                ),
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: Constants.dp_16),
                constraints: const BoxConstraints(
                  minHeight: 54, // Set your minimum height here
                ),
                child: TextField(
                  autofocus: false,
                  controller: noteController.titleController.value,
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
                    hintText: "task Title",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: Constants.dp_16,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColor.yellow.withOpacity(0.1),
                ),
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                constraints: const BoxConstraints(
                  minHeight: 120, // Set your minimum height here
                ),
                child: TextField(
                  autofocus: false,
                  controller: noteController.descriptionController.value,
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
                    hintText: "task description",
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(
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
                  color: AppColor.yellow.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          DateFormat('MM/dd/yyyy HH:mm a')
                              .format(noteController.scheduleTime.value),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await noteController.selectDatePickerDate(context);
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
              const SizedBox(
                height: Constants.dp_16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: InputField(
                  title: "Repeat",
                  hint: _selectedRepeat,
                  widget: Row(
                    children: [
                      DropdownButton<String>(
                          icon: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleTextStle,
                          underline: Container(height: 0),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedRepeat = newValue;
                              });
                            }
                          },
                          items: repeatList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      const SizedBox(width: 6),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: Constants.dp_16,
              ),
              InkWell(
                onTap: () {
                  noteController.pickImageFromGallery();
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColor.yellow.withOpacity(0.1),
                  ),
                  margin: const EdgeInsets.only(left: 16, right: 16),
                  constraints: const BoxConstraints(
                    minHeight: 180, // Set your minimum height here
                  ),
                  child: Obx(() {
                    if (noteController.image == null) {
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
                          noteController.image!,
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
              noteData == null
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _colorChips(),
                          InkWell(
                            onTap: (){
                              _addTaskToDB(context);
                            },
                            child: Container(
                              height: 50,
                              width: 130,
                              margin: const EdgeInsets.only(top: 8.0),
                              decoration: BoxDecoration(
                                color: primaryClr,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Text(
                                  "Create Task",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _colorChips(),
                          InkWell(
                            onTap: (){
                              if(noteData.isCompleted){
                                Utils.warningToastMessage("Task is already completed and cannot be updated!");
                                return;
                              }
                              _updateTaskToDB(context);
                            },
                            child: Container(
                              height: 50,
                              width: 130,
                              margin: const EdgeInsets.only(top: 8.0),
                              decoration: BoxDecoration(
                                color: noteData.isCompleted ? AppColor.gray.withOpacity(0.3) : primaryClr,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Text(
                                  "Update Task",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, size: 24, color: primaryClr),
        ),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(ImageAssets.logout_icon),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }

  _updateTaskToDB(BuildContext context) async {

    if (noteController.titleController.value.text.isEmpty) {
      Utils.warningToastMessage("Note Title can not be empty!");
      return;
    }

    if (noteController.descriptionController.value.text.isEmpty) {
      Utils.warningToastMessage("Note description can not be empty!");
      return;
    }

    if (_selectedRepeat == "Remainder Status") {
      Utils.warningToastMessage("Select Remainder Status first!");
      return;
    }

    if(noteController.image == null){
      Utils.warningToastMessage("Task image can not be empty!");
      return;
    }


    final Uint8List imageBytes = noteController.imageBytes.value!;
    final String encodedImage = base64Encode(imageBytes);

    final note = NoteData(
      title: noteController.titleController.value.text,
      description: noteController.descriptionController.value.text,
      remainderDateTime: noteController.scheduleTime.value.toString(),
      isCompleted: noteData.isCompleted,
      color: _selectedColor,
      repeat: _selectedRepeat,
      date: DateFormat.yMd().format(_selectedDate),
      isRemiander: noteData.isRemiander,
      imageBytes: encodedImage ?? "",
    );

    var isUpdated =
        await noteController.updateNoteOnDataBase(noteData.id, note);

    if (isUpdated) {
      Utils.successToastMessage("Success");
      Get.offNamed(RouteName.noteScreen, arguments: 'back');
    } else {
      Utils.errorToastMessage("Error");
    }
  }

  _addTaskToDB(BuildContext context) async {
    if (noteController.titleController.value.text.isEmpty) {
      Utils.warningToastMessage("Note Title can not be empty!");
      return;
    }

    if (noteController.descriptionController.value.text.isEmpty) {
      Utils.warningToastMessage("Note description can not be empty!");
      return;
    }

    if (_selectedRepeat == "Remainder Status") {
      Utils.warningToastMessage("Select Remainder Status first!");
      return;
    }

    if(noteController.image == null){
      Utils.warningToastMessage("Task image can not be empty!");
      return;
    }

    final Uint8List imageBytes = noteController.imageBytes.value!;
    final String encodedImage = base64Encode(imageBytes);

    final note = NoteData(
      title: noteController.titleController.value.text,
      description: noteController.descriptionController.value.text,
      remainderDateTime: noteController.scheduleTime.value.toString(),
      isCompleted: false,
      color: _selectedColor,
      repeat: _selectedRepeat,
      date: DateFormat.yMd().format(_selectedDate),
      isRemiander: false,
      imageBytes: encodedImage ?? "",
    );

    var isInserted = await noteController.addNoteOnIsarDataBase(note);

    if (isInserted) {
      Utils.successToastMessage("Success");
      Get.offNamed(RouteName.noteScreen, arguments: 'back');
    } else {
      Utils.errorToastMessage("Error");
    }
  }

  Future<File> convertUint8ListToFile(Uint8List data, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/$fileName').create();
    file.writeAsBytesSync(data);
    return file;
  }

  _colorChips() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Color",
        style: titleTextStle,
      ),
      SizedBox(
        height: 8,
      ),
      Wrap(
        children: List<Widget>.generate(
          3,
          (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: index == _selectedColor
                      ? Center(
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : Container(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ]);
  }
}
