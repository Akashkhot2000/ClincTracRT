import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class EmailSendBottomSheet extends StatefulWidget {
  EmailSendBottomSheet(
      {Key? key,
      required this.userId,
      required this.accessToken,
      required this.evaluationId,
      required this.rotationId,
      required this.schoolTopicId,
      required this.evaluationType,
      required this.preceptorId,
      required this.preceptorNum,
      required this.isSendEmail,
      required this.loggedUserEmailId,
      // required this.pullToRefresh
      })
      : super(key: key);
  final userId;
  final accessToken;
  final evaluationId;
  final rotationId;
  final schoolTopicId;
  final evaluationType;
  final preceptorId;
  final preceptorNum;
  final isSendEmail;
  final String loggedUserEmailId;

  // Future<void> pullToRefresh1;
  // Function pullToRefresh;

  @override
  State<EmailSendBottomSheet> createState() => _EmailSendBottomSheetState();
}

class _EmailSendBottomSheetState extends State<EmailSendBottomSheet> {
  // TextEditingController phoneNmber = MaskedTextController(mask: '000-000-0000');
  TextEditingController emailController = TextEditingController();
  RoundedLoadingButtonController notify = RoundedLoadingButtonController();

  @override
  void initState() {
    emailController.text = widget.loggedUserEmailId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(20),
        // color: Colors.white,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30),
              topLeft: Radius.circular(30),
            )),
        height: 286,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Send URL to Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/images/close_modal.svg',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 23,
            ),
            CommonTextfield(
              inputText: "Preceptor Email",
              autoFocus: false,
              // focusNode: fromDateFocusNode,
              hintText: 'Enter preceptor email',
              textEditingController: emailController,
              readOnly: false,
              keyboardType: TextInputType.emailAddress,

              // validation: (text) {
              //   if (text == null || text.isEmpty) {
              //     return '*Required';
              //   }
              //   return null;
              // },
              // inputFormatters: [
              //   LengthLimitingTextInputFormatter(12),
              // ],
            ),
            SizedBox(
              height: 35,
            ),
            CommonRoundedLoadingButton(
              controller: notify,
              title: "Send",
              textcolor: Color(Hardcoded.white),
              color: Color(Hardcoded.primaryGreen),
              width: MediaQuery.of(context).size.width - 40,
              onTap: () async {
                Pattern emailPattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
                final RegExp emailRegExp = RegExp(emailPattern.toString());
                if (emailController.text.isEmpty || !emailRegExp.hasMatch(emailController.text.toLowerCase())) {
                   Navigator.pop(context);
                  emailController.text.isEmpty
                      ? AppHelper.buildErrorSnackbar(
                          context, "Please enter email")
                      : AppHelper.buildErrorSnackbar(
                          context, "Please enter valid email");
                  return false;
                } else {
                  final DataService dataService = locator();
                  CommonCopyUrlAndSendEmailRequest request =
                      CommonCopyUrlAndSendEmailRequest(
                    accessToken: widget.accessToken,
                    userId: widget.userId,
                    evaluationId: widget.evaluationId,
                        rotationId: widget.rotationId,
                    preceptorId: widget.preceptorId,
                    schoolTopicId: widget.schoolTopicId,
                    email: emailController.text,
                    isSendEmail: widget.isSendEmail,
                    evaluationType: widget.evaluationType,
                    preceptorNum: widget.preceptorNum,
                  );
                  final DataResponseModel dataResponseModel =
                      await dataService.copyAndEmailSendEval(request);
                  // log("${dataResponseModel.success}");
                  if (dataResponseModel.success) {
                    notify.success();
                    Future.delayed(const Duration(seconds: 1), () async {
                      Navigator.pop(context);
                      // await widget.pullToRefresh();
                      AppHelper.buildErrorSnackbar(
                          context, "Email sent successfully");
                    });
                  } else {
                    notify.error();
                    Future.delayed(const Duration(seconds: 1), () {
                      notify.reset();
                    });
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
