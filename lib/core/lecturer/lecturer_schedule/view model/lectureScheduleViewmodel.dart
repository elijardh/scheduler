// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduler/app/resource.dart';
import 'package:scheduler/core/lecturer/lecturer_schedule/service/notifications.dart';

class LectureScheduleViewmodel extends ChangeNotifier {
  NotificationSender service = NotificationSender();
  FirebaseFirestore database = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Resource<DocumentReference<Map<String, dynamic>>> _createScheduleResource =
      Resource.idle();
  Resource<DocumentReference<Map<String, dynamic>>>
      get createScheduleResource => _createScheduleResource;
  Future<void> createSchedule(
      Map<String, dynamic> data, String date, String time) async {
    try {
      _createScheduleResource = Resource.loading();
      notifyListeners();

      final response = await database
          .collection("lectures")
          .doc(auth.currentUser!.uid)
          .collection("lecturesScheduled")
          .add(data);

      Map<String, dynamic> notificationData = {
        'notification': <String, dynamic>{
          'body': (data["lectureCode"] +
              " has been scheduled for " +
              time +
              " at " +
              data['theater'] +
              " on " +
              date),
          'title': (data["lecturer"] +
              " scheduled a lecture for " +
              data["lectureTitle"])
        },
        'priority': 'high',
        "data": data,
        "to": ("/topics/" + data["department"] + data["level"]),
      };

      await service.sendNotifications(notificationData);

      _createScheduleResource = Resource.success(response);

      notifyListeners();
    } catch (e) {
      _createScheduleResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
