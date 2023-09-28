import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:scheduler/app/notification/notification_service.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/core/authentication/view%20model/authentication_viewmodel.dart';
import 'package:scheduler/core/lecturer/lecturer_home/view%20model/home_viewmodel.dart';
import 'package:scheduler/core/onboarding/screens/splash.dart';
import 'package:scheduler/firebase_options.dart';

import 'core/lecturer/lecturer_schedule/view model/lectureScheduleViewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, name: "scheduler");

  await NotificationService.setupFirebaseCloudMessaging();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationViewmodel()),
        ChangeNotifierProvider(create: (_) => LectureScheduleViewmodel()),
        ChangeNotifierProvider(create: (_) => HomeViewmodel())
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => GlobalLoaderOverlay(
          closeOnBackButton: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: XColors.mainColor,
              iconTheme: const IconThemeData(color: Colors.black, size: 15),
              backgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              textTheme: TextTheme(
                  bodyLarge: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    height: 1.0,
                    fontWeight: FontWeight.w400,
                    color: XColors.textColor,
                  ),
                  bodyMedium: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 15,
                    height: 1.0,
                    fontWeight: FontWeight.w400,
                    color: XColors.textColor,
                  )),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              bottomAppBarTheme: const BottomAppBarTheme(color: Colors.red),
            ),
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
