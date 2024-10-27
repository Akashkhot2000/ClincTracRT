import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      this.color,
      required this.showBorder,
      this.borderColor,
      required this.title,
      this.textcolor,
      this.height,
      this.textheight,
      this.width,
      required this.onTap})
      : super(key: key);

  final Color? color;

  final bool showBorder;

  final Color? borderColor;

  final String title;

  final Color? textcolor;

  final double? height;
  final double? width;

  final double? textheight;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: showBorder ? Border.all(color: borderColor ?? Color(Hardcoded.primaryGreen)) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 17, color: textcolor, height: textheight),
          ),
        ),
      ),
    );
  }
}

class CommonRoundedLoadingButton extends StatelessWidget {
  const CommonRoundedLoadingButton(
      {super.key,
      required this.controller,
      this.color,
      //required this.showBorder,
      this.borderColor,
      required this.title,
      this.textcolor,
      this.height = 60,
      this.textheight,
      this.width = 200,
      required this.onTap});

  final RoundedLoadingButtonController controller;
  final Color? color;

  //final bool showBorder;

  final Color? borderColor;

  final String title;

  final Color? textcolor;

  final double? height;
  final double? width;

  final double? textheight;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      elevation: 2,
      height: height!,
      width: width!,
      controller: controller,
      onPressed: onTap,
      color: color,
      borderRadius: 16,
      successColor: Color(Hardcoded.primaryGreen),
      valueColor: color == Color(Hardcoded.primaryGreen) ? Color(Hardcoded.white) : Color(Hardcoded.white),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15, color: textcolor, height: textheight),
        ),
      ),
    );
  }
}
