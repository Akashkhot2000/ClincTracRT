import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/eaxpansion_component.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/view/daily_weekly/models/daily_weekly_response.dart';
import 'package:clinicaltrac/view/daily_weekly/view/add_dailyweekly_screen.dart';
import 'package:clinicaltrac/view/mastery_evaluation/view/create_mastery_evalution.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../helper/app_helper.dart';

class CreateExpectionAttendanceScreen extends StatefulWidget {
  const CreateExpectionAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<CreateExpectionAttendanceScreen> createState() =>
      _CreateExpectionAttendanceScreenState();
}

class _CreateExpectionAttendanceScreenState
    extends State<CreateExpectionAttendanceScreen> {
  bool isDataLoading = false;
  List<String> rotations = [];
  String selectedRotation = '';
  String? selectedRotationId;

  final journalDateFocusNode = FocusNode();
  final preceptorPhoneFocusNode = FocusNode();
  final hospitalSiteIdFocusNode = FocusNode();
  final studentJournalEntryFocusNode = FocusNode();
  final clinicianResponseFocusNode = FocusNode();
  final schoolResponseFocusNode = FocusNode();

  TextEditingController journalDateText = TextEditingController();
  TextEditingController preceptorPhone = TextEditingController();
  TextEditingController hospitalSiteId = TextEditingController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();
  DateTime journalDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        titles: Text(
          "Create Exception",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
        ),
        searchEnabeled: false,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: CommonRoundedLoadingButton(
          controller: save,
          width: globalWidth * 0.9,
          textcolor: Color(Hardcoded.white),
          onTap: () async {
            // if (widget.Viewtype == DailyWeeklyEval.add) {
            //     // SaveDailyWeeklyEvalRequest saveDailyWeeklyEvalRequest =
            //     // SaveDailyWeeklyEvalRequest(
            //     //   userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,,
            //     //   rotationId: selectedRotationId!,
            //     //   EvaluationDate: journalDate,
            //     //   MobileNumber: preceptorPhone.text,
            //     //   SignatureName: '',
            //     //   accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,,
            //     // );
            //     /* final DataService dataService = locator();
            //     final DataResponseModel dataResponseModel = await dataService
            //         .saveStudentJournal(saveDailyWeeklyEvalRequest);
            //     if (dataResponseModel.success) {
            //       Future.delayed(const Duration(seconds: 1), () {})
            //           .then((value) {
            //         AppHelper.buildErrorSnackbar(
            //             context, dataResponseModel.message);
            //         Future.delayed(const Duration(seconds: 1), () {
            //           Navigator.pop(context);
            //         });
            //       });
            //     } else {
            //       Future.delayed(const Duration(seconds: 1), () {}).then(
            //           (value) => AppHelper.buildErrorSnackbar(context,
            //               dataResponseModel.errorResponse.errorMessage));
            //     }*/
            //   }
          },
          title: 'Save',
          color: Color(Hardcoded.primaryGreen),
        ),
      ),
      backgroundColor: Color(Hardcoded.white),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Visibility(
            visible: !isDataLoading,
            replacement: common_loader(),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    GestureDetector(
                      child: Material(
                        color: Colors.white,
                        child: IOSKeyboardAction(
                          label: 'DONE',
                          focusNode: journalDateFocusNode,
                          focusActionType: FocusActionType.done,
                          onTap: () {},
                          child: CommonTextfield(
                            autoFocus: false,
                            focusNode: journalDateFocusNode,
                            hintText: 'Journal date',
                            textEditingController: journalDateText,
                            readOnly: true,
                            onTap: () async {
                              var results = await showCalendarDatePicker2Dialog(
                                context: context,
                                value: [journalDate],
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                        lastDate: DateTime.now(),
                                        selectedDayHighlightColor:
                                            Color(Hardcoded.primaryGreen)),
                                dialogSize: const Size(325, 400),
                                borderRadius: BorderRadius.circular(15),
                              );
                              if (results!.first!.compareTo(DateTime.now()) <
                                      0 ||
                                  results.first!.compareTo(DateTime.now()) ==
                                      0) {
                                setState(() {
                                  journalDate = results.first!;
                                  journalDateText.text =
                                      DateFormat('MM-dd-yyyy')
                                          .format(journalDate);
                                  log(journalDateText.text);
                                });
                              } else {
                                AppHelper.buildErrorSnackbar(context,
                                    "From Date cannot be greater than to Date");
                              }
                            },
                            sufix: GestureDetector(
                              onTap: () async {
                                var results =
                                    await showCalendarDatePicker2Dialog(
                                  context: context,
                                  value: [journalDate],
                                  config:
                                      CalendarDatePicker2WithActionButtonsConfig(
                                          lastDate: DateTime.now(),
                                          selectedDayHighlightColor:
                                              Color(Hardcoded.primaryGreen)),
                                  dialogSize: const Size(325, 400),
                                  borderRadius: BorderRadius.circular(15),
                                );
                                if (results!.first!.compareTo(DateTime.now()) <
                                        0 ||
                                    results.first!.compareTo(DateTime.now()) ==
                                        0) {
                                  setState(() {
                                    journalDate = results.first!;
                                    journalDateText.text =
                                        DateFormat('MM-dd-yyyy')
                                            .format(journalDate);
                                  });
                                } else {
                                  AppHelper.buildErrorSnackbar(context,
                                      "From Date cannot be greater than to Date");
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(Hardcoded.primaryGreen),
                                child: SvgPicture.asset(
                                  'assets/images/calendar.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.white,
                      child: IOSKeyboardAction(
                        label: 'DONE',
                        focusNode: preceptorPhoneFocusNode,
                        focusActionType: FocusActionType.done,
                        onTap: () {},
                        child: CommonTextfield(
                          autoFocus: false,
                          overflow: TextOverflow.ellipsis,
                          focusNode: preceptorPhoneFocusNode,
                          hintText: "Preceptor phone number",
                          enabled: true,
                          textEditingController: preceptorPhone,
                          keyboardType: TextInputType.phone,
                          maxlength: 10,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            NoSpaceFormatter()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expansion(
                  OnSelection: (String value) {},
                  bodyList: rotations,
                  trailIcon: "",
                  hintText: selectedRotation!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
