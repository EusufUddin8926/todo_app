import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_app/controller/add_note_controller.dart';
import 'package:todo_app/helpers/constant.dart';
import 'package:todo_app/resources/assets/asset_icon.dart';
import '../models/db_models/note_database.dart';
import '../resources/colors/app_color.dart';
import '../resources/components/button.dart';
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
  final addNoteController = Get.put(AddNoteController());
  var noteData;
  int _selectedColor = 0;
  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
    'Weekly',
    'Monthly',
  ];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null) {
      noteData = Get.arguments as NoteData;
    }

    if (noteData != null) {
      addNoteController.titleController.value.text = noteData.title;
      addNoteController.descriptionController.value.text = noteData.description;
      addNoteController.scheduleTime.value = DateTime.parse(noteData.remainderDateTime);
      _selectedRepeat = noteData.repeat;
      _selectedColor = noteData.color;

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
      appBar: _appBar(),
      body: Container(
        color: AppColor.white,
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
                  color: AppColor.gray.withOpacity(0.3),
                ),
                margin: const EdgeInsets.only(left: 16, right: 16, top: Constants.dp_16),
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
                  minHeight: 120, // Set your minimum height here
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
                          addNoteController.scheduleTime.value.toString(),
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
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: InputField(
                  title: "Repeat",
                  hint: _selectedRepeat,
                  widget: Row(
                    children: [
                      DropdownButton<String>(
                        //value: _selectedRemind.toString(),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          iconSize: 32,
                          elevation: 4,
                          style: subTitleTextStle,
                          underline: Container(height: 0),
                          onChanged: (String? newValue) {
                            if (newValue != null)
                              setState(() {
                                _selectedRepeat = newValue;
                              });
                          },
                          items: repeatList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      SizedBox(width: 6),
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

              noteData == null  ?
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorChips(),
                    MyButton(
                      label: "Create Task",
                      onTap: () {
                        _addTaskToDB(context);
                      },
                    ),
                  ],
                ),
              ) : Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _colorChips(),
                    MyButton(
                      label: "Update Task",
                      onTap: () {
                        _updateTaskToDB(context);
                      },
                    ),
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
            backgroundImage: AssetImage(ImageAssets.girl_icon),
          ),
          SizedBox(
            width: 20,
          ),
        ]);
  }


  _updateTaskToDB(BuildContext context) async {
    final Uint8List imageBytes =
    addNoteController.imageBytes.value!;
    final String encodedImage = base64Encode(imageBytes);

    final note = NoteData(
      title: addNoteController.titleController.value.text,
      description: addNoteController
          .descriptionController.value.text,
      remainderDateTime: addNoteController.scheduleTime.value.toString(),
      isCompleted: noteData.isCompleted,
      color: _selectedColor,
      repeat: _selectedRepeat,
      date: DateFormat.yMd().format(_selectedDate),
      isRemiander: noteData.isRemiander,
      imageBytes: encodedImage ?? "",
    );

    var isUpdated =
    await addNoteController.updateNoteOnDataBase(noteData.id ,note);

    if (isUpdated) {
      Utils.successToastMessage("Success");
      Get.offNamed(RouteName.noteScreen, arguments: 'back');
    } else {
      Utils.errorToastMessage("Error");
    }


  }

  _addTaskToDB(BuildContext context) async {
    final Uint8List imageBytes =
    addNoteController.imageBytes.value!;
    final String encodedImage = base64Encode(imageBytes);

    final note = NoteData(
      title: addNoteController.titleController.value.text,
      description: addNoteController
          .descriptionController.value.text,
      remainderDateTime: addNoteController.scheduleTime.value.toString(),
      isCompleted: false,
      color: _selectedColor,
      repeat: _selectedRepeat,
      date: DateFormat.yMd().format(_selectedDate),
      isRemiander: false,
      imageBytes: encodedImage ?? "",
    );

    var isInserted =
    await addNoteController.addNoteOnIsarDataBase(note);

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




