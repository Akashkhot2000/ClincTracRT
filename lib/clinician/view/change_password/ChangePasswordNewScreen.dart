import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
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
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ChangeUserPasswordScreen extends StatefulWidget {
  const ChangeUserPasswordScreen({super.key});

  @override
  State<ChangeUserPasswordScreen> createState() =>
      _ChangeUserPasswordScreenState();
}

class _ChangeUserPasswordScreenState extends State<ChangeUserPasswordScreen> {
  ///controllers
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  RoundedLoadingButtonController submit = RoundedLoadingButtonController();
  bool isOldObs = true;
  bool isNewObs = true;
  bool isConfirmObs = true;

  final oldPassFocusNode = FocusNode();
  final newPassFocusNode = FocusNode();
  final confirmPassFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      closeOnBackButton: true,
      overlayWidget: Center(
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(50.0),
              child: CircularProgressIndicator(),
            )),
      ),
      child: Scaffold(
        appBar: CommonAppBar(
          title: 'Change Password',
        ),
        backgroundColor: Color(Hardcoded.white),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/images/change_pass.svg',
                  height: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Enter your old password and reset your new password ",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xFF868998)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Material(
                  color: Colors.white,
                  child: IOSKeyboardAction(
                    label: 'DONE',
                    focusNode: oldPassFocusNode,
                    focusActionType: FocusActionType.done,
                    onTap: () {},
                    child: CommonTextfield(
                      inputText: "Old Password",
                      autoFocus: false,
                      focusNode: oldPassFocusNode,
                      hintText: 'Enter old password',
                      textEditingController: oldPassword,
                      obscureText: isOldObs,
                      sufix: GestureDetector(
                        onTap: () {
                          setState(() {
                            isOldObs = !isOldObs;
                          });
                        },
                        child: Icon(
                          !isOldObs ? Icons.visibility : Icons.visibility_off,
                          color: isOldObs
                              ? Colors.grey
                              : Color(Hardcoded.primaryGreen),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Material(
                  color: Colors.white,
                  child: IOSKeyboardAction(
                    label: 'DONE',
                    focusNode: newPassFocusNode,
                    focusActionType: FocusActionType.done,
                    onTap: () {},
                    child: CommonTextfield(
                      inputText: "New Password",
                      autoFocus: false,
                      focusNode: newPassFocusNode,
                      hintText: 'Enter new password',
                      textEditingController: newPassword,
                      obscureText: isNewObs,
                      sufix: GestureDetector(
                        onTap: () {
                          setState(() {
                            isNewObs = !isNewObs;
                          });
                        },
                        child: Icon(
                          !isNewObs ? Icons.visibility : Icons.visibility_off,
                          color: isNewObs
                              ? Colors.grey
                              : Color(Hardcoded.primaryGreen),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Material(
                  color: Colors.white,
                  child: IOSKeyboardAction(
                    label: 'DONE',
                    focusNode: confirmPassFocusNode,
                    focusActionType: FocusActionType.done,
                    onTap: () {},
                    child: CommonTextfield(
                      inputText: "Confirm Password",
                      autoFocus: false,
                      focusNode: confirmPassFocusNode,
                      hintText: 'Enter confirm password',
                      textEditingController: confirmPassword,
                      obscureText: isConfirmObs,
                      sufix: GestureDetector(
                        onTap: () {
                          setState(() {
                            isConfirmObs = !isConfirmObs;
                          });
                        },
                        child: Icon(
                          !isConfirmObs
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: isConfirmObs
                              ? Colors.grey
                              : Color(Hardcoded.primaryGreen),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                // RoundedButton(
                //   showBorder: true,
                //   width: globalWidth * 0.4,
                //   title: 'Submit',
                //   textcolor: Color(Hardcoded.primaryGreen),
                //   onTap: () {
                //     if (changePasswordValidation()) {
                //       ChangePasswordApiCall();
                //     }
                //   },
                //   color: Color(Hardcoded.white),
                // ),
                CommonRoundedLoadingButton(
                  controller: submit,
                  width: globalWidth * 1,
                  title: "Submit",
                  textcolor: Color(Hardcoded.white),
                  onTap: () {
                    if (changePasswordValidation()) {
                      ChangePasswordApiCall();
                    }
                    submit.reset();
                  },
                  color: Color(Hardcoded.primaryGreen),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void ChangePasswordApiCall() async {
    UserDatRepo userDatRepo = new UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    userDatRepo.changeUserPassword(
        box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        box.get(Hardcoded.hiveBoxKey)!.loggedUserType == "Student" ? "0" : "1",
        oldPassword.text,
        newPassword.text,
        confirmPassword.text,
        store.state.userLoginResponse.data.accessToken, () {
      oldPassword.text = '';
      newPassword.text = '';
      confirmPassword.text = '';
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(
          context,
          Routes.bodySwitcher,
          arguments:
          BodySwitcherData(initialPage: Bottom_navigation_control.home),
        );
      });
    }, context);
  }

  bool changePasswordValidation() {
    const Pattern passwordPattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';

    final RegExp passwordRegex = RegExp(passwordPattern.toString());

    if (oldPassword.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter old password");
      return false;
    }

    if (newPassword.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter new password");
      return false;
    }
    if (confirmPassword.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter confirm password");
      return false;
    }
    // if (!passwordRegex.hasMatch(oldPassword.text)) {
    //   AppHelper.buildErrorSnackbar(context, "Invalid old password");
    //   return false;
    // }

    if (!passwordRegex.hasMatch(newPassword.text)) {
      AppHelper.buildErrorSnackbar(context,
          "New password must have 6 character,1 uppercase letter, 1 lowercase letter, 1 number and 1 special character");
      return false;
    }
    if (newPassword.text.contains(' ')) {
      AppHelper.buildErrorSnackbar(context,
          "New password must have 6 character,1 uppercase letter, 1 lowercase letter, 1 number and 1 special character");
      return false;
    }
    // if (oldPassword.text == newPassword.text) {
    //   AppHelper.buildErrorSnackbar(context, "Invalid old password");
    //   return false;
    // }
    if (confirmPassword.text != newPassword.text) {
      AppHelper.buildErrorSnackbar(
          context, "New password and Confirm password doesn't match");
      return false;
    }

    return true;
  }
}
