// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/navigation/navigator.dart';
import 'package:scheduler/app/presentations/button.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/extensions.dart';
import 'package:scheduler/app/presentations/margin.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/app/resource.dart';
import 'package:scheduler/core/authentication/screen/sign%20in.dart';
import 'package:scheduler/core/authentication/view%20model/authentication_viewmodel.dart';
import 'package:scheduler/core/lecturer/dashboard/screens/dashboard_screen.dart';
import 'package:scheduler/core/student/student_dashboard/screens/student_dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<String> departments = ["CSC", "CYS", "IFT"];
  String chosenDeprt = "CSC";
  List<String> level = ["100", "200", "300", "400", "500"];
  String? currentLevel = "100";
  bool obscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameContoller = TextEditingController();
  final key = GlobalKey<FormState>();
  bool isStudent = true;
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XColors.mainColor,
      body: Center(
        child: IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 35),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: key,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NormalText(
                      text: "Register",
                      textColor: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    const YMargin(20),
                    Align(
                      alignment: Alignment.center,
                      child: NormalText(
                        text: "Select Role",
                        textColor: XColors.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const YMargin(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            isStudent = true;
                            setState(() {});
                          },
                          child: Container(
                            height: 30.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                              color:
                                  isStudent ? XColors.mainColor : Colors.green,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: NormalText(
                                text: "Student",
                                textColor: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            isStudent = false;
                            setState(() {});
                          },
                          child: Container(
                            height: 30.h,
                            width: 70.w,
                            decoration: BoxDecoration(
                                color: !isStudent
                                    ? XColors.mainColor
                                    : Colors.green,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Center(
                              child: NormalText(
                                text: "Lecturer",
                                textColor: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const YMargin(20),
                    const NormalText(
                      text: "Email",
                      textColor: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    const YMargin(5),
                    SizedBox(
                      height: 25.h,
                      child: TextFormField(
                        controller: emailController,
                        validator: (val) {
                          RegExp regex = RegExp(pattern);

                          if (val == null ||
                              val.isEmpty ||
                              !regex.hasMatch(val)) {
                            return "Input a valid email";
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          errorStyle: const TextStyle(fontSize: 0.01),
                          hintText: "alimoses_@gmail.com",
                          hintStyle: const TextStyle(fontSize: 12),
                          contentPadding:
                              const EdgeInsets.only(left: 5, top: 3),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                        ),
                      ),
                    ),
                    const YMargin(10),
                    const NormalText(
                      text: "Password",
                      textColor: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    const YMargin(5),
                    SizedBox(
                      height: 25.h,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: obscure,
                        style: const TextStyle(fontSize: 12),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Input valid password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "*******",
                          suffixIcon: InkWell(
                            onTap: () {
                              obscure = !obscure;
                              setState(() {});
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                size: 17,
                              ),
                            ),
                          ),
                          errorStyle: const TextStyle(fontSize: 0.1),
                          hintStyle: const TextStyle(fontSize: 12),
                          contentPadding:
                              const EdgeInsets.only(left: 8, top: 3),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                        ),
                      ),
                    ),
                    const YMargin(10),
                    const NormalText(
                      text: "Full Name",
                      textColor: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    const YMargin(5),
                    SizedBox(
                      height: 25.h,
                      child: TextFormField(
                        controller: fullnameContoller,
                        style: const TextStyle(fontSize: 12),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Input valid name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "John Doe",
                          errorStyle: const TextStyle(fontSize: 0.1),
                          hintStyle: const TextStyle(fontSize: 12),
                          contentPadding:
                              const EdgeInsets.only(left: 8, top: 3),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                  color: XColors.textColor, width: 0.5)),
                        ),
                      ),
                    ),
                    const YMargin(10),
                    if (isStudent) ...[
                      const NormalText(
                        text: "Department",
                        textColor: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      const YMargin(5),
                      Container(
                        height: 25.h,
                        width: 250.w,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black, width: 0.5)),
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
                      const NormalText(
                        text: "Level",
                        textColor: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                      const YMargin(5),
                      Container(
                        height: 25.h,
                        width: 250.w,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black, width: 0.5)),
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
                      )
                    ],
                    const YMargin(20),
                    XButton(
                        buttonName: "Sign Up",
                        fontSize: 14,
                        buttonRadius: 5,
                        mHeight: 30.h,
                        mWidth: 200,
                        action: () {
                          if (key.currentState!.validate()) {
                            signUP();
                          }
                        },
                        textColor: Colors.white,
                        buttonColor: XColors.mainColor),
                    const YMargin(5),
                    const YMargin(30),
                    InkWell(
                      onTap: () {
                        navigate(context, const SignInScreen());
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                            text: TextSpan(
                                text: "Hava an account? ",
                                style: TextStyle(
                                    color: XColors.textColor, fontSize: 8),
                                children: const [
                              TextSpan(
                                  text: "Sign In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11)),
                            ])),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  signUP() async {
    context.loaderOverlay.show();

    AuthenticationViewmodel viewmodel = context.read<AuthenticationViewmodel>();

    if (isStudent) {
      Map<String, dynamic> data = {
        "name": fullnameContoller.text,
        "dept": chosenDeprt,
        "level": currentLevel,
      };

      await viewmodel.createStudent(
          emailController.text, passwordController.text, data);

      if (viewmodel.createStudentesource.ops == NetworkStatus.SUCCESSFUL) {
        await viewmodel.getStudentProfile();
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: XColors.mainColor,
            content: NormalText(
              text: "Account created",
              textColor: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        navigate(context, const StudentDashboard());
      } else {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: XColors.mainColor,
            content: NormalText(
              text: viewmodel.createStudentesource.networkError ?? "",
              textColor: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    } else {
      await viewmodel.createLecturer(emailController.text,
          passwordController.text, fullnameContoller.text);

      if (viewmodel.createLectureResource.ops == NetworkStatus.SUCCESSFUL) {
        await viewmodel.getLecturerProfile();
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: XColors.mainColor,
            content: NormalText(
              text: "Account created",
              textColor: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        navigate(context, const DashboardScreen());
      } else {
        context.loaderOverlay.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: XColors.mainColor,
            content: NormalText(
              text: viewmodel.createLectureResource.networkError ?? "",
              textColor: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }
    }
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
}
