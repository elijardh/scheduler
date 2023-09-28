import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/navigation/navigator.dart';
import 'package:scheduler/app/presentations/button.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/margin.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/core/lecturer/lecturer_home/model/lecture_model.dart';
import 'package:scheduler/core/lecturer/lecturer_home/view%20model/home_viewmodel.dart';
import 'package:scheduler/core/lecturer/lecturer_home/widgets/lecture%20schedule%20widget.dart';
import 'package:scheduler/core/lecturer/lecturer_home/widgets/schedule_operation.dart';
import 'package:scheduler/core/lecturer/lecturer_schedule/screen/lecture_schedule.dart';

class LecturerHomeScreen extends StatefulWidget {
  const LecturerHomeScreen({super.key});

  @override
  State<LecturerHomeScreen> createState() => _LecturerHomeScreenState();
}

class _LecturerHomeScreenState extends State<LecturerHomeScreen> {
  FirebaseFirestore database = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  DateTime now = DateTime.now();

  DateTime? date;

  @override
  void initState() {
    super.initState();

    date = DateTime(now.year, now.month, now.day);
    log(date!.millisecondsSinceEpoch.toString());
    HomeViewmodel viewmodel = context.read<HomeViewmodel>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      viewmodel.getList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = context.read<HomeViewmodel>();
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: XColors.mainColor,
      //   leading: const SizedBox(),
      //   centerTitle: true,
      //   title: NormalText(
      //     text: "Schedule Screen",
      //     textColor: Colors.white,
      //     fontSize: 14.sp,
      //     fontWeight: FontWeight.w600,
      //   ),
      // ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const YMargin(40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: "Scheduled Lectures",
                    textColor: XColors.textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  const Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const YMargin(10),
            Container(
              height: 480.h,
              width: 400.w,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: database
                      .collection("lectures")
                      .doc(auth.currentUser!.uid)
                      .collection("lecturesScheduled")
                      .orderBy('date')
                      .where('date',
                          isGreaterThanOrEqualTo: date!.millisecondsSinceEpoch)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return NormalText(text: snapshot.error.toString());
                    } else if (!snapshot.hasData) {
                      return SizedBox(
                        height: 100.h,
                        width: 100.h,
                        child: const NormalText(
                          text: "No Lecture Scheduled",
                          fontSize: 20,
                        ),
                      );
                    } else {
                 
                      final List<LectureModel> data = [];

                      for (var element in snapshot.data!.docs) {
                        data.add(LectureModel.fromJson(element));
                      }
                      log(data.length.toString());

                      data.sort(
                        (a, b) {
                          return a.lectureDate!.compareTo(b.lectureDate!);
                        },
                      );

                      if (data.isEmpty) {
                        return SizedBox(
                          height: 100.h,
                          width: 100.h,
                          child: const Center(
                            child: NormalText(
                              text: "No Lectures Scheduled",
                              fontSize: 20,
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: data
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ScheduleOperationWidget(
                                          lectureModel: e,
                                        ),
                                      );
                                    },
                                    child: LectureScheduleWidget(
                                      lectureModel: e,
                                    ),
                                  ))
                              .toList(),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            const YMargin(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NormalText(
                    text: "Schedule a new Lecture",
                    textColor: XColors.textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  const Icon(
                    Icons.more_horiz,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            const YMargin(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: XButton(
                  buttonName: "Schedule Lecture",
                  buttonRadius: 5,
                  fontSize: 12.sp,
                  mHeight: 40.h,
                  mWidth: 200,
                  textColor: Colors.white,
                  action: () {
                    navigate(context, const LectureScheduleScreen());
                  },
                  buttonColor: XColors.mainColor),
            )
          ],
        ),
      ),
    );
  }
}
