import 'dart:typed_data'; // Make sure this import is correct
import 'package:isar/isar.dart';

part 'note_database.g.dart'; // Ensure this is correct and matches the file name

@Collection()
class NoteData {
  Id id = Isar.autoIncrement;

  String title;
  String description;
  bool isCompleted;
  String remainderDateTime;
  int color;
  String repeat;
  String date;
  bool isRemiander;
  String imageBytes;

  NoteData({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.remainderDateTime,
    required this.color,
    required this.repeat,
    required this.date,
    required this.isRemiander,
    required this.imageBytes,
  });
}