import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_detail_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/student_procedure_list/student_procedure_list_responce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

class CreateProcedureCountScreen extends StatefulWidget {
   CreateProcedureCountScreen({
    Key? key,
    this.studentProcedureListData,
    this.procedureCountData,
    this.procedureCountDetail,
    required this.procedureCount,
    required this.rotationId,
     this.checkOffId,
     this.isFromCheckoff,
  }) : super(key: key);
  final StudentProcedureListData? studentProcedureListData;
  final ProcedureCount? procedureCountData;
  final ProcedureCountDetail? procedureCountDetail;
  final ProcedureCountStatus procedureCount;
  final String rotationId;
  final String? checkOffId;
   bool? isFromCheckoff;

  @override
  State<CreateProcedureCountScreen> createState() =>
      _CreateProcedureCountScreenState();
}

class _CreateProcedureCountScreenState
    extends State<CreateProcedureCountScreen> {
  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();
  TextEditingController procedureNameController = TextEditingController();
  TextEditingController procedureDateController = TextEditingController();
  TextEditingController assistedController = TextEditingController();
  TextEditingController observedController = TextEditingController();
  TextEditingController performedController = TextEditingController();

  DateTime clockOut = DateTime.now();
  DateTime procedureDate = DateTime.now();

  final procedureNameFocusNode = FocusNode();
  final procedureDateFocusNode = FocusNode();
  final assistedFocusNode = FocusNode();
  final observedFocusNode = FocusNode();
  final performedFocusNode = FocusNode();

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  @override
  void initState() {
    super.initState();
    if (widget.procedureCount == ProcedureCountStatus.add) {
      procedureNameController.text = "${widget.studentProcedureListData!.title} ${"(${widget.studentProcedureListData!.proceCountCode})"}";
    } else {
      procedureNameController.text =
      "${widget.procedureCountDetail!.procedureCountName} ${"(${widget.procedureCountDetail!.procedureCountsCode})"}";
      procedureDateController.text = DateFormat('MM-dd-yyyy')
          .format(widget.procedureCountData!.procedureDate!);
      assistedController.text =
          widget.procedureCountData!.procedurePointsAssist;
      observedController.text =
          widget.procedureCountData!.procedurePointsObserve;
      performedController.text =
          widget.procedureCountData!.procedurePointsPerform;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          title: widget.procedureCount == ProcedureCountStatus.add
              ? 'Create Procedure Count'
              : 'Edit Procedure Count'),
      backgroundColor: Color(Hardcoded.white),
      bottomNavigationBar: BottomAppBar(
        height: globalHeight * 0.085,
        // color: Colors.amber,
        elevation: 0,
        child: CommonRoundedLoadingButton(
          controller: save,
          width: globalWidth * 0.9,
          title: widget.procedureCount == ProcedureCountStatus.add
              ? 'Create Procedure Count'
              : 'Save Procedure Count',
          textcolor: Colors.white,
          onTap: () async {
            Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
            final DataService dataService = locator();
            late DataResponseModel dataResponseModel;
            if (widget.procedureCount == ProcedureCountStatus.add) {
              if (validationsForAdd()) {
                DateTime procedureDate = DateFormat("MM-dd-yyyy")
                    .parse(procedureDateController.text);
                String proceduredate =
                    DateFormat("yyyy-MM-dd").format(procedureDate);
                dataResponseModel =
                    await dataService.createStudentProcedureCount(
                   box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                   box.get(Hardcoded.hiveBoxKey)!.accessToken,
                  widget.rotationId,
                  widget.checkOffId.toString(),
                  widget.studentProcedureListData!.pcTopicId,
                  assistedController.text,
                  observedController.text,
                  performedController.text,
                  proceduredate.toString(),
                );
              } else {
                save.error();
                Future.delayed(Duration(seconds: 2), () {
                  save.reset();
                });
              }
            } else if (widget.procedureCount == ProcedureCountStatus.edit) {
              if (validationsForAdd()) {
                DateTime procedureDate = DateFormat("MM-dd-yyyy")
                    .parse(procedureDateController.text);
                String proceduredate =
                    DateFormat("yyyy-MM-dd").format(procedureDate);
                dataResponseModel = await dataService.editStudentProcedureCount(
                   box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                   box.get(Hardcoded.hiveBoxKey)!.accessToken,
                  widget.rotationId,
                  widget.procedureCountData!.procedureCountId,
                  widget.procedureCountDetail!.procedureCountTopicId,
                  assistedController.text,
                  observedController.text,
                  performedController.text,
                  proceduredate.toString(),
                );
              } else {
                save.error();
                Future.delayed(Duration(seconds: 2), () {
                  save.reset();
                });
              }
            }
            if (dataResponseModel.success) {
              save.success();
              if (widget.procedureCount == ProcedureCountStatus.add) {
                Navigator.pop(context);
                common_alert_pop(
                    context,
                    'Successfully created \nProcedure Count.',
                    'assets/images/success_Icon.svg', () {
                  Navigator.pop(context);
                });
                // AppHelper.buildErrorSnackbar(context, 'Procedure count created successfully');
              }
              // else {
              //   AppHelper.buildErrorSnackbar(
              //       context, 'Procedure count updated successfully');
              // }
              Future.delayed(Duration(seconds: 2), () {
                save.reset();
              }).then((value) {
                Navigator.pop(context);
                common_alert_pop(
                    context,
                    'Successfully updated \nProcedure Count.',
                    'assets/images/success_Icon.svg', () {
                  Navigator.pop(context);
                });
              }
                  // Navigator.pop(context);}
                  );
            }
            FocusScope.of(context).unfocus();
          },
          color: Color(Hardcoded.primaryGreen),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextfield(
                      autoFocus: false,
                      readOnly: true,
                      enabled: false,
                      inputText: "Procedure Name",
                      onTap: () async {},
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      hintText: 'Enter procedure name',
                      keyboardType: TextInputType.number,
                      textEditingController: procedureNameController,
                    ),
                    SizedBox(
                      height: globalHeight * 0.013,
                    ),
                    GestureDetector(
                      child: Material(
                        color: Colors.white,
                        child: IOSKeyboardAction(
                          label: 'DONE',
                          focusNode: procedureDateFocusNode,
                          focusActionType: FocusActionType.done,
                          onTap: () {},
                          child: CommonTextfield(
                            inputText: "Procedure Date",
                            iscalenderField: true,
                            autoFocus: false,
                            focusNode: procedureDateFocusNode,
                            hintText: 'Procedure date',
                            textEditingController: procedureDateController,
                            readOnly: true,
                            enabled: true,
                            onTap: () async {
                              var results = await showCalendarDatePicker2Dialog(
                                context: context,
                                value: [procedureDate],
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
                                  procedureDate = results.first!;
                                  procedureDateController.text =
                                      DateFormat('MM-dd-yyyy')
                                          .format(procedureDate);
                                  log(procedureDateController.text);
                                });
                              }
                            },
                            sufix: GestureDetector(
                              onTap: () async {
                                var results =
                                    await showCalendarDatePicker2Dialog(
                                  context: context,
                                  value: [procedureDate],
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
                                    procedureDate = results.first!;
                                    procedureDateController.text =
                                        DateFormat('MM-dd-yyyy')
                                            .format(procedureDate);
                                    log(procedureDateController.text);
                                  });
                                }
                                // else {
                                //   AppHelper.buildErrorSnackbar(context,
                                //       "from Date cannot be greater than to Date");
                                // }
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
                      height: globalHeight * 0.013,
                    ),
                    Material(
                      color: Colors.white,
                      child: IOSKeyboardAction(
                        label: 'DONE',
                        focusNode: assistedFocusNode,
                        focusActionType: FocusActionType.done,
                        onTap: () {},
                        child: CommonTextfield(
                          autoFocus: false,
                          focusNode: assistedFocusNode,
                          inputText: "Assisted",
                          onTap: () async {},
                          hintText: 'Enter assisted',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                          ],
                          textEditingController: assistedController,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.013,
                    ),
                    Material(
                      color: Colors.white,
                      child: IOSKeyboardAction(
                        label: 'DONE',
                        focusNode: observedFocusNode,
                        focusActionType: FocusActionType.done,
                        onTap: () {},
                        child: CommonTextfield(
                          autoFocus: false,
                          focusNode: observedFocusNode,
                          inputText: "Observed",
                          onTap: () async {},
                          hintText: 'Enter observed',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                          ],
                          textEditingController: observedController,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.013,
                    ),
                    Material(
                      color: Colors.white,
                      child: IOSKeyboardAction(
                        label: 'DONE',
                        focusNode: performedFocusNode,
                        focusActionType: FocusActionType.done,
                        onTap: () {},
                        child: CommonTextfield(
                          autoFocus: false,
                          focusNode: performedFocusNode,
                          inputText: "Performed",
                          hintText: 'Enter performed',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(3),
                          ],
                          textEditingController: performedController,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.01,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validationsForAdd() {
    if (procedureDateController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(
          context, "Please select procedure count date");
      return false;
    }

    if (assistedController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter assisted points");
      return false;
    }

    if (observedController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter observed points");
      return false;
    }

    if (performedController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter performed points");
      return false;
    }
    return true;
  }
}
