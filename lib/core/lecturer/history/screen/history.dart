import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/core/lecturer/lecturer_home/model/lecture_model.dart';
import 'package:scheduler/core/lecturer/lecturer_home/widgets/lecture%20schedule%20widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  FirebaseFirestore database = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();

  DateTime? date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const SizedBox(),
        centerTitle: true,
        title: NormalText(
          text: "History",
          textColor: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: database
              .collection("lectures")
              .doc(auth.currentUser!.uid)
              .collection("lecturesScheduled")
              .orderBy('date', descending: true)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              List<LectureModel> model = [];

              for (var element in snapshot.data!.docs) {
                model.add(LectureModel.fromJson(element));
              }

              if (model.isEmpty) {
                return const Center(
                  child: Text("No History"),
                );
              } else {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Column(
                    children: model
                        .map((e) => LectureScheduleWidget(
                              lectureModel: e,
                            ))
                        .toList(),
                  ),
                );
              }
            }
            return Container();
          },
        ),
        // child: SingleChildScrollView(
        //   child: Column(
        //     children: List.generate(
        //         10,
        //         (index) => const NormalText(
        //               text: "hhh",
        //             )),
        //   ),
        // ),
      ),
    );
  }
}
