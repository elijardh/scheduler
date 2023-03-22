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
import 'package:scheduler/core/authentication/screen/sign_up.dart';
import 'package:scheduler/core/authentication/view%20model/authentication_viewmodel.dart';
import 'package:scheduler/core/lecturer/dashboard/screens/dashboard_screen.dart';
import 'package:scheduler/core/student/student_dashboard/screens/student_dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool obscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final key = GlobalKey<FormState>();
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
                      text: "Login",
                      textColor: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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
                    Row(
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Transform.scale(
                            scale: 0.7,
                            child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.green,
                                side: BorderSide(
                                    color: XColors.textColor, width: 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                value: checkBoxValue,
                                onChanged: (val) async {
                                  // SharedPreferences prefs =
                                  //     await SharedPreferences.getInstance();

                                  // prefs.setBool("rememberme", val!);

                                  checkBoxValue = val!;

                                  setState(() {});
                                }),
                          ),
                        ),
                        const NormalText(
                          text: "Remember me?",
                          textColor: Colors.black,
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    const YMargin(20),
                    XButton(
                        buttonName: "Login",
                        fontSize: 14,
                        buttonRadius: 5,
                        mHeight: 30.h,
                        mWidth: 200,
                        action: () {
                          if (key.currentState!.validate()) {
                            signIn();
                          }
                        },
                        textColor: Colors.white,
                        buttonColor: XColors.mainColor),
                    const YMargin(5),
                    InkWell(
                      onTap: () {},
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: NormalText(
                          text: "Forgot Password?",
                          fontSize: 8,
                          textColor: XColors.textColor,
                        ),
                      ),
                    ),
                    const YMargin(10),
                    InkWell(
                      onTap: () {
                        navigate(context, const SignUpScreen());
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                            text: TextSpan(
                                text: "Need an account? ",
                                style: TextStyle(
                                    color: XColors.textColor, fontSize: 8),
                                children: const [
                              TextSpan(
                                  text: "SignUp",
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

  signIn() async {
    context.loaderOverlay.show();
    AuthenticationViewmodel viewmodel = context.read<AuthenticationViewmodel>();

    await viewmodel.signIn(emailController.text, passwordController.text);

    if (viewmodel.signInResource.ops == NetworkStatus.SUCCESSFUL) {
      context.loaderOverlay.hide();
      if (viewmodel.signInStudent!) {
        navigate(context, const StudentDashboard());
      } else {
        navigate(context, const DashboardScreen());
      }
    } else {
      context.loaderOverlay.hide();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: XColors.mainColor,
          content: NormalText(
            text: viewmodel.signInResource.networkError ?? "",
            textColor: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }
}
