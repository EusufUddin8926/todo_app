import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/note_controller.dart';
import 'package:todo_app/models/db_models/note_database.dart';
import 'package:todo_app/resources/routes/routes_name.dart';
import '../helpers/theme_services.dart';
import '../resources/assets/asset_icon.dart';
import '../resources/components/button.dart';
import '../resources/components/task_tile.dart';
import '../services/notifi_service.dart';
import '../utils/Utils.dart';
import '../utils/size_config.dart';
import '../utils/theme.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as datatTimePicker;

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final noteController = Get.put(NoteController());
  DateTime _selectedDate = DateTime.parse(DateTime.now().toString());

  @override
  void initState() {
    super.initState();
    // Fetch notes or perform any initial setup
    noteController.fetchAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _dateBar(),
          SizedBox(
            height: 12,
          ),
          _showTasks(),
        ],
      )
    );
  }


  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (noteController.notes.isEmpty) {
          return _noTaskMsg();
        } else
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: noteController.notes.length,
              itemBuilder: (context, index) {
                NoteData task = noteController.notes[index];
                if(task.repeat == 'Daily'){
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*GestureDetector(
                                onTap: () {
                                 // showBottomSheet(context, task);
                                },
                                child: ),*/
                            TaskTile(task: task, onRemainderSet: () async{
                              bool  isRemainderUpdate = await noteController.updateNoteRemainderOnDataBase(task.id, task);
                            },
                              onDetailsTap: (){
                                Get.toNamed(RouteName.addNoteScreen, arguments: task);
                              },

                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (task.remainderDateTime == DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*GestureDetector(
                                onTap: () {
                                //  showBottomSheet(context, task);
                                },
                                child: TaskTile(task)),*/
                            TaskTile(task: task, onRemainderSet: () async{
                              bool  isRemainderUpdate = await noteController.updateNoteRemainderOnDataBase(task.id, task);

                              if (isRemainderUpdate) {
                                Utils.successToastMessage("Successfully remainder set");
                              } else {
                                Utils.errorToastMessage("Error");
                              }
                            },
                            onDetailsTap: (){
                              Get.toNamed(RouteName.addNoteScreen, arguments: task);
                            },

                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              });
      }),
    );
  }

  _noTaskMsg() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          ImageAssets.task_icon,
          color: primaryClr.withOpacity(0.5),
          height: 90,
          semanticsLabel: 'Task',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Text(
            "You do not have any tasks yet!\nAdd new tasks to make your days productive.",
            textAlign: TextAlign.center,
            style: subTitleTextStle,
          ),
        ),
        SizedBox(
          height: 80,
        ),
      ],
    );
  }


  _dateBar() {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      child: DatePicker(
        DateTime.now(),
        //height: 100.0,
        initialSelectedDate: DateTime.now(),
        selectionColor: context.theme.scaffoldBackgroundColor,
        selectedTextColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
        // deactivatedColor: Colors.white,

        onDateChange: (date) {
          // New date selected

          setState(
                () {
              _selectedDate = date;
            },
          );
        },
      ),
    );
  }


  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12, top: 12.0),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingTextStyle,
              ),
              Text(
                "Today",
                style: headingTextStyle,
              ),
            ],
          ),
          MyButton(
            label: "+ Add Task",
            onTap: () async {
              await Get.toNamed(RouteName.addNoteScreen);
              noteController.fetchAllNotes();
            },
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: context.theme.scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            ThemeService().switchTheme();
            /*_taskController.notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? "Light theme activated."
                  : "Dark theme activated",
            );*/

            //  _taskController.notifyHelper.scheduledNotification();
            // notifyHelper.periodicalyNotification();
          },
          child: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
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


}
