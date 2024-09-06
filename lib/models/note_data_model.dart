import 'dart:convert';

NoteDataModel noteData(String note) => NoteDataModel.fromJson(json.decode(note));

String noteDataToJson(NoteDataModel data) => json.encode(data.toJson());

class NoteDataModel{
  String title;
  String description;
  String remainderDate;
  String remainderTime;
  String imageUri;

  NoteDataModel({
    required this.title,
    required this.description,
    required this.remainderDate,
    required this.remainderTime,
    required this.imageUri,
  });

  // Convert a NoteData object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'remainderDate': remainderDate,
      'remainderTime': remainderTime,
      'imageUri': imageUri,
    };
  }

  // Convert a Map (from JSON decoding) to a NoteData object
  factory NoteDataModel.fromJson(Map<String, dynamic> json) {
    return NoteDataModel(
      title: json['title'],
      description: json['description'],
      remainderDate: json['remainderDate'],
      remainderTime: json['remainderTime'],
      imageUri: json['imageUri'],
    );
  }
}
