import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scheduler/app/presentations/colors.dart';

class XTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final TextInputAction? textInputAction;
  final bool? obscureText;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final Color? normalBorderColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? hintTextColor;
  final Color? normalTextColor;
  final Function(String v)? onChange;
  final Function()? onSubmitted;
  final String? Function(String? v)? validator;
  final bool? autoFocus;
  final bool? isEnabled;
  final String? fontFamily;
  final double? textSize;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxlenth;
  final bool? maxlenghtenforced;
  final FocusNode? node;
  final String? prefixText;
  final String? sufficeText;
  final String? obscureCharacter;
  final double? borderWidth;
  final bool? underlineborder;
  const XTextField(
      {Key? key,
      this.borderWidth,
      this.underlineborder = false,
      this.obscureCharacter,
      required this.controller,
      required this.hintText,
      this.textInputAction,
      this.obscureText,
      this.fillColor,
      this.keyboardType,
      this.normalBorderColor,
      this.enabledBorderColor,
      this.focusedBorderColor,
      this.hintTextColor,
      this.onChange,
      this.sufficeText,
      this.normalTextColor,
      this.autoFocus,
      this.isEnabled,
      this.fontFamily,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.maxlenth,
      this.textSize,
      this.maxlenghtenforced,
      this.onSubmitted,
      this.node,
      this.prefixText})
      : super(key: key);

  @override
  State<XTextField> createState() => _XTextFieldState();
}

class _XTextFieldState extends State<XTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      maxLength: widget.maxlenth,
      onEditingComplete: () {
        if (widget.onSubmitted != null) {
          widget.onSubmitted!();
        }
      },
      autofocus: widget.autoFocus ?? false,
      focusNode: widget.node,
      obscuringCharacter: widget.obscureCharacter ?? ".",
      enabled: widget.isEnabled ?? true,
      style: Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: (widget.textSize?.sp ?? 11.sp).toDouble(),
          color: widget.normalTextColor ?? XColors.textColor,
          fontFamily: widget.fontFamily ?? "Mulish"),
      obscureText: widget.obscureText ?? false,
      controller: widget.controller,
      textAlign: TextAlign.start,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      onChanged: (s) {
        if (widget.onChange != null) {
          widget.onChange!(s);
        }
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        prefixText: widget.prefixText ?? "",
        suffixText: widget.sufficeText ?? "",
        suffixIcon: widget.suffixIcon,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
            fontSize: (widget.textSize?.sp ?? 11.sp).toDouble(),
            color: widget.hintTextColor ?? XColors.lightText,
            fontFamily: widget.fontFamily ?? "Mulish"),
        filled: true,
        fillColor: widget.fillColor ?? Colors.white,
        errorStyle: const TextStyle(color: Colors.red),
        disabledBorder: !widget.underlineborder!
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: widget.normalBorderColor ?? Colors.white,
                    width: widget.borderWidth ?? 1))
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: XColors.lightText.withOpacity(0.5),
                ),
              ),
        border: !widget.underlineborder!
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: widget.normalBorderColor ?? Colors.white,
                    width: widget.borderWidth ?? 1))
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: XColors.lightText.withOpacity(0.5),
                ),
              ),
        enabledBorder: !widget.underlineborder!
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: widget.normalBorderColor ?? Colors.white,
                    width: widget.borderWidth ?? 1))
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: XColors.lightText.withOpacity(0.5),
                ),
              ),
        focusedBorder: !widget.underlineborder!
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                    color: widget.normalBorderColor ?? Colors.white,
                    width: widget.borderWidth ?? 1))
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: XColors.lightText.withOpacity(0.5),
                ),
              ),
      ),
    );
  }
}
