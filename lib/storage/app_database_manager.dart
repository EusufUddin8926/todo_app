


import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:todo_app/models/db_models/note_database.dart';

import '../models/note_data_model.dart';

class AppDatabaseManager{

  Future<bool> insertNoteData(NoteDataModel note) async {
    try {
      final isar = Isar.getInstance();

      if(isar!=null){
        await isar.writeTxnSync(() async {
          isar.noteDatas.putSync(NoteData(
            title: note.title,
            description: note.description,
            remainderDate: note.remainderDate,
            remainderTime: note.remainderTime,
            imageBytes: note.imageUri
          ));
        });
        return true; // Indicates successful update
      }else{
        if (kDebugMode) {
          print('Isar instance is null.');
        }
        return false; // Indicates fail update
      }


    } catch (e) {
      if (kDebugMode) {
        print('Error inserting campaign data: $e');
      }
      return false; // Indicates fail update
    }
  }

  Future<List<NoteData>> getAllNotes() async {
    try {
      final isar = Isar.getInstance();

      if (isar != null) {
        final notes = await isar.noteDatas.where().findAll();
        return notes;
      } else {
        if (kDebugMode) {
          print('Isar instance is null.');
        }
        return []; // Return an empty list if Isar instance is null
      }

    } catch (e) {
      if (kDebugMode) {
        print('Error retrieving notes: $e');
      }
      return []; // Return an empty list on error
    }
  }

  Future<bool> deleteNoteById(Id noteId) async {
    try {
      final isar = Isar.getInstance();
      if (isar != null) {
        return await isar.writeTxn(() async {
          final result = await isar.noteDatas.delete(noteId);
          return result; // Return the result of the delete operation (true/false)
        });
      } else {
        if (kDebugMode) {
          print('Isar instance is null.');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting note: $e');
      }
      return false;
    }
  }

  // Update Note by Id
  Future<bool> updateNoteById(Id noteId, NoteDataModel updatedNote) async {
    try {
      final isar = Isar.getInstance();

      if (isar != null) {
        return await isar.writeTxn(() async {
          // Retrieve the existing note by Id
          final note = await isar.noteDatas.get(noteId);

          if (note != null) {
            // Update the fields
            note.title = updatedNote.title;
            note.description = updatedNote.description;
            note.remainderDate = updatedNote.remainderDate;
            note.remainderTime = updatedNote.remainderTime;
            note.imageBytes = updatedNote.imageUri;

            // Save the updated note back to the database
            await isar.noteDatas.put(note);
            return true; // Return true if the update was successful
          } else {
            if (kDebugMode) {
              print('Note with Id $noteId not found.');
            }
            return false; // Return false if the note was not found
          }
        });
      } else {
        if (kDebugMode) {
          print('Isar instance is null.');
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating note: $e');
      }
      return false;
    }
  }


}