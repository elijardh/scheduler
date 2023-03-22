import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduler/app/resource.dart';
import 'package:scheduler/core/authentication/model/lecturerModel.dart';
import 'package:scheduler/core/authentication/model/studentModel.dart';

class AuthenticationViewmodel extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore database = FirebaseFirestore.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  bool? signInStudent;
  Resource<UserCredential> _signInResource = Resource.idle();
  Resource<UserCredential> get signInResource => _signInResource;
  Future<void> signIn(String email, String password) async {
    try {
      _signInResource = Resource.loading();
      notifyListeners();

      final data = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final lecturecheck =
          await database.collection("lecturer").doc(data.user!.uid).get();

      if (lecturecheck.exists) {
        final userResponse = LecturerModel.fromJson(await database
            .collection("lecturer")
            .doc(auth.currentUser!.uid)
            .get());

        _lecturerProfileResource = Resource.success(userResponse);

        signInStudent = false;
      } else {
        final userResponse = StudentModel.fromJson(await database
            .collection("student")
            .doc(auth.currentUser!.uid)
            .get());

        _studentProfileResource = Resource.success(userResponse);

        signInStudent = true;
      }

      _signInResource = Resource.success(data);
      notifyListeners();
    } catch (e) {
      _signInResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<UserCredential> _createStudentesource = Resource.idle();
  Resource<UserCredential> get createStudentesource => _createStudentesource;

  Future<void> createStudent(
      String email, String password, Map<String, dynamic> data) async {
    try {
      _createStudentesource = Resource.loading();
      notifyListeners();

      final user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await database.collection("student").doc(user.user!.uid).set(data);

      await messaging.subscribeToTopic(data["dept"] + data["level"]);

      _createStudentesource = Resource.success(user);
      notifyListeners();
    } catch (e) {
      _createStudentesource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<UserCredential> _createLectureResource = Resource.idle();
  Resource<UserCredential> get createLectureResource => _createLectureResource;

  Future<void> createLecturer(
      String email, String password, String fullname) async {
    try {
      _createLectureResource = Resource.loading();
      notifyListeners();

      final user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await database
          .collection("lecturer")
          .doc(user.user!.uid)
          .set({"name": fullname});

      _createLectureResource = Resource.success(user);
      notifyListeners();
    } catch (e) {
      _createLectureResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<LecturerModel> _lecturerProfileResource = Resource.idle();
  Resource<LecturerModel> get lecturerProfileResource =>
      _lecturerProfileResource;

  Future<void> getLecturerProfile() async {
    try {
      _lecturerProfileResource = Resource.loading();
      notifyListeners();

      final userResponse = LecturerModel.fromJson(await database
          .collection("lecturer")
          .doc(auth.currentUser!.uid)
          .get());

      _lecturerProfileResource = Resource.success(userResponse);
      notifyListeners();
    } catch (e) {
      _lecturerProfileResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }

  Resource<StudentModel> _studentProfileResource = Resource.idle();
  Resource<StudentModel> get studentProfileResource => _studentProfileResource;

  Future<void> getStudentProfile() async {
    try {
      _studentProfileResource = Resource.loading();
      notifyListeners();

      final userResponse = StudentModel.fromJson(await database
          .collection("student")
          .doc(auth.currentUser!.uid)
          .get());

      _studentProfileResource = Resource.success(userResponse);
      notifyListeners();
    } catch (e) {
      _studentProfileResource = Resource.failed(e.toString());
      notifyListeners();
    }
  }
}
