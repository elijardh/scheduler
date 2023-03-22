import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  String? name;
  String? level;
  String? department;

  StudentModel({this.department, this.level, this.name});

  factory StudentModel.fromJson(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    return StudentModel(
        department: documentSnapshot['dept'],
        level: documentSnapshot['level'],
        name: documentSnapshot['name']);
  }
}
