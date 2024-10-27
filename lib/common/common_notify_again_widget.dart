import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NotifyAgainBottomSheet extends StatefulWidget {
   NotifyAgainBottomSheet({Key? key, required this.userId,
    required this.accessToken,
    required this.listId,
    required this.type,
    required this.phoneNumber, required this.pullToRefresh}) : super(key: key);
  final userId;
  final accessToken;
  final listId;
  final type;
  final String phoneNumber;
  // Future<void> pullToRefresh1;
   Function pullToRefresh;
  @override
  State<NotifyAgainBottomSheet> createState() => _NotifyAgainBottomSheetState();
}

class _NotifyAgainBottomSheetState extends State<NotifyAgainBottomSheet> {
  TextEditingController phoneNmber = MaskedTextController(mask: '000-000-0000');
  RoundedLoadingButtonController notify = RoundedLoadingButtonController();
  @override
  void initState() {
    phoneNmber.text = widget.phoneNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
          padding: EdgeInsets.all(20),
          // color: Colors.white,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              )
          ),
          height: 286,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Resend SMS",
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
                inputText: "Preceptor Phone Number",
                autoFocus: false,
                // focusNode: fromDateFocusNode,
                hintText: '123-567-1323',
                textEditingController: phoneNmber,
                readOnly: false,
                keyboardType: TextInputType.number,

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
                    if (phoneNmber.text.isEmpty ||phoneNmber.text.length < 12) {
                      Navigator.pop(context);
                      phoneNmber.text.isEmpty ?  AppHelper.buildErrorSnackbar(context, "Please enter preceptor phone number"):
                      AppHelper.buildErrorSnackbar(context, "Please enter valid preceptor phone number");
                      return false;
                    } else {
                      final DataService dataService = locator();
                      final DataResponseModel dataResponseModel = await dataService.resendSmsEval(
                        widget.userId,
                        widget.accessToken,
                        widget.listId,
                        widget.type,
                        phoneNmber.text,
                      );
                      // log("${dataResponseModel.success}");
                      if (dataResponseModel.success) {
                        notify.success();
                        Future.delayed(const Duration(seconds: 1), () async {
                          Navigator.pop(context);
                        await  widget.pullToRefresh();
                          AppHelper.buildErrorSnackbar(context, "${dataResponseModel.message}");
                        });
                      } else {
                        notify.error();
                        Future.delayed(const Duration(seconds: 1), () {
                          notify.reset();
                        });
                      }
                    }
                  })
            ],
          )),
    );
  }
}
