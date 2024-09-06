import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/db_models/note_database.dart';

class SingleNote extends StatefulWidget {
  final NoteData noteData;
  final VoidCallback onTap;
  
  const SingleNote({super.key, required this.noteData, required this.onTap});

  @override
  State<SingleNote> createState() => _SingleNoteState();
}

class _SingleNoteState extends State<SingleNote> {
  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.noteData.imageBytes.isNotEmpty
              ? Container(
            width: double.infinity,
            height: 180, // Adjust height as needed
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              image: DecorationImage(
                image: MemoryImage(base64Decode(widget.noteData.imageBytes)),
                fit: BoxFit.cover,
              ),
            ),
          )
              : SizedBox.shrink(),
          Text(widget.noteData.title),
          Text(widget.noteData.description),
          SizedBox(height: 16,),
        ],
      ),
    );
  }
}
