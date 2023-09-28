// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/navigation/navigator.dart';
import 'package:scheduler/app/presentations/button.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/inputfield.dart';
import 'package:scheduler/app/presentations/margin.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/app/resource.dart';
import 'package:scheduler/core/authentication/view%20model/authentication_viewmodel.dart';
import 'package:scheduler/core/lecturer/lecturer_schedule/model/LectureTheaterModel.dart';
import 'package:scheduler/core/lecturer/lecturer_schedule/view%20model/lectureScheduleViewmodel.dart';
import 'package:uuid/uuid.dart';

class LectureScheduleScreen extends StatefulWidget {
  const LectureScheduleScreen({super.key});

  @override
  State<LectureScheduleScreen> createState() => _LectureScheduleScreenState();
}

class _LectureScheduleScreenState extends State<LectureScheduleScreen> {
  TextEditingController courseCodeController = TextEditingController();
  TextEditingController courseTitleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  List<LectureTheaterModel> lectureTheater = [
    LectureTheaterModel(
        value: "ETF", lat: "7.302264205626066", long: "5.135638663419322"),
    LectureTheaterModel(
        value: "2 in 1 A", lat: "7.298341881183599", long: "5.136550971499132"),
    LectureTheaterModel(
        value: "2 in 1 B", lat: "7.298010777468715", long: "5.136607357996458"),
    LectureTheaterModel(
        value: "Big LT", lat: "7.3024565598558615", long: "5.13500552288029"),
    LectureTheaterModel(
        value: "BOC", lat: "7.2975320817280585", long: "5.132591268537864"),
    LectureTheaterModel(
        value: "Small LT", lat: "7.302500853477807", long: "5.134675388724914"),
    LectureTheaterModel(
        value: "1000 LT", lat: "7.297820660011135", long: "5.132663372635468"),
    LectureTheaterModel(
        value: "FBN", lat: "7.297928831542158", long: "5.132976312978375"),
  ];
  LectureTheaterModel? lectureTheather;

  List<String> departments = ["CSC", "CYS", "IFT"];
  String chosenDeprt = "CSC";
  List<String> level = ["100", "200", "300", "400", "500"];
  String? currentLevel = "100";

  DateTime? lectureDate;
  TimeOfDay? timeOfLecture;

  @override
  void initState() {
    super.initState();

    lectureTheather = lectureTheater.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const SizedBox(),
        centerTitle: true,
        title: NormalText(
          text: "Schedule Screen",
          textColor: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const YMargin(10),
              NormalText(
                text: "Course Code",
                textColor: XColors.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              const YMargin(10),
              SizedBox(
                height: 40.h,
                child: XTextField(
                  controller: courseCodeController,
                  hintText: "CSC 505",
                  borderWidth: 1,
                  normalBorderColor: XColors.mainColor,
                  enabledBorderColor: XColors.mainColor,
                  focusedBorderColor: XColors.mainColor,
                ),
              ),
              const YMargin(10),
              NormalText(
                text: "Course Title",
                textColor: XColors.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              const YMargin(10),
              SizedBox(
                height: 40.h,
                child: XTextField(
                  controller: courseTitleController,
                  hintText: "Fault Tolerant",
                  borderWidth: 1,
                  normalBorderColor: XColors.mainColor,
                  enabledBorderColor: XColors.mainColor,
                  focusedBorderColor: XColors.mainColor,
                ),
              ),
              const YMargin(10),
              NormalText(
                text: "Department",
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              const YMargin(10),
              Container(
                height: 40.h,
                width: 350.w,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: XColors.mainColor, width: 1)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  isExpanded: true,
                  items: departments
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: NormalText(
                              text: "$e: ${departName(e)}",
                              textColor: XColors.textColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    chosenDeprt = val!;
                    setState(() {});
                  },
                  value: chosenDeprt,
                )),
              ),
              const YMargin(10),
              NormalText(
                text: "Level",
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              const YMargin(10),
              Container(
                height: 40.h,
                width: 350.w,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: XColors.mainColor, width: 1)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                  isExpanded: true,
                  items: level
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: NormalText(
                              text: "$e level",
                              textColor: XColors.textColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    currentLevel = val!;
                    setState(() {});
                  },
                  value: currentLevel,
                )),
              ),
              const YMargin(10),
              NormalText(
                text: "Pick Date",
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              const YMargin(10),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);

