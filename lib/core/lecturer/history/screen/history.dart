import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/texts.dart';
import 'package:scheduler/core/lecturer/lecturer_home/widgets/lecture%20schedule%20widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const SizedBox(),
        centerTitle: true,
        title: NormalText(
          text: "History Screen",
          textColor: Colors.black,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: NormalText(
            text: "WIP",
            textColor: XColors.textColor,
            fontSize: 30.sp,
          ),
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
