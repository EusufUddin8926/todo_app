import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/db_models/note_database.dart';

import '../../utils/size_config.dart';
import '../../utils/theme.dart';

class TaskTile extends StatefulWidget {
  final NoteData task;
  final VoidCallback onRemainderSet;
  final VoidCallback onDetailsTap;
  final VoidCallback onSettingsTap;

  TaskTile(
      {required this.task,
      required this.onRemainderSet,
      required this.onDetailsTap,
      required this.onSettingsTap});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  Color _iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _getBGClr(widget.task.color),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 24),
              child: InkWell(
                onTap: () {
                  widget.onDetailsTap();
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.alarm,
                                color: Colors.grey[200],
                                size: 15,
                              ),
                              SizedBox(width: 4),
                              Text(
                                DateFormat('MM/dd/yyyy hh:mm a').format(
                                    DateTime.parse(
                                        widget.task.remainderDateTime)),
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      fontSize: 13, color: Colors.grey[100]),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            widget.task.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.grey[100]),

                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      height: 60,
                      width: 0.5,
                      color: Colors.grey[200]!.withOpacity(0.7),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        widget.task.isCompleted ? "COMPLETED" : "TODO",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              right: 8,
              top: 8,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _iconColor =
                            Colors.green; // Change icon color to green on click
                      });
                      widget.onRemainderSet();
                    },
                    child: Icon(
                      Icons.add_alarm_sharp,
                      color: _iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _iconColor =
                            Colors.green; // Change icon color to green on click
                      });
                      widget.onSettingsTap();
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return purpleClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return purpleClr;
    }
  }
}
