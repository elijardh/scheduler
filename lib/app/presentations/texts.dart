import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NormalText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? textColor;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final String? fontFamily;
  final double? textHeight;

  const NormalText(
      {Key? key,
      required this.text,
      this.fontSize,
      this.textColor,
      this.fontWeight,
      this.textAlign,
      this.maxLines,
      this.textHeight,
      this.fontFamily})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          height: textHeight ?? 1.2,
          fontSize: fontSize != null ? (fontSize!.sp).toDouble() : 15.sp,
          color: textColor,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: fontFamily),
    );
  }
}
