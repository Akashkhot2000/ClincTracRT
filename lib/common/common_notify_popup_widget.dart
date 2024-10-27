import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<dynamic> common_notify_popup_widget(
    BuildContext context,
    String mainTitle,
    String url_title,
    String mail_title,
    Function() onTapNotify,
    Function() onTapCopyUrl,
    Function() onTapSendMail) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(31.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 20.0, bottom: 10, left: 18, right: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: globalWidth * 0.18),
                    child: Text(
                      "Notify Again",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Color(
                          0xFF01A750),),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/images/close_modal.svg',
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
             Padding(
                  padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 6),
                  child: Column(
                    children: [
                      // SizedBox(height: 10),
                      GestureDetector(
                        onTap: onTapNotify,
                        child: Container(
                          height: globalHeight * 0.06,
                          width: globalWidth * 0.7,
                          decoration: BoxDecoration(
                              color: Color(0x1413AD5D),
                              borderRadius: BorderRadius.circular(15)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              mainTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: onTapCopyUrl,
                        child: Container(
                          height: globalHeight * 0.06,
                          width: globalWidth * 0.7,
                          decoration: BoxDecoration(
                              color: Color(0x1413AD5D),
                              borderRadius: BorderRadius.circular(15)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              url_title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: onTapSendMail,
                        child: Container(
                          height: globalHeight * 0.06,
                          width: globalWidth * 0.7,
                          decoration: BoxDecoration(
                              color: Color(0x1413AD5D),
                              borderRadius: BorderRadius.circular(15)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              mail_title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
            // SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
