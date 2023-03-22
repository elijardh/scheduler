import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scheduler/app/presentations/colors.dart';
import 'package:scheduler/app/presentations/texts.dart';

class XButton extends StatelessWidget {
  final String buttonName;
  final double fontSize;
  final double mHeight;
  final double mWidth;
  final Function action;
  final double? buttonRadius;
  final Color buttonColor;
  final Widget? buttonIcon;
  final Color? borderColor;
  final Color? textColor;

  const XButton(
      {Key? key,
      required this.buttonName,
      required this.fontSize,
      required this.mHeight,
      required this.mWidth,
      this.buttonRadius,
      this.buttonIcon,
      this.borderColor,
      required this.action,
      this.textColor,
      required this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => action(),
      style: TextButton.styleFrom(
        backgroundColor: buttonColor,
        minimumSize: Size(mWidth.w, mHeight.h),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(buttonRadius ?? 10),
            ),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide(color: buttonColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (buttonIcon != null) buttonIcon!,
          if (buttonIcon != null)
            SizedBox(
              width: 10.w,
            ),
          NormalText(
            text: buttonName,
            fontFamily: "Mulish",
            textAlign: TextAlign.center,
            textColor: textColor ?? XColors.textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          )
        ],
      ),
    );
  }
}
