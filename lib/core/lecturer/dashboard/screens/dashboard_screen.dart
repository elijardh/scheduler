import 'package:flutter/material.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/core/lecturer/history/screen/history.dart';
import 'package:scheduler/core/lecturer/lecturer_home/screen/lecturer%20home.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController controller = PageController();
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: PageView(
          controller: controller,
          children: const [LecturerHomeScreen(), HistoryScreen()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: current,
        onTap: (value) {
          controller.jumpToPage(value);
          current = value;
          setState(() {});
        },
      ),
    );
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
        color: XColors.mainColor,
      ),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.history_edu_outlined,
        color: XColors.mainColor,
      ),
      label: "History",
    ),
  ];
}
