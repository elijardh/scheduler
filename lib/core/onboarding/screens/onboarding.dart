import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scheduler/app/navigation/navigator.dart';
import 'package:scheduler/app/presentations/button.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/margin.dart';
import 'package:scheduler/core/authentication/screen/sign%20in.dart';
import 'package:scheduler/core/authentication/screen/sign_up.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XColors.mainColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: XButton(
                  buttonName: "Login",
                  fontSize: 20,
                  mHeight: 40.h,
                  mWidth: 200,
                  action: () async {
                    navigate(context, const SignInScreen());
                  },
                  buttonColor: Colors.white),
            ),
            const YMargin(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: XButton(
                  buttonName: "SignUp",
                  fontSize: 20,
                  mHeight: 40.h,
                  mWidth: 200,
                  action: () {
                    navigate(context, const SignUpScreen());
                  },
                  buttonColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
