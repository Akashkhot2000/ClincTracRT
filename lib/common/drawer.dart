// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:clinicaltrac/clinician/model/profile_models/user_detail_model.dart';
import 'package:clinicaltrac/common/coming_soon_screen_widget.dart';
import 'package:clinicaltrac/common/common_profile_photo.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/logout_popup.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/profile/model/get_student_detailss_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class clinicaltracDrawer extends StatelessWidget {
  StudentDetailsResponse studentDetailsResponse;
  UserDetailData? userDetailData;

  clinicaltracDrawer(
      {super.key, required this.studentDetailsResponse, this.userDetailData});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: globalWidth * 0.8,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: globalHeight * 0.17,
                ),
                // const SizedBox(
                //   height: 25,
                // ),
                // Divider(
                //   color: Color(Hardcoded.divderColor),
                // ),
                // GestureDetector(
                //   onTap: () {
                //     store.dispatch(makeProfileEditable());
                //     Navigator.pushNamed(context, Routes.profileScreen);
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(
                //       top: 10,
                //       left: 20,
                //       right: 20,
                //       bottom: 10,
                //     ),
                //     child: Row(
                //       children: [
                //         Container(
                //           margin: const EdgeInsets.only(left: 5, right: 5),
                //           height: 50,
                //           width: 50,
                //           decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Color(Hardcoded.greenLight)),
                //           child: Padding(
                //             padding: const EdgeInsets.all(12.0),
                //             child: SvgPicture.asset('assets/images/user-edit.svg'),
                //           ),
                //         ),
                //         const SizedBox(
                //           width: 18,
                //         ),
                //         Expanded(
                //           child: Text(
                //             'Edit Profile',
                //             textAlign: TextAlign.start,
                //             style: Theme.of(context).textTheme.titleLarge!.copyWith(
                //                   fontWeight: FontWeight.w400,
                //                   fontSize: 14,
                //                 ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, Routes.changeUserPasswordScreen);
                  },
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 20,
                        right: 20,
                        bottom: 5,
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(Hardcoded.greenLight)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SvgPicture.asset('assets/images/key.svg'),
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Text(
                              'Change Password',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Color(Hardcoded.divderColor),
                ),
                // SizedBox(
                //   height: globalHeight * 0.1,
                // ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                        arguments: BodySwitcherData(
                            initialPage: Bottom_navigation_control.profile));
                  },
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                            color: Color(Hardcoded.divderColor), width: 0.4),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: globalHeight * 0.04, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          commonProfilePhoto(
                            isEdit: false,
                            ImageLink: TextEditingController(
                                text: userDetailData!.loggedUserProfile!),
                            // text: studentDetailsResponse.data.loggedUserProfile),
                            LocalPath:
                                'assets/images/default_profile_photo.png',
                            // TextEditingController(
                            //     text:
                            //         'assets/images/default_profile_photo.png'),
                            radius: 30,
                            isLocal: userDetailData!.loggedUserProfile!.isEmpty,
                            // isLocal: studentDetailsResponse.data.loggedUserProfile.isEmpty,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${userDetailData!.loggedUserFirstName!} ${userDetailData!.loggedUserLastName!}",
                                  // "${studentDetailsResponse.data.loggedUserFirstName} ${studentDetailsResponse.data.loggedUserLastName}",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                ),
                                Text(
                                  userDetailData!.loggedUserEmail!,
                                  // store.state.studentDetailsResponse.data.loggedUserEmail,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                ),
                                Text(
                                  "Edit Profile",
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF01A750),
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  top: globalHeight * 0.5,
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: globalHeight * 0.15,
                    width: globalWidth * 2,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: globalHeight * 0.01,
                            bottom: globalHeight * 0.001,
                            // right: globalHeight * 0.01,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: globalWidth * 0.15,
                              right: globalWidth * 0.15,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                log("logout");
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();

                                sharedPreferences.setBool('isUserLogin', false);
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const LogoutPopup();
                                    });
                              },
                              child: Container(
                                width: globalWidth * 0.45,
                                height: globalHeight * 0.08,
                                decoration: BoxDecoration(
                                    // color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Color(0xFF01A750),
                                      // BorderSide(width: 0.4, color: Colors.black12),
                                    )),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: globalWidth * 0.07,
                                        right: 0,
                                      ),
                                      child: Text(
                                        'Logout',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        bottom: 5,
                                        right: globalWidth * 0.035,
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/logoutimg.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: globalHeight * 0.01,
                            bottom: globalHeight * 0.02,
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text("${AppConsts.strBuildVersion}",
                                style: TextStyle(
                                    color: Color(Hardcoded.primaryGreen),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
