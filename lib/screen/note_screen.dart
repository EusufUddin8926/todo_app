import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/note_controller.dart';
import 'package:todo_app/resources/components/single_note.dart';
import 'package:todo_app/resources/routes/routes_name.dart';

import '../helpers/constant.dart';
import '../resources/assets/asset_icon.dart';
import '../resources/colors/app_color.dart';
import '../resources/font/app_fonts.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final noteController = Get.put(NoteController());

  @override
  void initState() {
    super.initState();
    // Fetch notes or perform any initial setup
    noteController.fetchAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Get.toNamed(RouteName.addNoteScreen);
      }),
      body: Obx(() {
        // Observe the changes in notes list
        final notes = noteController.notes;

        if (notes.isEmpty) {
          // Return the empty notes screen widget
          return _emptyNotesScreen(context);
        } else {
          // Return the list view widget with notes
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return SingleNote(
                noteData: note,
                onTap: () {
                  Get.toNamed(RouteName.noteDetails, arguments: note);
                },
                onDelete: () async {
                  print('Attempting to delete note with ID: ${note.id}');
                  final isDeleted = await noteController.deleteNote(note.id);
                  if (isDeleted) {
                    print("Success");
                  } else {
                    print("Delete with Problem");
                  }
                },
              );
            },
          );
        }
      }),
    );
  }

  Widget _emptyNotesScreen(BuildContext context) {
    return Container(
      color: AppColor.white,
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            ImageAssets.note_icon,
            width: Constants.dp_160,
            height: Constants.dp_160,
          ),
          const SizedBox(height: Constants.dp_30),
          const Text(
            "Add your first note",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.black,
              fontSize: Constants.dp_20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Relax and write something \nbeautiful",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.gray.withOpacity(0.5), // 50% opacity
              fontSize: Constants.dp_16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: Constants.dp_60),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(RouteName.addNoteScreen)?.then(
                (value) => {
                  if (value == "back") {noteController.fetchAllNotes()}
                },
              );
            },
            style: ElevatedButton.styleFrom(
              elevation: 4,
              shadowColor: AppColor.yellow.withOpacity(1),
              backgroundColor: AppColor.yellow,
              disabledBackgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.dp_8),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(Constants.dp_8),
              child: Text(
                "Add Note",
                style: TextStyle(
                  fontFamily: AppFonts.schylerRegular,
                  color: Colors.white,
                  fontSize: Constants.dp_16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
