import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/action/reset_store_action.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/adapters.dart';

class LogoutPopup extends StatefulWidget {
  const LogoutPopup({Key? key}) : super(key: key);

  @override
  State<LogoutPopup> createState() => _LogoutPopupState();
}

class _LogoutPopupState extends State<LogoutPopup> {
  Box<UserLoginResponseHive>? box;

  @override
  void initState() {
    box = Boxes.getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var box = Boxes.getUserInfo();
    UserLoginResponseHive? hive = box.get('key');
    return Dialog(
      backgroundColor: Color(Hardcoded.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(31.0),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            width: globalWidth * 0.8,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/logout_popup_assets.svg',
                  height: globalHeight * 0.15,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Logout',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Do you want to logout?',
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black54),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RoundedButton(
                          textcolor: Color(Hardcoded.primaryGreen),
                          showBorder: true,
                          title: 'No',
                          onTap: () {
                            Navigator.pop(context);
                          }),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: RoundedButton(
                          textcolor: Colors.white,
                          color: Color(Hardcoded.primaryGreen),
                          showBorder: false,
                          title: 'Yes',
                          onTap: () async {
                           await logOut();
                           setState(() {});
                            // final DataService dataService = locator();
                            // final DataResponseModel dataResponseModel =
                            //     await dataService.logout(
                            //   // hive!.loggedUserId,
                            //   // hive.accessToken,
                            //   // hive.loggedUserloginhistoryId
                            //   box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                            //   box.get(Hardcoded.hiveBoxKey)!.accessToken,
                            //   box
                            //       .get(Hardcoded.hiveBoxKey)!
                            //       .loggedUserloginhistoryId,
                            //   // store.state.userLoginResponse.data.loggedUserloginhistoryId
                            // );
                            //
                            // if (dataResponseModel.success) {
                            //   //remove all data from box
                            //   await box!.clear().then((value) {
                            //     log(box!.isEmpty.toString());
                            //     store.dispatch(ResetStoreAction());
                            //     Navigator.pushNamedAndRemoveUntil(
                            //         context, Routes.login,
                            //         (Route<dynamic> route) {
                            //       return false;
                            //     });
                            //   });
                            // } else {
                            //   AppHelper.buildErrorSnackbar(context,
                            //       dataResponseModel.errorResponse.errorMessage);
                            // }
                          },),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logOut() async {
    UserDatRepo userDatRepo = new UserDatRepo();
    try {
      userDatRepo.logOutUser(
          box!.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box!.get(Hardcoded.hiveBoxKey)!.accessToken,
          box!.get(Hardcoded.hiveBoxKey)!.loggedUserType == "Student" ? "0" : "1",
          box!.get(Hardcoded.hiveBoxKey)!.loggedUserloginhistoryId, () {
        box!.clear().then((value) {
          AppConsts.userType = "0";
          log(box!.isEmpty.toString());
          box!.clear();
          store.dispatch(ResetStoreAction());
          Navigator.pushNamedAndRemoveUntil(context, Routes.roleSelectionScreen,
              (Route<dynamic> route) {
            return false;
          });
        });
      }, () {}, context);
    } catch (e) {
      AppHelper.buildErrorSnackbar(context, e.toString());
    }
  }
}
