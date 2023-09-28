import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/margin.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/core/lecturer/lecturer_home/model/lecture_model.dart';

class LectureScheduleWidget extends StatefulWidget {
  final LectureModel? lectureModel;
  const LectureScheduleWidget({super.key, this.lectureModel});

  @override
  State<LectureScheduleWidget> createState() => _LectureScheduleWidgetState();
}

class _LectureScheduleWidgetState extends State<LectureScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: widget.lectureModel?.lectureTime ?? "",
                  textColor: XColors.textColor,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w500,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NormalText(
                      text: DateFormat.MMMMEEEEd()
                          .format(widget.lectureModel!.lectureDate!)
                          .split(",")
                          .first,
                      textColor: XColors.textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                    NormalText(
                        fontSize: 15.sp,
                        textColor: XColors.grayText,
                        text: widget.lectureModel?.lectureDate?.day ==
                                DateTime.now().day
                            ? "TODAY"
                            : DateFormat.MMMMd()
                                .format(widget.lectureModel!.lectureDate!)),
                  ],
                ),
                RichText(
                  text: TextSpan(
                      text: DateFormat.d()
                          .format(widget.lectureModel!.lectureDate!),
                      style: TextStyle(
                          color: XColors.textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                            style: TextStyle(
                                color: XColors.grayText,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400),
                            text:
                                "/${DateFormat.M().format(widget.lectureModel!.lectureDate!)}")
                      ]),
                ),
              ],
            ),
            const YMargin(10),
            NormalText(
              text: widget.lectureModel?.courseTitle?.toUpperCase() ?? "",
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              textColor: XColors.textColor,
            ),
            const YMargin(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: widget.lectureModel?.courseCode?.toUpperCase() ?? "",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  textColor: XColors.grayText,
                ),
                InkWell(
                  onTap: () async {
                    final map =
                        await MapLauncher.isMapAvailable(MapType.google);

                    if (map != null && map) {
                      await MapLauncher.showDirections(
                          mapType: MapType.google,
                          destination: Coords(7.2367, 5.2142));
                    }
                  },
                  child: Icon(
                    Icons.location_on,
                    color: XColors.textColor,
                  ),
                )
              ],
            ),
            const YMargin(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NormalText(
                  text: widget.lectureModel?.lecturer ?? "",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  textColor: XColors.textColor,
                ),
                NormalText(
                  text: widget.lectureModel!.status,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  textColor: getColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color getColor() {
    Color? color = Colors.black;
    switch (widget.lectureModel!.status) {
      case "scheduled":
        color = Colors.grey;
        break;
      case "ongoing":
        color = Colors.green;
        break;
      case "cancelled":
        color = Colors.red;
        break;
      case "finished":
        color = XColors.mainColor;
        break;
      default:
        color = Colors.grey;
    }
    return color;
  }
}
