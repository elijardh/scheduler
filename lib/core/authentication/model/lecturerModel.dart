import 'package:cloud_firestore/cloud_firestore.dart';

class LecturerModel {
  String? fullName;
  // List<String>? lectures;

  LecturerModel({
    this.fullName,
  });

  factory LecturerModel.fromJson(DocumentSnapshot<Map<String, dynamic>> data) {
    return LecturerModel(
      fullName: data["name"],
    );
  }
}
