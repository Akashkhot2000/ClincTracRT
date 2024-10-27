import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/login_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreebState();
}

class _ForgotPasswordScreebState extends State<ForgotPasswordScreen> {
  ///controllers
  TextEditingController schoolCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  RoundedLoadingButtonController roundedLoadingButtonController =
      RoundedLoadingButtonController();

  final schoolCodeFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Forgot Password?'),
      backgroundColor: Color(Hardcoded.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/forgot_pwd_main.svg',
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "New password will be shared to your registered email address",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xFF868998)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Material(
                color: Colors.white,
                child: IOSKeyboardAction(
                  label: 'DONE',
                  focusNode: schoolCodeFocusNode,
                  focusActionType: FocusActionType.done,
                  onTap: () {},
                  child: CommonTextfield(
                    inputText: "School Code",
                    autoFocus: false,
                    focusNode: schoolCodeFocusNode,
                    hintText: 'Enter school code',
                    textEditingController: schoolCodeController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      NoSpaceFormatter()
                    ],
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
                  focusNode: emailFocusNode,
                  focusActionType: FocusActionType.done,
                  onTap: () {},
                  child: CommonTextfield(
                    inputText: "Email",
                    autoFocus: false,
                    focusNode: emailFocusNode,
                    hintText: 'Enter email',
                    textEditingController: emailController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              CommonRoundedLoadingButton(
                width: globalWidth * 1,
                title: 'Submit',
                textcolor: Color(Hardcoded.white),
                onTap: () async {
                    if (forgortPwdValidations()) {
                      forgotPwdApiCall();
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
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(Hardcoded.primaryGreen)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> forgotPwdApiCall() async {
    try {
      final DataService dataService = locator();
      final DataResponseModel dataResponseModel = await dataService.forgotPWD(
        schoolCodeController.text,
        emailController.text,
      );

      if (dataResponseModel.success) {
        roundedLoadingButtonController.success();
        Future.delayed(const Duration(seconds: 1), () {
          roundedLoadingButtonController.reset();
          AppHelper.buildErrorSnackbar(context, dataResponseModel.message);

          Navigator.pop(context);
        });
      } else {
        roundedLoadingButtonController.error();
        Future.delayed(const Duration(seconds: 1), () {
          roundedLoadingButtonController.reset();
          AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
        });
      }
    } catch (e) {
      roundedLoadingButtonController.error();
      Future.delayed(const Duration(seconds: 1), () {
        roundedLoadingButtonController.reset();
        AppHelper.buildErrorSnackbar(context, e.toString());
      });
    }
  }

  bool forgortPwdValidations() {
    Pattern emailPattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    final RegExp emailRegExp = RegExp(emailPattern.toString());

    if (schoolCodeController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter school code");
      return false;
    }

    if (emailController.text.toLowerCase().isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter email");
      return false;
    }
    log("${emailRegExp.hasMatch(emailController.text.toLowerCase())} ${emailController.text}jdkfkfk");
    if (!emailRegExp.hasMatch(emailController.text.toLowerCase())) {
      AppHelper.buildErrorSnackbar(context, "Please enter correct email");
      return false;
    }

    return true;
  }
}
