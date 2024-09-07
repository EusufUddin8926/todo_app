import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/models/db_models/note_database.dart';
import '../../utils/size_config.dart';
import '../../utils/theme.dart';

class TaskTile extends StatefulWidget {
  final NoteData task;
  final VoidCallback onRemainderSet;
  final VoidCallback onDetailsTap;


  TaskTile({required this.task,required this.onRemainderSet, required this.onDetailsTap});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  Color _iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {


    return InkWell(
      onTap: (){
        widget.onDetailsTap();
      },
      child: Container(
        padding:
        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        width: SizeConfig.screenWidth,
        margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: _getBGClr(widget.task.color),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task.title,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
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
                                "${widget.task.remainderDateTime}",
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
                        widget.task.isCompleted == 1 ? "COMPLETED" : "TODO",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Positioned Notification Icon at the top right
              Positioned(
                right: -4,
                top: -4,
                child: InkWell(
                  onTap: (){
                    setState(() {
                      _iconColor = Colors.green; // Change icon color to green on click
                    });
                    widget.onRemainderSet();
                  },
                  child: Icon(
                    Icons.notifications,
                    color:  _iconColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
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

  DateTime? _parseDateTime(String? dateString) {
    try {
      if (dateString != null && dateString.isNotEmpty) {
        return DateTime.parse(dateString);
      }
    } catch (e) {
      // Handle parsing error
      print('Error parsing date: $e');
    }
    return null;
  }
}
