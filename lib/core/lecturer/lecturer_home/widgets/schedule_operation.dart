// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/navigation/navigator.dart';
import 'package:scheduler/app/presentations/button.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/margin.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/app/resource.dart';
import 'package:scheduler/core/lecturer/lecturer_home/model/lecture_model.dart';
import 'package:scheduler/core/lecturer/lecturer_home/view%20model/home_viewmodel.dart';

class ScheduleOperationWidget extends StatefulWidget {
  final LectureModel? lectureModel;
  const ScheduleOperationWidget({super.key, this.lectureModel});

  @override
  State<ScheduleOperationWidget> createState() =>
      _ScheduleOperationWidgetState();
}

class _ScheduleOperationWidgetState extends State<ScheduleOperationWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 230.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: XButton(
                  buttonName: "Cancel Lecture",
                  fontSize: 14.sp,
                  mHeight: 40.h,
                  mWidth: 200,
                  textColor: Colors.white,
                  action: () {
                    updateLecture("cancelled");
                  },
                  buttonColor: Colors.red),
            ),
            const YMargin(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: XButton(
                  buttonName: "Start Lecture",
                  fontSize: 14.sp,
                  mHeight: 40.h,
                  mWidth: 200,
                  textColor: Colors.white,
                  action: () {
                    updateLecture("ongoing");
                  },
                  buttonColor: Colors.green),
            ),
            const YMargin(15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: XButton(
                  buttonName: "Finish Lecture",
                  fontSize: 14.sp,
                  mHeight: 40.h,
                  mWidth: 200,
                  textColor: Colors.white,
                  action: () {
                    updateLecture("finished");
                  },
                  buttonColor: XColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }

  updateLecture(String status) async {
    HomeViewmodel viewmodel = context.read<HomeViewmodel>();
    context.loaderOverlay.show();
    await viewmodel.updateLecture(
        widget.lectureModel!, widget.lectureModel!.id!, status);

    if (viewmodel.updateLectureResource.ops == NetworkStatus.SUCCESSFUL) {
      context.loaderOverlay.hide();
      popView(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: XColors.mainColor,
          content: NormalText(
            text: "Lecture Updated",
            textColor: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: XColors.mainColor,
          content: NormalText(
            text: viewmodel.updateLectureResource.networkError ?? "",
            textColor: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
