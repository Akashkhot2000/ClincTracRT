// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:app_version_update/app_version_update.dart';
import 'package:clinicaltrac/common/App_Version_Update/app_version_update.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ///controllers
  TextEditingController schoolCodeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordCodeController = TextEditingController();

  //buttonController

  RoundedLoadingButtonController roundedLoadingButtonController =
  RoundedLoadingButtonController();

  bool showPassword = true;

  final schoolCodeFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  void _checkAppUpdate() async {
    final appleId =
        '6450888634'; // If this value is null, its packagename will be considered
    final playStoreId =
        'com.clinicaltrac.app'; // If this value is null, its packagename will be considered
    final country =
        'us'; // If this value is null 'us' will be the default value
    AppVersionUpdate.checkForUpdates(
        appleId: appleId, playStoreId: playStoreId, country: country)
        .then((data) async {
      if (data.canUpdate!) {
        print(data.storeUrl);
        print(data.storeVersion);
        print("canUpdate${data.canUpdate}");

         CTAppVersionUpdate.showAlertUpdate(
            context: context,
            appVersionResult: data,
            title: 'New version available',
            mandatory: true,
            titleTextStyle:
            Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20.0, fontWeight: FontWeight.w600),
            content: 'Please update your application',
            contentTextStyle:
            Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
            cancelButtonStyle: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey),),
            updateButtonStyle: ButtonStyle(
                backgroundColor:
                MaterialStatePropertyAll(Color(0xFF01A750))),
            // cancelButtonText: 'UPDATE LATER',
            updateButtonText: 'UPDATE',
            cancelTextStyle: TextStyle(color: Colors.white),
            updateTextStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.white);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // _checkAppUpdate();
  }

  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery
        .of(context)
        .size
        .width;
    globalHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: globalHeight  * 0.45,
              // height: globalHeight / 1.03,
              // height: globalHeight+(globalHeight *0.15),
              decoration: BoxDecoration(
                color: Color(Hardcoded.primaryGreen),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top:  globalHeight * 0.10,
                bottom:  globalHeight * 0.02,
              ),
              child: Image.asset(
                'assets/images/logo.png',
                height: 170,
              ),
            ),
            Positioned(
              top: -globalHeight * 0.15,
              right: -180,
              child: Image.asset('assets/images/splash_top.png'),
            ),
            Positioned(
              top: 30,
              left: -300,
              child: Image.asset('assets/images/splash_bottom.png'),
            ),
              LoginBottomScreen(),
          ],
        )
    );
  }
}