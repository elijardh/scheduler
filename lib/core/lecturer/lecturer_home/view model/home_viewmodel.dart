import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduler/app/resource.dart';
import 'package:scheduler/core/lecturer/lecturer_home/model/lecture_model.dart';
import 'package:scheduler/core/lecturer/lecturer_schedule/service/notifications.dart';

class HomeViewmodel extends ChangeNotifier {
  NotificationSender service = NotificationSender();
  FirebaseFirestore database = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Resource<dynamic> _updateLectureResource = Resource.idle();
  Resource<dynamic> get updateLectureResource => _updateLectureResource;

  Future<void> updateLecture(
      LectureModel model, String id, String status) async {
    try {
      _updateLectureResource = Resource.loading();
      notifyListeners();

      Map<String, dynamic> data = model.toJson();

      data.addAll({"status": status});

      await database
          .collection("lectures")
          .doc(auth.currentUser!.uid)
          .collection("lecturesScheduled")
          .doc(id)
          .update(data);

      Map<String, dynamic> notificationData = {
        'notification': <String, dynamic>{
          'body': getBody(status),
          'title': "There is an update for lecture ${data["lectureTitle"]}"
        },
        'priority': 'high',
        "data": data,
        "to": "/topics/${data["department"] + data["level"]}",
      };

      final response = await service.sendNotifications(notificationData);

      _updateLectureResource = Resource.success(response);
      notifyListeners();
    } catch (e) {
      _updateLectureResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<List<LectureModel>> _getScheduledResource = Resource.idle();
  Resource<List<LectureModel>> get getScheduledResource =>
      _getScheduledResource;

  Stream<List<LectureModel>> getList() async* {
    log("helo");
    StreamController<List<LectureModel>> streamController =
        StreamController.broadcast();

    final response = database
        .collection("lectures")
        .doc(auth.currentUser!.uid)
        .collection("lectureScheduled")
        .snapshots();

    log("he");

    List<LectureModel> lecturemodel = [];

    response.forEach((element) {
      for (var element in element.docs) {
        lecturemodel.add(LectureModel.fromJson(element));
      }
    });

    log(lecturemodel.length.toString());
    streamController.sink.add(lecturemodel);

    yield* streamController.stream;
  }

  Future<void> getScheduledLectures() async {
    try {
      List<LectureModel> lecturemodel = [];
      _getScheduledResource = Resource.loading();
      notifyListeners();
      // final response = database
      //     .collection("lectures")
      //     .doc(auth.currentUser!.uid)
      //     .collection("lecturesScheduled")
      //     .orderBy("day", descending: true)
      //     .withConverter<LectureModel>(
      //       fromFirestore: (snapshot, options) =>
      //           LectureModel.fromJson(snapshot),
      //       toFirestore: (value, options) => value.toJson(),
      //     );

      final response = database
          .collection("lectures")
          .doc(auth.currentUser!.uid)
          .collection("lecturesScheduled")
          .orderBy("day", descending: true)
          .snapshots();

      log(response.length.toString());

      response.forEach((element) {
        for (var element in element.docs) {
          lecturemodel.add(LectureModel.fromJson(element));
        }
      });

      log(lecturemodel.length.toString());

      _getScheduledResource = Resource.success(lecturemodel);
      notifyListeners();
    } catch (e) {
      _getScheduledResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  String getBody(String status) {
    String body = "";
    switch (status) {
      case "cancelled":
        body = "This lecture has been cancelled";
        break;
      case "ongoing":
        body = "This lecture has started";
        break;
      case "finished":
        body = "This lecture is over";
        break;
      default:
        body = "";
    }

    return body;
  }
}
