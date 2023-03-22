import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scheduler/app/database/sql_helper.dart';
import 'package:scheduler/app/database/student_lecture_model.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/core/student/student_dashboard/widgets/student_lecture_widget.dart';

class LectureHistoryScreen extends StatefulWidget {
  const LectureHistoryScreen({super.key});

  @override
  State<LectureHistoryScreen> createState() => _LectureHistoryScreenState();
}

class _LectureHistoryScreenState extends State<LectureHistoryScreen> {
  List<StudentLectureModel> studentLectureModel = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getLectures();
    });
  }

  getLectures() async {
    final data = await SQLHelper.getItems();

    for (var element in data) {
      studentLectureModel.add(StudentLectureModel.fromDatabase(element));
    }

    studentLectureModel.sort(
      (a, b) {
        return a.lectureDate!.compareTo(b.lectureDate!);
      },
    );

    // studentLectureModel.reversed;
    log(data.length.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const SizedBox(),
        centerTitle: true,
        title: NormalText(
          text: "Lecture Screen",
          textColor: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: studentLectureModel
              .map((e) => StudentLectureWidget(
                    lectureModel: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
