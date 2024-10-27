// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, unnecessary_brace_in_string_interps

import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// item tap is function to give callback to homepage to change selected index
typedef ItemTap = void Function(
  Bottom_navigation_control index,
  BuildContext context,
);

/// This is used for text and icon layout inside bottom navigation bar and inside this navigation flow can be customized
class BottomBarButton extends StatelessWidget {
  /// constructor
  const BottomBarButton(
    this.label,
    this.imagePath,
    this.index,
    this.selectedNavigation,
    this.tapped, {
    Key? key,
  }) : super(key: key);

  /// icon that would be showed above name
  final String label;
  final String imagePath;

  /// to know index of component drawn
  final Bottom_navigation_control index;

  /// to know which index is pressed
  final Bottom_navigation_control selectedNavigation;

  /// function
  final ItemTap tapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tapped(index, context);
      },
      // ignore: sized_box_for_whitespace
      child: Padding(
        padding: REdgeInsets.only(top: 2.5),
        child: Column(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedNavigation == index
                      ? Color(0xFF01A750)
                      : Colors.white),
              child: Padding(
                padding: REdgeInsets.all(10.0),
                child: Image.asset(
                  imagePath,
                  color: selectedNavigation == index
                      ? Color(0xFFFFFFFF)
                      : Color(0xFF6C6C6C),
                  // colorFilter: ColorFilter.mode(selectedNavigation == index
                  //     ? Color(0xFFFFFFFF)
                  //     : Color(0xFF6C6C6C), BlendMode.srcIn),
                ),
                // Icon(icon, color: selectedNavigation == index ? Color(Hardcoded.primaryGreen) : Colors.grey.shade400,),
              ),
            ),
            Padding(
              padding: REdgeInsets.only(top: 2),
              child: Text(
                "${label}",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      color: selectedNavigation == index
                          ? Color(0xFF01A750)
                          : Color(0xFF6C6C6C),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
