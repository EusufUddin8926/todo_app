import 'dart:typed_data'; // Make sure this import is correct
import 'package:isar/isar.dart';

part 'note_database.g.dart'; // Ensure this is correct and matches the file name

@Collection()
class NoteData {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late String remainderDate;
  late String remainderTime;
  late String imageBytes;

  NoteData({
    required this.title,
    required this.description,
    required this.remainderDate,
    required this.remainderTime,
    required this.imageBytes,
  });
}