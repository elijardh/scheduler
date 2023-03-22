import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class XMargin extends StatelessWidget {
  const XMargin(this.x, {Key? key}) : super(key: key);
  final double x;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x.w);
  }
}

class YMargin extends StatelessWidget {
  const YMargin(this.y, {Key? key}) : super(key: key);
  final double y;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: y.h);
  }
}

double screenHeight(BuildContext context, {double percent = 1}) =>
    MediaQuery.of(context).size.height * percent;

double screenWidth(BuildContext context, {double percent = 1}) =>
    MediaQuery.of(context).size.width * percent;
