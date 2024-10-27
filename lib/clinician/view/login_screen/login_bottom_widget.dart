// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/clinician/view/clini_dashboard/model/userResp_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/action/set_hive_data_to_state.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/forgot_pwd/forgot_pwd_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBottomWidget extends StatefulWidget {
  const LoginBottomWidget({super.key});

  @override
  State<LoginBottomWidget> createState() => _LoginBottomWidgetState();
}

class _LoginBottomWidgetState extends State<LoginBottomWidget> {
  ///Textfield controllers
  TextEditingController schoolCodeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordCodeController = TextEditingController();

  ///Scroll Controller
  ScrollController scrollController = ScrollController();

  ///Button Controllers
  RoundedLoadingButtonController roundedLoadingButtonController =
      RoundedLoadingButtonController();

  bool showPassword = true;

  final schoolCodeFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  bool status1 = false;
  String statusValue = "Student";
  int userType = 0;
  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  bool? isInternetConnected = null;

  @override
  void initState() {
    // AppConsts.userType = "0";
    if (Platform.isAndroid) {
      passwordFocusNode.addListener(
        () {
          if (Platform.isAndroid && passwordFocusNode.hasFocus == false) {
            scrollController.jumpTo(0);
          } else {
            scrollController.jumpTo(0);
          }
        },
      );
    } else {
      passwordFocusNode.addListener(
        () {
          print("Scroll pos : ${scrollController.offset}");
          if (Platform.isIOS && passwordFocusNode.hasFocus == false) {
            scrollController.jumpTo(0);
          } else {
            scrollController.jumpTo(0);
          }
        },
      );
    }

    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) {
      _source = source;
      // print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          isInternetConnected = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.wifi:
          isInternetConnected = _source.values.toList()[0] ? true : false;
          break;
        case ConnectivityResult.none:
        // isInternetConnected = null;
        // break;
        default:
          isInternetConnected = false;
      }
      // 2.
      if (mounted) {
        setState(() {});
      }
      // 3.
    });
  }

  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery.of(context).size.width;
    globalHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 0.34.sh,
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(Hardcoded.white),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome Back',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 35.sp,
                            ),
                      ),
                      SizedBox(
                        height: 0.010.sh,
                      ),
                      Text(
                        'Enter your details below',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              color: Colors.black.withOpacity(0.44),
                            ),
                      ),
                      SizedBox(
                        height: globalHeight * 0.020,
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(left: 3),
                      //   child: // Row(children: [
                      //       Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Container(
                      //         alignment: Alignment.centerRight,
                      //         child: Text(
                      //           "Sign in as $statusValue",
                      //           style: Theme.of(context)
                      //               .textTheme
                      //               .titleLarge!
                      //               .copyWith(
                      //                 fontWeight: FontWeight.w600,
                      //                 fontSize: 15,
                      //                 color: Color(Hardcoded.primaryGreen),
                      //               ),
                      //         ),
                      //       ),
                      //       FlutterSwitch(
                      //         height: 30.0,
                      //         width: 60,
                      //         value: status1,
                      //         activeColor: Color(Hardcoded.primaryGreen),
                      //         onToggle: (val) {
                      //           setState(() {
                      //             status1 = val;
                      //             if (status1 == false) {
                      //               AppConsts.userType = "0";
                      //               statusValue = "Student";
                      //             } else {
                      //               AppConsts.userType = "1";
                      //               statusValue = "Clinician";
                      //             }
                      //           });
                      //           // log("UserType---------${AppConsts.userType}");
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Material(
                        color: Colors.white,
                        child: IOSKeyboardAction(
                          label: 'DONE',
                          focusNode: schoolCodeFocusNode,
                          focusActionType: FocusActionType.done,
                          onTap: () {},
                          child: CommonTextfield(
                            inputText: 'School Code',
                            autoFocus: false,
                            focusNode: schoolCodeFocusNode,
                            hintText: 'Enter school code',
                            textEditingController: schoolCodeController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                              NoSpaceFormatter()
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: globalHeight * 0.015,
                      ),
                      Material(
                        color: Colors.white,
                        child: IOSKeyboardAction(
                          label: 'DONE',
                          focusNode: userNameFocusNode,
                          focusActionType: FocusActionType.done,
                          onTap: () {},
                          child: CommonTextfield(
                            inputText: 'User Name',
                            autoFocus: false,
                            focusNode: userNameFocusNode,
                            hintText: 'Enter user name',
                            textEditingController: userNameController,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: globalHeight * 0.015,
                      ),
                      Material(
                        color: Colors.white,
                        child: IOSKeyboardAction(
                          label: 'DONE',
                          focusNode: passwordFocusNode,
                          focusActionType: FocusActionType.done,
                          onTap: () {},
                          child: CommonTextfield(
                            inputText: 'Password',
                            autoFocus: false,
                            focusNode: passwordFocusNode,
                            hintText: 'Enter password',
                            obscureText: showPassword,
                            inputFormatters: <TextInputFormatter>[
                              NoSpaceFormatter()
                            ],
                            onChanged: (text) {
                              if (text.isEmpty && !showPassword) {
                                showPassword = false;
                              }
                            },
                            sufix: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              child: Icon(
                                !showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: showPassword
                                    ? Colors.grey
                                    : Color(Hardcoded.primaryGreen),
                              ),
                            ),
                            textEditingController: passwordCodeController,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()),
                              );
                              // Navigator.pushNamed(
                              //     context, Routes.forgotUserPasswordScreen);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 7,
                                right: 5,
                              ),
                              child: Text(
                                'Forgot Password?',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color(Hardcoded.primaryGreen),
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: globalHeight * 0.03,
                      ),
                      CommonRoundedLoadingButton(
                        width: globalWidth * 1,
                        title: 'Sign In',
                        textcolor: Color(Hardcoded.white),
                        onTap: () async {
                          if (isInternetConnected!) {
                            if (loginValidation()) {
                              userLoginData();
                              // loginUser();
                            } else {
                              roundedLoadingButtonController.error();
                              Future.delayed(const Duration(seconds: 1), () {
                                roundedLoadingButtonController.reset();
                              });
                            }
                          } else {
                            roundedLoadingButtonController.error();
                            Future.delayed(const Duration(seconds: 1), () {
                              roundedLoadingButtonController.reset();
                              AppHelper.buildErrorSnackbar(
                                  context, 'Network unavailable!');
                            });
                          }
                        },
                        color: Color(Hardcoded.primaryGreen),
                        controller: roundedLoadingButtonController,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: globalHeight * 0.014,
                          // bottom:  globalHeight * 0.02,
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            AppConsts.strBuildVersion,
                            style: TextStyle(
                                color: Color(Hardcoded.primaryGreen),
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///User login API call
  UserDatRepo userDatRepo = UserDatRepo();

  Future<void> userLoginData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    return userDatRepo.userLogin(
        schoolCodeController.text,
        userNameController.text,
        passwordCodeController.text,
        AppConsts.userType, (UserLoginResponseModel userLoginResponseModel) {
      final UserLoginResponseHive userLoginResponseHiveData =
          UserLoginResponseHive()
            ..accessToken = userLoginResponseModel.data!.accessToken
            ..loggedUserEmail = userLoginResponseModel.data!.loggedUserEmail
            ..loggedUserFirstName =
                userLoginResponseModel.data!.loggedUserFirstName
            ..loggedUserId = userLoginResponseModel.data!.loggedUserId
            ..loggedUserLastName =
                userLoginResponseModel.data!.loggedUserLastName
            ..loggedUserMiddleName =
                userLoginResponseModel.data!.loggedUserMiddleName
            ..loggedUserProfile = userLoginResponseModel.data!.loggedUserProfile
            ..loggedUserRankTitle =
                userLoginResponseModel.data!.loggedUserRankTitle
            ..loggedUserSchoolName =
                userLoginResponseModel.data!.loggedUserSchoolName
            ..loggedUserSchoolType =
                userLoginResponseModel.data!.loggedUserSchoolType
            ..loggedUserloginhistoryId =
                userLoginResponseModel.data!.loggedUserloginhistoryId
            ..loggedUserType = userLoginResponseModel.data!.loggedUserType
            ..loggedUserRole = userLoginResponseModel.data!.loggedUserRole
            ..loggedUserRoleType = userLoginResponseModel.data!.loggedUserRoleType;

      var box = Boxes.getUserInfo();
      box.put(Hardcoded.hiveBoxKey, userLoginResponseHiveData);
      store.dispatch(SetHiveDataToStateAction());

      ///Save Login Instance to sharedPReferences
      sharedPreferences.setBool('isUserLogin', true);

      roundedLoadingButtonController.success();
      Future.delayed(Duration(seconds: 1), () {
        roundedLoadingButtonController.reset();
        Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
            arguments:
                BodySwitcherData(initialPage: Bottom_navigation_control.home));
      });
    }, () {
      roundedLoadingButtonController.error();
      Future.delayed(Duration(seconds: 1), () {
        roundedLoadingButtonController.reset();
      });
    }, context);
  }

  bool loginValidation() {
    const Pattern password =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*<>~]).{6,}$';
    final RegExp passwordRegex = RegExp(password.toString());

    if (schoolCodeController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, 'Please insert school code');
      return false;
    }

    if (userNameController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, 'Please insert username');
      return false;
    }

    if (userNameController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, 'Please insert username');
      return false;
    }

    return true;
  }
}

class Boxes {
  //method to get userinfo
  ///
  static Box<UserLoginResponseHive> getUserInfo() =>
      Hive.box<UserLoginResponseHive>(Hardcoded.hiveBoxKey);
}

class NoSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Check if the new value contains any spaces
    if (newValue.text.contains(' ')) {
      // If it does, return the old value
      return oldValue;
    }
    // Otherwise, return the new value
    return newValue;
  }
}