                    lectureDate = pickedDate;
                  }

                  setState(() {});
                },
                child: SizedBox(
                  height: 40.h,
                  child: XTextField(
                    controller: dateController,
                    hintText: "Pick Date",
                    borderWidth: 1,
                    isEnabled: false,
                    normalBorderColor: XColors.mainColor,
                    enabledBorderColor: XColors.mainColor,
                    focusedBorderColor: XColors.mainColor,
                  ),
                ),
              ),
              const YMargin(10),
              NormalText(
                text: "Pick Time",
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              const YMargin(10),
              InkWell(
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    timeController.text = pickedTime.format(context);

                    timeOfLecture = pickedTime;
                  }

                  setState(() {});
                },
                child: SizedBox(
                  height: 40.h,
                  child: XTextField(
                    controller: timeController,
                    hintText: "Pick Time",
                    borderWidth: 1,
                    isEnabled: false,
                    normalBorderColor: XColors.mainColor,
                    enabledBorderColor: XColors.mainColor,
                    focusedBorderColor: XColors.mainColor,
                  ),
                ),
              ),
              const YMargin(10),
              NormalText(
                text: "Pick a Lecture Theater",
                textColor: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              const YMargin(10),
              Container(
                height: 40.h,
                width: 350.w,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: XColors.mainColor, width: 1)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<LectureTheaterModel>(
                  isExpanded: true,
                  items: lectureTheater
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: NormalText(
                              text: e.value,
                              textColor: XColors.textColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ))
                      .toList(),
                  onChanged: (val) {
                    lectureTheather = val!;
                    setState(() {});
                  },
                  value: lectureTheather,
                )),
              ),
              const YMargin(10),
              const YMargin(30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: XButton(
                  buttonName: "Schedule Lecture",
                  fontSize: 14.sp,
                  mHeight: 40.h,
                  mWidth: 200,
                  action: () {
                    scheduleLecture();
                  },
                  buttonColor: XColors.mainColor,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String departName(String deptCode) {
    String departName = "";
    switch (deptCode) {
      case "CSC":
        departName = "Computer Science";

        break;
      case "IFT":
        departName = "Information Technology";
        break;
      case "CYS":
        departName = "Cyber Security";
        break;
      default:
        departName = "";
    }

    return departName;
  }

  scheduleLecture() async {
    LectureScheduleViewmodel viewmodel =
        context.read<LectureScheduleViewmodel>();

    AuthenticationViewmodel authenticationViewmodel =
        context.read<AuthenticationViewmodel>();
    context.loaderOverlay.show();

    String uid = const Uuid().v1();

    Map<String, dynamic> data = {
      "lectureTitle": courseTitleController.text,
      "lectureCode": courseCodeController.text,
      "date": lectureDate!.millisecondsSinceEpoch,
      "time": timeOfLecture!.format(context),
      "theater": lectureTheather?.value,
      "department": chosenDeprt,
      "level": currentLevel,
      "status": "scheduled",
      "lecturer": authenticationViewmodel
          .lecturerProfileResource.modelResponse!.fullName,
      "uuid": uid,
      "long": lectureTheather?.long,
      "lat": lectureTheather?.lat
    };

    await viewmodel.createSchedule(
        data, dateController.text, timeController.text);

    if (viewmodel.createScheduleResource.ops == NetworkStatus.SUCCESSFUL) {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: XColors.mainColor,
          content: NormalText(
            text: "Lecture Created ",
            textColor: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
      popView(context);
    } else {
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: XColors.mainColor,
          content: NormalText(
            text: viewmodel.createScheduleResource.networkError ?? "",
            textColor: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
