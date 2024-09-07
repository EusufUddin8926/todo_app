import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:todo_app/models/db_models/note_database.dart';
import 'package:todo_app/resources/routes/routes_name.dart';

import '../resources/colors/app_color.dart';

class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {

  var noteData = Get.arguments as NoteData;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColor.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              GestureDetector(
                onTap: (){
                  Get.toNamed(RouteName.addNoteScreen, arguments: noteData);
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.redAccent,
                  ),
                ),
              ),

              Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(noteData.title),
              ),
              SizedBox(height: 32),
              Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                height: 180, // Adjust height as needed
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(noteData.imageBytes)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 32),
              Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(noteData.description),
              ),
        
            ],
          ),
        ),
      )
    );
  }
}
