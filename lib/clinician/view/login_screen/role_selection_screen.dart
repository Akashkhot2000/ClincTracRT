// ignore_for_file: prefer_const_constructors

import 'package:app_version_update/app_version_update.dart';
import 'package:clinicaltrac/clinician/view/login_screen/role_select_bottom_widget.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';

class UserRoleSelectScreen extends StatefulWidget {
  const UserRoleSelectScreen({Key? key}) : super(key: key);

  @override
  State<UserRoleSelectScreen> createState() => _UserRoleSelectScreenState();
}

class _UserRoleSelectScreenState extends State<UserRoleSelectScreen> {
  @override
  void initState() {
    super.initState();
    _checkAppUpdate();
  }

  void _checkAppUpdate() async {
    final appleId =
        '6443408875'; // If this value is null, its packagename will be considered
    final playStoreId =
        'com.gigoclean.app'; // If this value is null, its packagename will be considered
    final country =
        'us'; // If this value is null 'us' will be the default value
    AppVersionUpdate.checkForUpdates(
        appleId: appleId, playStoreId: playStoreId, country: country)
        .then((data) async {
      if (data.canUpdate!) {
        print(data.storeUrl);
        print(data.storeVersion);
        print("canUpdate${data.canUpdate}");

        AppVersionUpdate.showAlertUpdate(
            context: context,
            appVersionResult: data,
            title: 'New version available',
            mandatory: false,
            titleTextStyle:
            TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
            content: 'Would you like to update your application?',
            contentTextStyle:
            TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
            cancelButtonStyle: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey)),
            updateButtonStyle: ButtonStyle(
                backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 9, 185, 182))),
            cancelButtonText: 'UPDATE LATER',
            updateButtonText: 'UPDATE',
            cancelTextStyle: TextStyle(color: Colors.white),
            updateTextStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.white);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // height: globalHeight  * 0.55,
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
          RoleSelectBottomWidget(),
        ],
      ),
    );
  }
}
