import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/models/db_models/note_database.dart';

class SingleNote extends StatefulWidget {
  final NoteData noteData;
  final VoidCallback onTap;
  final VoidCallback onDelete; // Callback for delete action

  const SingleNote(
      {super.key,
      required this.noteData,
      required this.onTap,
      required this.onDelete});

  @override
  State<SingleNote> createState() => _SingleNoteState();
}

class _SingleNoteState extends State<SingleNote> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Stack(
        children: [
          // Card content
          Card(
            margin: const EdgeInsets.all(16),
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
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10)),
                          image: DecorationImage(
                            image: MemoryImage(
                                base64Decode(widget.noteData.imageBytes)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.noteData.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(widget.noteData.description),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Positioned delete icon
          Positioned(
            top: 28,
            right: 24,
            child: InkWell(
              onTap: widget.onDelete,
              child: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
