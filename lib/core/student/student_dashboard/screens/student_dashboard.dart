import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:scheduler/app/database/sql_helper.dart';
import 'package:scheduler/app/database/student_lecture_model.dart';
import 'package:scheduler/app/navigation/navigator.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/margin.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/core/student/student_dashboard/screens/lecture_history.dart';
import 'package:scheduler/core/student/student_dashboard/screens/map_screens.dart';
import 'package:scheduler/core/student/student_dashboard/widgets/student_lecture_widget.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  List<StudentLectureModel> studentLectureModel = [];
  List<StudentLectureModel> filterStudentLectureModel = [];
  String filter = "TODAY";
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getLectures();
    });
  }

  getLectures() async {
    studentLectureModel.clear();
    final data = await SQLHelper.getItems();

    for (var element in data) {
      studentLectureModel.add(StudentLectureModel.fromDatabase(element));
    }

    studentLectureModel.sort(
      (a, b) {
        return a.lectureDate!.compareTo(b.lectureDate!);
      },
    );

    filterStudentLectureModel.addAll(studentLectureModel);

    filterLectures(filter);
    setState(() {});
  }

  filterLectures(String filter) async {
    final now = DateTime.now();
    filterStudentLectureModel.clear();

    filterStudentLectureModel.addAll(studentLectureModel);

    if (filter != "ALL") {
      filterStudentLectureModel.removeWhere((element) =>
          element.status == "finished" || element.status == "cancelled");
    }

    if (filter == "TODAY") {
      filterStudentLectureModel.removeWhere((element) =>
          element.lectureDate! != DateTime(now.year, now.month, now.day));
    } else if (filter == "LATER") {
      filterStudentLectureModel.removeWhere(
          (element) => !element.lectureDate!.isAfter(DateTime.now()));
    }
    setState(() {});

    log(filterStudentLectureModel.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              const YMargin(40),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      filter = "TODAY";

                      filterLectures(filter);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: filter == "TODAY"
                            ? XColors.mainColor
                            : XColors.grayText,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: NormalText(
                          text: "TODAY",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const XMargin(10),
                  InkWell(
                    onTap: () {
                      filter = "LATER";
                      filterLectures(filter);
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: filter == "LATER"
                            ? XColors.mainColor
                            : XColors.grayText,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: NormalText(
                          text: "LATER",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300,
                          textColor:
                              filter == "LATER" ? Colors.white : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const XMargin(10),
                  InkWell(
                    onTap: () {
                      filter = "ALL";
                      filterLectures(filter);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: filter == "ALL"
                            ? XColors.mainColor
                            : XColors.grayText,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: NormalText(
                          text: "ALL",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const YMargin(10),
              RefreshIndicator(
                color: XColors.mainColor,
                onRefresh: () async {
                  filter = "TODAY";
                  getLectures();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: filterStudentLectureModel.isNotEmpty
                        ? filterStudentLectureModel
                            .map((e) => GestureDetector(
                                  onTap: () async {
                                    final map =
                                        await MapLauncher.isMapAvailable(
                                            MapType.google);

                                    if (map != null && map) {
                                      await MapLauncher.showDirections(
                                          mapType: MapType.google,
                                          destination: Coords(
                                              double.parse(e.lat!),
                                              double.parse(e.long!)));
                                    }
                                  },
                                  child: StudentLectureWidget(
                                    lectureModel: e,
                                  ),
                                ))
                            .toList()
                        : [
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                height: 150.h,
                                width: 400.w,
                                decoration: BoxDecoration(
                                  color: XColors.grayText.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                    child: NormalText(
                                  text: "No Lecture Yet",
                                  textColor: XColors.textColor,
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                              ),
                            )
                          ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
