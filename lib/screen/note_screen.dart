import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/foundation.dart';
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
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _dateBar(),
            const SizedBox(
              height: 12,
            ),
            _showTasks(),
          ],
        ));
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (noteController.notes.isEmpty) {
          return _noTaskMsg();
        } else {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: noteController.notes.length,
              itemBuilder: (context, index) {
                NoteData task = noteController.notes[index];
                if (task.repeat == 'Daily') {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TaskTile(
                              task: task,
                              onRemainderSet: () async {

                                if(task.isRemiander){
                                  Utils.warningToastMessage("Reminder has already been set.");
                                  return;
                                }

                                bool isRemainderUpdate = await noteController
                                    .updateNoteRemainderOnDataBase(
                                        task.id, task);

                                if(isRemainderUpdate){
                                  if (isRemainderUpdate) {
                                    Utils.successToastMessage(
                                        "Successfully remainder set");
                                  } else {
                                    Utils.errorToastMessage("Error");
                                  }
                                }
                              },
                              onDetailsTap: () {
                                Get.toNamed(RouteName.addNoteScreen,
                                    arguments: task);
                              },
                              onSettingsTap: () {
                                showBottomSheet(context, task);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (task.remainderDateTime ==
                    DateFormat.yMd().format(_selectedDate)) {
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
                            TaskTile(
                              task: task,
                              onRemainderSet: () async {
                                bool isRemainderUpdate = await noteController
                                    .updateNoteRemainderOnDataBase(
                                        task.id, task);

                                if (isRemainderUpdate) {
                                  Utils.successToastMessage(
                                      "Successfully remainder set");
                                } else {
                                  Utils.errorToastMessage("Error");
                                }
                              },
                              onDetailsTap: () {
                                Get.toNamed(RouteName.addNoteScreen,
                                    arguments: task);
                              },
                              onSettingsTap: () {
                                showBottomSheet(context, task);
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
        }
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
        const SizedBox(
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
          textStyle: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 10.0,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              await Get.toNamed(RouteName.addNoteScreen)?.then((value) {
                if (value != null) {
                  noteController.fetchAllNotes();
                }
              });
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
          onTap: () async{
            ThemeService().switchTheme();

            //  _taskController.notifyHelper.scheduledNotification();
            // notifyHelper.periodicalyNotification();
          },
          child: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Get.isDarkMode ? Colors.white : darkGreyClr),
        ),
        actions: [
          InkWell(
            onTap: () async{
            var isLogOut = await  noteController.logoutUser();
            if(isLogOut){
              Get.offNamed(RouteName.loginView);
            }else{
              if (kDebugMode) {
                print("Logout Issue");
              }
            }

            },
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(ImageAssets.logout_icon),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ]);
  }

  showBottomSheet(BuildContext context, NoteData task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),  // Set topLeft radius to 12dp
            topRight: Radius.circular(16), // Set topRight radius to 12dp
          ),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        ),
        height: task.isCompleted
            ? SizeConfig.screenHeight! * 0.24
            : SizeConfig.screenHeight! * 0.32,
        width: SizeConfig.screenWidth,

        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          const Spacer(),
          task.isCompleted
              ? Container()
              : _buildBottomSheetButton(
              label: "Task Completed",
              onTap: () async{
                bool isCompleted = await noteController.updateNoteCompletedOnDataBase(task.id);
                if(isCompleted){
                  Utils.successToastMessage("Successfully Completed");
                  noteController.fetchAllNotes();
                  Get.back();
                }else {
                  Utils.errorToastMessage("Error");
                }
              },
              clr: primaryClr),
          _buildBottomSheetButton(
              label: "Delete Task",
              onTap: () async{
                bool isDeleted = await noteController.deleteNote(task.id);

                if(isDeleted){
                  Utils.successToastMessage("Successfully Deleted");
                  noteController.fetchAllNotes();
                  Get.back();
                }else {
                  Utils.errorToastMessage("Error");
                }

              },
              clr: Colors.red[300]!),
          const SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  _buildBottomSheetButton(
      {required String label,
        required Function onTap,
        Color? clr,
        bool? isClose}) {
    isClose ??= false;
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: SizeConfig.screenWidth! * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[300]!
                : clr ?? Colors.white,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
              label,
              style: isClose
                  ? titleTextStle
                  : titleTextStle.copyWith(color: Colors.white),
            )),
      ),
    );
  }



}
