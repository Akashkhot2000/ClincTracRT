import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

Future<Widget?> common_alert_pop(
    BuildContext context, String title, String icon, Function()? onTap) {
  return showDialog<Widget?>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(31.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  SizedBox(height: 45),
                  SvgPicture.asset(
                    icon,
                  ),
                  SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              // Text(
              //   subtitle,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0XFF5F6377)),
              // ),
              SizedBox(height: 20),
              CommonRoundedLoadingButton(
                controller: RoundedLoadingButtonController(),
                title: "Ok",
                textcolor: Color(Hardcoded.white),
                color: Color(Hardcoded.primaryGreen),
                width: 150,
                onTap: () {
                  Navigator.pop(context);
                },
                // onTap! != null ? onTap : (){Navigator.pop(context);}
              ),
              SizedBox(height: 36),
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> common_popup_widget(
    BuildContext context, String title, String icon, Function() onTap) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(31.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  SizedBox(height: 30),
                  SvgPicture.asset(
                    icon,
                  ),
                  SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              // Text(
              //   subtitle,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0XFF5F6377)),
              // ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 5),
                  Container(
                    height: 60,
                    width: globalWidth * 0.3,
                    color: Colors.transparent,
                    child: CommonRoundedLoadingButton(
                      controller: RoundedLoadingButtonController(),
                      title: "Yes",
                      textcolor: Color(Hardcoded.white),
                      color: Color(Hardcoded.primaryGreen),
                      width: 100,
                      height: 45,
                      onTap: onTap,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: globalWidth * 0.3,
                    color: Colors.transparent,
                    child: CommonRoundedLoadingButton(
                      controller: RoundedLoadingButtonController(),
                      title: "No",
                      textcolor: Color(Hardcoded.white),
                      color: Color(0xFFFA0202),
                      width: 100,
                      height: 45,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 36),
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> common_rotation_popup_widget(
    BuildContext context,
    String mainTitle,
    String title,
    String icon,
    Color imageColor,
    Function() onTap) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMM dd, yyyy').format(now);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(31.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    mainTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: imageColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 10, left: 8, top: 8, bottom: 10),
                      child: Image.asset(
                        icon,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        mainTitle == "Clock In"
                            ? "Clock-In date : "
                            : "Clock-Out date : ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(Hardcoded.greyText)),
                      ),
                      Text(
                        "${formattedDate}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
              // Text(
              //   subtitle,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0XFF5F6377)),
              // ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 5),
                  Container(
                    height: 60,
                    width: 100,
                    color: Colors.transparent,
                    child: CommonRoundedLoadingButton(
                      controller: RoundedLoadingButtonController(),
                      title: "Yes",
                      textcolor: Color(Hardcoded.white),
                      color: Color(Hardcoded.primaryGreen),
                      width: 100,
                      height: 45,
                      onTap: onTap,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 100,
                    color: Colors.transparent,
                    child: CommonRoundedLoadingButton(
                      controller: RoundedLoadingButtonController(),
                      title: "No",
                      textcolor: Color(Hardcoded.white),
                      color: Color(0xFFFA0202),
                      width: 100,
                      height: 45,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
              SizedBox(height: 26),
            ],
          ),
        ),
      );
    },
  );
}
