import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/eaxpansion_component.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/daily_weekly/models/save_daily_weekly_request.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreateMasteryEvaluationEvalution extends StatefulWidget {
  final RotationListStudentJournal rotationList;
  final UserLoginResponse user;
  final DailyWeeklyEval? Viewtype;

  final String rotationID;
  final String rotationname;

  const CreateMasteryEvaluationEvalution(
      {required this.rotationList,
      required this.user,
      this.Viewtype,
      required this.rotationID,
      required this.rotationname});

  @override
  State<CreateMasteryEvaluationEvalution> createState() =>
      _CreateMasteryEvaluationEvalutionState();
}

class _CreateMasteryEvaluationEvalutionState
    extends State<CreateMasteryEvaluationEvalution> {
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
  void initState() {
    setValue();
    super.initState();
  }

  void setValue() async {
    switch (widget.Viewtype) {
      case DailyWeeklyEval.add:
        List<String> temp = [];
        for (var cnt in widget.rotationList.data) {
          temp.add(cnt.title!);
        }
        setState(() {
          rotations = temp;
          selectedRotation = widget.rotationname;
        });
        rotations.remove('All');
        selectedRotationId = widget
            .rotationList
            .data[widget.rotationList.data
                .indexWhere((element) => element.title == selectedRotation)]
            .rotationId;

        //selectedRotationId = widget.rotationList.data[0].rotationId;
        setState(() {
          isDataLoading = false;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Create Daily/Weekly Evaluation';
    return Scaffold(
      appBar: CommonAppBar(
        titles: Text(title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                )),
        searchEnabeled: false,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: CommonRoundedLoadingButton(
          controller: save,
          width: globalWidth * 0.9,
          textcolor: Color(Hardcoded.white),
          onTap: () async {
            Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
            if (widget.Viewtype == DailyWeeklyEval.add) {
              if (validateDailyjournal()) {
                SaveDailyWeeklyEvalRequest saveDailyWeeklyEvalRequest =
                    SaveDailyWeeklyEvalRequest(
                  userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                  rotationId: selectedRotationId!,
                  EvaluationDate: journalDate,
                  MobileNumber: preceptorPhone.text,
                  SignatureName: '',
                  accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,
                );
                /* final DataService dataService = locator();
                final DataResponseModel dataResponseModel = await dataService
                    .saveStudentJournal(saveDailyWeeklyEvalRequest);
                if (dataResponseModel.success) {
                  Future.delayed(const Duration(seconds: 1), () {})
                      .then((value) {
                    AppHelper.buildErrorSnackbar(
                        context, dataResponseModel.message);
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pop(context);
                    });
                  });
                } else {
                  Future.delayed(const Duration(seconds: 1), () {}).then(
                      (value) => AppHelper.buildErrorSnackbar(context,
                          dataResponseModel.errorResponse.errorMessage));
                }*/
              }
            }
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
                            enabled:
                                widget.Viewtype != DailyJournalViewType.view,
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
                                    "from Date cannot be greater than to Date");
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
                                      "from Date cannot be greater than to Date");
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
                  OnSelection: (String value) {
                    setState(() {
                      selectedRotation = value;
                      selectedRotationId = widget
                          .rotationList
                          .data[widget.rotationList.data.indexWhere(
                              (element) => element.title == selectedRotation)]
                          .rotationId;
                      ;
                    });
                  },
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

  bool validateDailyjournal() {
    if (selectedRotation == null) {
      AppHelper.buildErrorSnackbar(context, "Please select Rotation");
      return false;
    }
    if (journalDateText.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select journal Date");
      return false;
    }
    /*if (selectedHospitalUnit == null) {
      AppHelper.buildErrorSnackbar(context, "Please select hospital site unit");
      return false;
    }*/
    if (preceptorPhone.text.length < 9) {
      AppHelper.buildErrorSnackbar(
          context, "Student journal entry must contain 50 characters");
      return false;
    }
    return true;
  }
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
