import 'dart:async';

import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({Key? key}) : super(key: key);

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  double _size = 200.0;
  bool _large = false;
//declaration of hive box
  late Box<UserLoginResponseHive> box;
  void _updateSize() {
    setState(() {
      _size = _large ? 250.0 : 200.0;
      _large = !_large;
    });
  }

  void initState() {
    box = Boxes.getUserInfo();
    super.initState();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _updateSize();
      });
//------------------------------- Clinician/Student ----------------------------------------------------------------------------------------------
      Navigator.pushNamedAndRemoveUntil(
          context,
          box.isNotEmpty
              ? box.get(Hardcoded.hiveBoxKey)!.accessToken.isEmpty
                  ? Routes.roleSelectionScreen
                  // ? Routes.userLogin
                  : Routes.bodySwitcher
              :Routes.roleSelectionScreen, (route) => false);
              // :Routes.userLogin, (route) => false);
//----------------------------------------------------------------------------------------------------------------------------------------------
// -------------------------------------Student ----------------------------------------------------------------------------------------------
//       Navigator.pushNamedAndRemoveUntil(
//           context,
//           box.isNotEmpty
//               ? box.get(Hardcoded.hiveBoxKey)!.accessToken.isEmpty
//               ? Routes.login
//               : Routes.bodySwitcher
//               :Routes.login, (route) => false);
//--------------------------------------------------------------------------------------------------------------------------
    });
  }

  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery.of(context).size.width;
    globalHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: globalHeight,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(Hardcoded.primaryGreen),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedSize(
              curve: Curves.easeIn,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/images/logo.png',
                height: _size,
              ),
            ),
          ),
          // Positioned(
          //     top: -100,
          //     right: -180,
          //     child: Image.asset('assets/images/splash_top.png')),
          // Positioned(
          //     bottom: -200,
          //     left: -300,
          //     child: Image.asset('assets/images/splash_bottom.png')),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 100),
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: RoundedButton(
          //       onTap: () {
          //         // Navigator.pushNamedAndRemoveUntil(
          //         //     context, Routes.login, (route) => false);
          //       },
          //       width: globalWidth * 0.4,
          //       showBorder: false,
          //       title: 'Get Started',
          //       textcolor: Color(Hardcoded.primaryGreen),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
