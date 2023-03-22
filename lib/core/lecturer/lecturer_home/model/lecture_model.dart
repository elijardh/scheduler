import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LectureModel {
  String? id;
  String? courseTitle;
  String? courseCode;
  DateTime? lectureDate;
  String? lectureTime;
  String? lectureTheater;
  String? department;
  String? level;
  String? status;
  String? lecturer;
  String? uuid;
  String? long;
  String? lat;
  LectureModel(
      {this.courseCode,
      this.courseTitle,
      this.department,
      this.lectureDate,
      this.lectureTheater,
      this.lectureTime,
      this.lecturer,
      this.level,
      this.status,
      this.lat,
      this.long,
      this.uuid,
      this.id});

  factory LectureModel.fromJson(
      QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return LectureModel(
        id: json.id,
        courseCode: json['lectureCode'],
        courseTitle: json['lectureTitle'],
        department: json['department'],
        lectureDate: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
        lectureTheater: json['theater'],
        lectureTime: json['time'],
        lecturer: json['lecturer'],
        level: json['level'],
        status: json['status'],
        lat: json['lat'],
        long: json['long'],
        uuid: json['uuid']);
  }

  toJson() {
    Map<String, dynamic> data = {
      "lectureCode": courseCode,
      "lectureTitle": courseTitle,
      "department": department,
      "date": lectureDate!.millisecondsSinceEpoch,
      "theater": lectureTheater,
      "time": lectureTime,
      "lecturer": lecturer,
      "level": level,
      "status": status,
      "lat": lat,
      "long": long,
      "uuid": uuid
    };

    return data;
  }
}
