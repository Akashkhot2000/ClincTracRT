// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

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
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBottomScreen extends StatefulWidget {
  const LoginBottomScreen({super.key});

  @override
  State<LoginBottomScreen> createState() => _LoginBottomScreenState();
}

class _LoginBottomScreenState extends State<LoginBottomScreen> {
  ///controllers
  TextEditingController schoolCodeController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordCodeController = TextEditingController();
  ScrollController scrollController = ScrollController();

  //buttonController

  RoundedLoadingButtonController roundedLoadingButtonController =
      RoundedLoadingButtonController();

  bool showPassword = true;

  final schoolCodeFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
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
          if (Platform.isIOS && passwordFocusNode.hasFocus == false
              // && schoolCodeFocusNode.hasFocus == true ||
              // passwordFocusNode.hasFocus == true ||
              // userNameFocusNode.hasFocus == true
              ) {
            scrollController.jumpTo(0);
            //if ( schoolCodeFocusNode.hasFocus == true
            //     // passwordFocusNode.hasFocus == true ||
            //     // userNameFocusNode.hasFocus == true
            // ) {
            // scrollController.jumpTo(155.54082);}else if(userNameFocusNode.hasFocus == true){
            //   scrollController.jumpTo(255.54082);
            // }else if(passwordFocusNode.hasFocus == true){
            //   scrollController.jumpTo(355.54082);
            // }
          } else {
            scrollController.jumpTo(0);
          }
        },
      );
      /*phoneNoFocusNode.addListener(() {
        if (Platform.isIOS && phoneNoFocusNode.hasFocus == true) {
          scrollController.jumpTo(180.54082);
        } else {
          scrollController.jumpTo(0);
        }
      });*/
    }
  }

  // Pattern password = '/^[a-zA-Z0-9]+([a-zA-Z0-9](_|-| )[a-zA-Z0-9])*[a-zA-Z0-9]+$/';
  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery.of(context).size.width;
    globalHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: globalHeight * 0.35,
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
                              fontSize: 35,
                            ),
                      ),
                      SizedBox(
                        height: globalHeight * 0.015,
                      ),
                      Text(
                        'Enter your details below',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.44),
                            ),
                      ),
                      SizedBox(
                        height: globalHeight * 0.025,
                      ),
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
                            // inputFormatters: <TextInputFormatter>[
                            //   // NoSpaceFormatter(),
                            //   FilteringTextInputFormatter.allow(
                            //       RegExp('[a-zA-Z0-9,/"\'"-#:.-@]')),
                            // ],
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
                              Navigator.pushNamed(
                                  context, Routes.forgotPasswordScreen);
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
                          if (loginValidation()) {
                            userLoginData();
                            // loginUser();
                          } else {
                            roundedLoadingButtonController.error();
                            Future.delayed(const Duration(seconds: 1), () {
                              roundedLoadingButtonController.reset();
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
            ],
          ),
        ],
      ),
    );
  }

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
      // setState(() {
      //   box.get(Hardcoded.hiveBoxKey)!.loggedUserId = userLoginResponse.data.loggedUserId;
      //   box.get(Hardcoded.hiveBoxKey)!.accessToken = userLoginResponse.data.accessToken;
      // });
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
    },
            (context) {
          roundedLoadingButtonController.error();
          Future.delayed(Duration(seconds: 1), () {
            roundedLoadingButtonController.reset();
            // AppHelper.buildErrorSnackbar(context, "Invalid login details");
          });},
        context
    );
  }

  // Future<void> loginUser() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //
  //   // if (loginValidation()) {
  //   try {
  //     final DataService dataService = locator();
  //
  //     /// Student login
  //     final DataResponseModel dataResponseModel = await dataService.login(
  //       schoolCodeController.text,
  //       userNameController.text,
  //       passwordCodeController.text,
  //     );
  //     /// User base login
  //     // final DataResponseModel dataResponseModel =
  //     //     await dataService.userBaseLogin(
  //     //         schoolCodeController.text,
  //     //         userNameController.text,
  //     //         passwordCodeController.text,
  //     //         AppConsts.userType);
  //
  //     if (dataResponseModel.success == false) {
  //       roundedLoadingButtonController.error();
  //       Future.delayed(Duration(seconds: 1), () {
  //         roundedLoadingButtonController.reset();
  //         AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
  //       });
  //       // AppHelper.log("Error1 ${dataResponseModel.errorResponse}");
  //     } else {
  //       UserLoginResponse userLoginResponse =
  //           UserLoginResponse.fromJson(dataResponseModel.data);
  //
  //       // AppHelper.log("$userLoginResponse============");
  //
  //       ///Store login instance in [Hive] so we can use it to find isLoggedIn instance
  //
  //       final UserLoginResponseHive userLoginResponseHiveData =
  //           UserLoginResponseHive()
  //             ..accessToken = userLoginResponse.data.accessToken
  //             ..loggedUserEmail = userLoginResponse.data.loggedUserEmail
  //             ..loggedUserFirstName = userLoginResponse.data.loggedUserFirstName
  //             ..loggedUserId = userLoginResponse.data.loggedUserId
  //             ..loggedUserLastName = userLoginResponse.data.loggedUserLastName
  //             ..loggedUserMiddleName =
  //                 userLoginResponse.data.loggedUserMiddleName
  //             ..loggedUserProfile = userLoginResponse.data.loggedUserProfile
  //             ..loggedUserRankTitle = userLoginResponse.data.loggedUserRankTitle
  //             ..loggedUserSchoolName =
  //                 userLoginResponse.data.loggedUserSchoolName
  //             ..loggedUserSchoolType =
  //                 userLoginResponse.data.loggedUserSchoolType
  //             ..loggedUserloginhistoryId =
  //                 userLoginResponse.data.loggedUserloginhistoryId
  //             ..loggedUserType = userLoginResponse.data.loggedUserType
  //             ..loggedUserRole = userLoginResponse.data.loggedUserRole;
  //
  //       var box = Boxes.getUserInfo();
  //       box.put(Hardcoded.hiveBoxKey, userLoginResponseHiveData);
  //       // setState(() {
  //       //   box.get(Hardcoded.hiveBoxKey)!.loggedUserId = userLoginResponse.data.loggedUserId;
  //       //   box.get(Hardcoded.hiveBoxKey)!.accessToken = userLoginResponse.data.accessToken;
  //       // });
  //       store.dispatch(SetHiveDataToStateAction());
  //
  //       ///Save Login Instance to sharedPReferences
  //       sharedPreferences.setBool('isUserLogin', true);
  //
  //       roundedLoadingButtonController.success();
  //       Future.delayed(Duration(seconds: 1), () {
  //         roundedLoadingButtonController.reset();
  //         Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
  //             arguments: BodySwitcherData(
  //                 initialPage: Bottom_navigation_control.home));
  //       });
  //     }
  //   } catch (e) {
  //     roundedLoadingButtonController.error();
  //     Future.delayed(Duration(seconds: 1), () {
  //       roundedLoadingButtonController.reset();
  //       AppHelper.buildErrorSnackbar(
  //         context,
  //         e.toString(),
  //       );
  //     });
  //   }
  //   // } else {
  //   //   roundedLoadingButtonController.error();
  //   //   Future.delayed(Duration(seconds: 1), () {
  //   //     roundedLoadingButtonController.reset();
  //   //   });
  //   // }
  // }

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

    // if (!passwordRegex.hasMatch(passwordCodeController.text)) {
    //   AppHelper.buildErrorSnackbar(context,
    //       'Invalid credentials',
    //       durationMultiplier: 3);
    //   return false;
    // }

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
