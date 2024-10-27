import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';

class CominSoonScreen extends StatelessWidget {
  CominSoonScreen({Key? key, this.isAppbar, this.title}) : super(key: key);
  bool? isAppbar;
  String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isAppbar == true
          ? CommonAppBar(
              appBarColor: Colors.white,
              isBackArrow: true,
              isCenterTitle: true,
              title: title,
            )
          : null,
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(
            left: 5,
            right: 5,
            top: 10,
          ),
          child: Container(
            // height: globalHeight * 0.27,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Color(0xFF01A750),
            ),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    height: globalHeight * 0.15,
                  ),
                  Text(
                    "Exciting New Feature Coming Soon!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF01A750),
                        ),
                  ),
                  SizedBox(
                    height: globalHeight * 0.1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Get ready for an amazing addition to our app! We're working hard to bring you a powerful new feature that will enhance your experience. Stay tuned for the upcoming update to unlock this exciting functionality.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
