// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scheduler/app/database/sql_helper.dart';
import 'package:scheduler/app/database/student_lecture_model.dart';
import 'package:scheduler/app/navigation/navigator.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/core/onboarding/screens/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigateToOnboarding() async {
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      final data = await SQLHelper.getItems();

      DateTime now = DateTime.now();
      List<StudentLectureModel> studentLectureModel = [];

      for (var element in data) {
        studentLectureModel.add(StudentLectureModel.fromDatabase(element));
      }

      for (var element in studentLectureModel) {
        if (element.lectureDate!
            .isBefore(DateTime(now.year, now.month, now.day))) {
          await SQLHelper.deleteItem(element.uuid!);
        }
      }

      navigate(context, const OnboardingScreen());
    });
  }

  @override
  void initState() {
    super.initState();

    navigateToOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(color: XColors.mainColor),
        child: Center(
          child: NormalText(
            text: "FUTA \n Scheduler",
            textColor: Colors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.w900,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
