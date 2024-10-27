import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;

  const CustomTextField(
      {Key? key, required this.controller, this.hintText, this.label})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return
        // Padding(
        //   padding: EdgeInsets.all(0.5.h),
        //   child: Container(
        //     width: 90,
        //     height: 105,
        //     child:
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 0.5.h),
          child: Text(
            widget.label!,
            style: TextStyle(
              color: Color(0xFF5F6377),
              fontSize: 15.5.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: ShapeDecoration(
            color: Color(0xFFF6F9F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(1.h),
            child: TextFormField(
              controller: widget.controller,
              decoration: InputDecoration(
                  hintText: widget.hintText!,
                  hintStyle: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 15.5.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
      ],
      // ),
      // ),
    );
  }
}
