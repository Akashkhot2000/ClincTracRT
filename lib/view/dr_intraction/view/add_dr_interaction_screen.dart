import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/eaxpansion_component.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/checkoffs_action/get_rotation_for_eval_action.dart';
import 'package:clinicaltrac/redux/action/dr_interaction/get_clinician_list_action.dart';
import 'package:clinicaltrac/redux/action/dr_interaction/get_dr_rotations_action.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddDrIntractionScreen extends StatefulWidget {
  AddDrIntractionScreen({
    super.key,
    required this.drIntractionAction,
    this.drIntraction,
    required this.clinicianDataList,
    required this.hospitalUnitListResponseDart,
    required this.rotationListStudentJournal,
    required this.rotationForEvalListModel,
    required this.isFromDashboard,
    required this.rotationID,
    required this.interactionDecCount,
    required this.rotationTitle,
    required this.hospitalTitle,
  });

  final DrIntractionAction drIntractionAction;
  final ClinicianDataList clinicianDataList;
  UniDrInteractionList? drIntraction;
  final HospitalUnitListResponseDart hospitalUnitListResponseDart;
  final RotationListStudentJournal rotationListStudentJournal;
  final RotationForEvalListModel rotationForEvalListModel;
  final bool isFromDashboard;
  final String rotationTitle;
  final String hospitalTitle;
  final String rotationID;
  final String interactionDecCount;

  @override
  State<AddDrIntractionScreen> createState() => _AddDrIntractionScreenState();
}

class _AddDrIntractionScreenState extends State<AddDrIntractionScreen> {
  //controller
  TextEditingController interactionDateController = TextEditingController();
  TextEditingController clinicianSignatureController = TextEditingController();
  TextEditingController schoolSignatureController = TextEditingController();
  TextEditingController timeSpentController = TextEditingController();
  TextEditingController pointsAwardedController = TextEditingController();
  TextEditingController studentResponseController = TextEditingController();
  TextEditingController clinicianResponseText = TextEditingController();
  bool clinicianResponse = false;
  TextEditingController schoolResponseText = TextEditingController();
  bool schoolResponse = false;

  ///TextFiled for view
  TextEditingController hospitalSiteUnitController = TextEditingController();
  TextEditingController clinicianNameController = TextEditingController();

  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();

  DateTime interactionDate = DateTime.now();
  DateTime clinicianSignatureDate = DateTime.now();
  DateTime schoolSignatureDate = DateTime.now();

  List<RotationJournalData> rotationJournalList = <RotationJournalData>[];
  RotationJournalData selectedRotationValue = new RotationJournalData();
  List<ClinicianData> clinicianList = <ClinicianData>[];
  ClinicianData selectedClinicianValue = new ClinicianData();
  List<Datum> hospitalSiteUnitList = <Datum>[];

  // List<Datum> allHospitalSiteUnit = <Datum>[];
  Datum selectedhospitalSiteUnitValue = Datum();

  List<String> clincianNameList = [];

  // List<String> hospitalSiteUnitList = [];
  List<String> rotationList = [];

  ///Selected rotation
  String selectedRotation = '';
  String selectedRotationId = '';
  String selectedClinicianId = '';
  String selectedHospitalUnitId = '';
  String selectedClinicalInstructor = '';
  String selectedHospitalSiteUnit = '';

  initiateData() {
    interactionDateController.text =
        DateFormat('MM-dd-yyyy').format(widget.drIntraction!.interactionDate);
    clinicianSignatureController.text =
        widget.drIntraction!.clinicianDate.isNotEmpty
            ? convertDate(widget.drIntraction!.clinicianDate)
            : '';

    schoolSignatureController.text = widget.drIntraction!.schoolDate.isNotEmpty
        ? convertDate(widget.drIntraction!.schoolDate)
        : '';

    clinicianNameController.text = widget.drIntraction!.clinicianFullName;

    timeSpentController.text = widget.drIntraction!.timeSpent;
    pointsAwardedController.text = widget.drIntraction!.pointsAwarded;
    clinicianResponseText.text = widget.drIntraction!.clinicianResponse;
    schoolResponseText.text = widget.drIntraction!.schoolResponse;
    studentResponseController.text = widget.drIntraction!.studentResponse;
    selectedClinicalInstructor = widget.drIntraction!.clinicianFullName;
    selectedClinicianId = widget.drIntraction!.clinicianId;
    selectedHospitalSiteUnit = widget.drIntraction!.hospitalUnitName;
    selectedHospitalUnitId = widget.drIntraction!.hospitalSiteUnitId;
    selectedRotation = widget.drIntraction!.rotationName.isNotEmpty &&
            widget.drIntraction!.hospitalsitesName.isNotEmpty
        ? "${widget.drIntraction!.rotationName} (${widget.drIntraction!.hospitalsitesName})"
        : selectedRotation;
    // selectedRotation = widget.drIntraction!.rotationName;
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  Future<void> getRotationList() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel = await dataService.getRotations(
      box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      box.get(Hardcoded.hiveBoxKey)!.accessToken,
      "false",
    );
    RotationListStudentJournal rotationListJournal =
        RotationListStudentJournal.fromJson(dataResponseModel.data);
    setState(() {
      rotationJournalList = rotationListJournal.data!;
      // allUsedCourseTopicData = courseTopicListModel.data!;
    });
    // log("${dataResponseModel.data}");
  }

  Future<void> getClinicianNameList() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getClinicianList(
      box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      box.get(Hardcoded.hiveBoxKey)!.accessToken,
      selectedRotationId.isEmpty ? widget.rotationID : selectedRotationId,
    );
    ClinicianDataList clinicianDataList =
        ClinicianDataList.fromJson(dataResponseModel.data);
    setState(() {
      clinicianList = clinicianDataList.data!;
      // allUsedCourseTopicData = courseTopicListModel.data!;
    });
    // log("${dataResponseModel.data}");
  }

  @override
  void initState() {
    store.dispatch(GetClinicianListAction(
        rotationId: selectedRotationId.isEmpty
            ? widget.rotationID
            : selectedRotationId));
    setState(() {
      if (widget.drIntractionAction != DrIntractionAction.add) {
        initiateData();
        store.dispatch(GetClinicianListAction(
          rotationId: selectedRotationId.isEmpty
              ? widget.rotationID
              : selectedRotationId,
        ));
      } else {
        setState(() {
          // store.dispatch(GetRotationForEvalListAction(isAdvanceCheckoff: "false"));
          store.dispatch(GetClinicianListAction(
              rotationId: selectedRotationId.isEmpty
                  ? widget.rotationID
                  : selectedRotationId));
          getClinicianNameList();
          getRotationList();
          if (widget.drIntractionAction == DrIntractionAction.edit) {
            selectedHospitalSiteUnit = widget.drIntraction != null
                ? widget.drIntraction!.hospitalUnitName
                : selectedHospitalSiteUnit;
            selectedClinicalInstructor = widget.drIntraction != null
                ? widget.drIntraction!.clinicianFullName
                : selectedClinicalInstructor;
          }
          hospitalSiteUnitList = widget.hospitalUnitListResponseDart.data;
          selectedRotation =
              widget.rotationTitle.isNotEmpty && widget.hospitalTitle.isNotEmpty
                  ? "${widget.rotationTitle} (${widget.hospitalTitle})"
                  : selectedRotation;
          // rotationEvalList = widget.rotationListStudentJournal.data!;
          // selectedRotationId = widget.rotationID;
        });
      }
    });
    super.initState();
  }

  interactionDatePickerOnTap() async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      value: [interactionDate],
      config: CalendarDatePicker2WithActionButtonsConfig(
          lastDate: DateTime.now(),
          selectedDayHighlightColor: Color(Hardcoded.primaryGreen)),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
    );

    if (results!.first != null) {
      setState(() {
        interactionDate = results.first!;
        interactionDateController.text =
            DateFormat('MM-dd-yyyy').format(interactionDate);
      });
    }
  }

  clinicianSigDatePickerOnTap() async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      value: [clinicianSignatureDate],
      config: CalendarDatePicker2WithActionButtonsConfig(
          lastDate: DateTime.now(),
          selectedDayHighlightColor: Color(Hardcoded.primaryGreen)),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
    );

    if (results!.first != null) {
      setState(() {
        clinicianSignatureDate = results.first!;
        clinicianSignatureController.text =
            DateFormat('yyyy-MM-dd').format(clinicianSignatureDate);
      });
    }
  }

  schoolSigDatePickerOnTap() async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      value: [schoolSignatureDate],
      config: CalendarDatePicker2WithActionButtonsConfig(
          lastDate: DateTime.now(),
          selectedDayHighlightColor: Color(Hardcoded.primaryGreen)),
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(15),
    );

    if (results!.first != null) {
      setState(() {
        schoolSignatureDate = results.first!;
        schoolSignatureController.text =
            DateFormat('yyyy-MM-dd').format(schoolSignatureDate);
      });
    }
  }

  final interactionDateFocusNode = FocusNode();
  final clinicianSignatureFocusNode = FocusNode();
  final schoolSignatureFocusNode = FocusNode();
  final timeSpentFocusNode = FocusNode();
  final pointsAwardedFocusNode = FocusNode();
  final studentResponseFocusNode = FocusNode();
  final hospitalSiteUnitFocusNode = FocusNode();
  final clinicianNameFocusNode = FocusNode();
  final clinicianResponseFocusNode = FocusNode();
  final schoolResponseFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // rotationEvalList = widget.rotationForEvalListModel.data!;
    hospitalSiteUnitList = widget.hospitalUnitListResponseDart.data;
    return Scaffold(
      backgroundColor: Color(Hardcoded.white),
      appBar: CommonAppBar(
        title: widget.drIntractionAction == DrIntractionAction.add
            ? 'Add Dr. Interaction'
            : widget.drIntractionAction == DrIntractionAction.edit
                ? 'Edit Dr. Interaction'
                : 'View Dr. Interaction',
      ),
      bottomNavigationBar: BottomAppBar(
        height: globalHeight * 0.085,
        // color: Colors.amber,
        elevation: 0,
        child: Visibility(
          visible: widget.drIntractionAction != DrIntractionAction.view,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CommonRoundedLoadingButton(
                  controller: save,
                  width: globalWidth * 0.9,
                  title: 'Save',
                  textcolor: Colors.white,
                  onTap: () async {
                    // DateTime interacDate1 = DateFormat("MM-dd-yyyy").parse(interactionDateController.text);
                    //
                    // String interacDate = DateFormat("yyyy-MM-dd").format(interacDate1);
                    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
                    final DataService dataService = locator();
                    final DataResponseModel dataResponseModel;
                    if (widget.drIntractionAction == DrIntractionAction.add) {
                      if (validationsForAdd()) {
                        dataResponseModel =
                            await dataService.saveStudentDrInteraction(
                          box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                          box.get(Hardcoded.hiveBoxKey)!.accessToken,
                          selectedRotationId.isEmpty
                              ? widget.rotationID
                              : selectedRotationId,
                          // getRotationID(selectedRotation).toString(),
                          selectedClinicianId,
                          DateFormat('yyyy-MM-dd HH:mm:ss')
                              .format(interactionDate),
                          selectedHospitalUnitId,
                          timeSpentController.text,
                          studentResponseController.text,
                        );
                        if (dataResponseModel.success) {
                          save.success();
                          if (widget.drIntractionAction ==
                              DrIntractionAction.add) {
                            Navigator.pop(context);
                            common_alert_pop(
                                context,
                                'Successfully added\nDr. Interaction.',
                                'assets/images/success_Icon.svg', () {
                              Navigator.pop(context);
                            });
                            // AppHelper.buildErrorSnackbar(
                            //     context, 'Dr. Interaction added successfully');
                          }
                          store.dispatch(getDrInteractions(
                            searchText: '',
                            rotationId: widget.drIntraction!.rotationId,
                            // page: 1
                          ));
                          Future.delayed(Duration(seconds: 2), () {
                            save.reset();
                          }).then((value) => Navigator.pop(context));
                        }
                      } else {
                        save.error();
                        Future.delayed(Duration(seconds: 2), () {
                          save.reset();
                        });
                      }
                    } else if (widget.drIntractionAction ==
                        DrIntractionAction.edit) {
                      if (validationsForAdd()) {
                        dataResponseModel =
                            await dataService.editStudentDrInteraction(
                          widget.drIntraction!.interactionId,
                          box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                          box.get(Hardcoded.hiveBoxKey)!.accessToken,
                          widget.drIntraction!.rotationId,
                          selectedClinicianId,
                          DateFormat('yyyy-MM-dd')
                              .format(widget.drIntraction!.interactionDate),
                          selectedHospitalUnitId,
                          timeSpentController.text,
                          studentResponseController.text,
                          widget.drIntraction!.pointsAwarded,
                        );
                        if (dataResponseModel.success) {
                          save.success();
                          if (widget.drIntractionAction ==
                              DrIntractionAction.edit) {
                            Navigator.pop(context);
                            common_alert_pop(
                                context,
                                'Successfully updated\nDr. Interaction.',
                                'assets/images/success_Icon.svg', () {
                              Navigator.pop(context);
                            });
                            // AppHelper.buildErrorSnackbar(context,
                            //     'Dr. Interaction updated successfully');
                          }
                          store.dispatch(getDrInteractions(
                            searchText: '',
                            rotationId: widget.drIntraction!.rotationId,
                            // page: 1
                          ));
                          Future.delayed(Duration(seconds: 2), () {
                            save.reset();
                          }).then((value) => Navigator.pop(context));
                        }
                      } else {
                        save.error();
                        Future.delayed(Duration(seconds: 2), () {
                          save.reset();
                        });
                      }
                    }

                    // if (dataResponseModel.success) {
                    //   save.success();
                    //   if (widget.drIntractionAction == DrIntractionAction.add) {
                    //     AppHelper.buildErrorSnackbar(
                    //         context, 'Dr. Interaction added successfully');
                    //   } else {
                    //     AppHelper.buildErrorSnackbar(
                    //         context, 'Dr. Interaction updated successfully');
                    //   }

                    ///check whether the add rotation flow  is coming from dashboard or from rotationdetails page
                    //   if (widget.isFromDashboard) {
                    //     store.dispatch(getDrInteractions(
                    //       searchText: '',
                    //       rotationId: widget.drIntraction!.rotationId,
                    //       // page: 1
                    //     ));
                    //   } else {
                    //     store.dispatch(getDrInteractions(
                    //       searchText: '',
                    //       rotationId:
                    //           getRotationID(selectedRotation).toString(),
                    //       // page: 1
                    //     ));
                    //   }
                    //   Future.delayed(Duration(seconds: 2), () {
                    //     save.reset();
                    //   }).then((value) => Navigator.pop(context));
                    // }
                    FocusScope.of(context).unfocus();
                  },
                  color: Color(Hardcoded.primaryGreen),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(children: [
            Column(
              children: [
                SizedBox(
                  height: 105,
                ),

                ///interaction date
                GestureDetector(
                  child: Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: interactionDateFocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonTextfield(
                        inputText: "Interaction Date",
                        iscalenderField: true,
                        autoFocus: false,
                        focusNode: interactionDateFocusNode,
                        hintText: 'Select interaction date',
                        textEditingController: interactionDateController,
                        enabled:
                            widget.drIntractionAction == DrIntractionAction.add,
                        readOnly:
                            widget.drIntractionAction == DrIntractionAction.add,
                        onTap: () {
                          interactionDatePickerOnTap();
                        },
                        sufix: GestureDetector(
                          onTap: () {
                            interactionDatePickerOnTap();
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
                const SizedBox(
                  height: 10,
                ),

                GestureDetector(
                  child: Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: clinicianSignatureFocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonTextfield(
                        inputText: "Clinician Signature",
                        iscalenderField: true,
                        autoFocus: false,
                        focusNode: clinicianSignatureFocusNode,
                        hintText:
                            widget.drIntractionAction == DrIntractionAction.add
                                ? 'Clinician signature'
                                : "Clinician signature",
                        textEditingController: clinicianSignatureController,
                        enabled: false,
                        readOnly: true,
                        onTap: () {},
                        sufix: GestureDetector(
                          onTap: () {},
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
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  child: Material(
                    color: Colors.white,
                    child: IOSKeyboardAction(
                      label: 'DONE',
                      focusNode: schoolSignatureFocusNode,
                      focusActionType: FocusActionType.done,
                      onTap: () {},
                      child: CommonTextfield(
                        inputText: "School Signature",
                        iscalenderField: true,
                        autoFocus: false,
                        focusNode: schoolSignatureFocusNode,
                        hintText:
                            widget.drIntractionAction == DrIntractionAction.add
                                ? 'School signature'
                                : "School signature",
                        textEditingController: schoolSignatureController,
                        readOnly: true,
                        enabled: false,
                        onTap: () {},
                        sufix: GestureDetector(
                          onTap: () {},
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
                  height: widget.drIntractionAction == DrIntractionAction.edit
                      ? globalHeight * 0.23
                      : selectedRotation.isNotEmpty && clinicianList.isNotEmpty
                          ? globalHeight * 0.23
                          : globalHeight * 0.12,
                ),

                // CoomonDropDown(
                //     isEdit: widget.drIntractionAction != DrIntractionAction.view,
                //     items: clincianNameList,
                //     selectedValue: selectedClinicalInstructor,
                //     title: "Select Clinical instructor",
                //     onChanged: (value) {
                //       setState(() {
                //         selectedClinicalInstructor = value!;
                //       });
                //     },
                //     width: globalWidth * 0.9),

                // CoomonDropDown(
                //     isEdit: widget.drIntractionAction != DrIntractionAction.view,
                //     items: hospitalSiteUnitList,
                //     selectedValue: selectedHospitalSiteUnit,
                //     title: "Select Hospital site Units",
                //     onChanged: (value) {
                //       setState(() {
                //         selectedHospitalSiteUnit = value!;
                //       });
                //     },
                //     width: globalWidth * 0.9),

                const SizedBox(
                  height: 10,
                ),
                Material(
                  color: Colors.white,
                  child: IOSKeyboardAction(
                    label: 'DONE',
                    focusNode: timeSpentFocusNode,
                    focusActionType: FocusActionType.done,
                    onTap: () {},
                    child: CommonTextfield(
                      inputText: "Amount of Time Spent",
                      autoFocus: false,
                      focusNode: timeSpentFocusNode,
                      enabled:
                          widget.drIntractionAction != DrIntractionAction.view,
                      hintText: "Enter amount of time spent",
                      textEditingController: timeSpentController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        NoSpaceFormatter()
                      ],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: globalWidth * 0.05),
                      child: Text(
                        'e.g.If Minutes, i.e. 01 equals 1 minute',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(Hardcoded.greyText),
                            ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Material(
                //   color: Colors.white,
                //   child: IOSKeyboardAction(
                //     label: 'DONE',
                //     focusNode: pointsAwardedFocusNode,
                //     focusActionType: FocusActionType.done,
                //     onTap: () {},
                //     child: CommonTextfield(
                //       inputText: "Points Awarded",
                //       autoFocus: false,
                //       focusNode: pointsAwardedFocusNode,
                //       enabled: false,
                //       readOnly: true,
                //       hintText: "Points awarded",
                //       textEditingController: pointsAwardedController,
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Material(
                  color: Colors.white,
                  child: IOSKeyboardAction(
                    label: 'DONE',
                    focusNode: studentResponseFocusNode,
                    focusActionType: FocusActionType.done,
                    onTap: () {},
                    child: CommonTextfield(
                      inputText: "Student Response",
                      autoFocus: false,
                      focusNode: studentResponseFocusNode,
                      hintText: "Enter student response",
                      textEditingController: studentResponseController,
                      maxLines: 7,
                      enabled:
                          widget.drIntractionAction != DrIntractionAction.view,
                      buildCounter: (context,
                          {required currentLength,
                          required isFocused,
                          maxLength}) {
                        return Visibility(
                          visible: studentResponseController.text.length <=
                              int.parse("${widget.interactionDecCount}"),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${studentResponseController.text.length} characters (Minimum ${widget.interactionDecCount} characters)",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Color(Hardcoded.greyText),
                                  ),
                            ),
                          ),
                          replacement: SizedBox(),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Visibility(
                //     visible: widget.drIntractionAction != DailyJournalViewType.add,
                //     child: responseText(
                //       inputText: "Clinician Response",
                //         Response: clinicianResponse,
                //         enable: false,
                //         ResponseText: clinicianResponseText,
                //         // Title: "Clinician Response"
                //     )),
                // Visibility(
                //     visible: widget.drIntractionAction != DailyJournalViewType.add,
                //     child: responseText(
                //       inputText: "School Reponse",
                //         Response: schoolResponse,
                //         enable: false,
                //         ResponseText: schoolResponseText,
                //         // Title: "School Response",
                //     )),
                widget.drIntractionAction == DrIntractionAction.add
                    ? Container()
                    : widget.drIntraction!.clinicianResponse.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: Color(Hardcoded.textFieldBg),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Color(Hardcoded.greyText),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Waiting for Clinician Response",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(Hardcoded.hintColor)),
                                ),
                              ),
                            ),
                          )
                        : Material(
                            color: Colors.white,
                            child: IOSKeyboardAction(
                              label: 'DONE',
                              focusNode: clinicianResponseFocusNode,
                              focusActionType: FocusActionType.done,
                              onTap: () {},
                              child: CommonTextfield(
                                inputText: "Clinician Response",
                                autoFocus: false,
                                focusNode: clinicianResponseFocusNode,
                                hintText: "",
                                textEditingController: clinicianResponseText,
                                maxLines: 7,
                                enabled: false,
                              ),
                            ),
                          ),
                const SizedBox(
                  height: 20,
                ),
                widget.drIntractionAction == DrIntractionAction.add
                    ? Container()
                    : widget.drIntraction!.schoolResponse.isEmpty
                        ? Container(
                            decoration: BoxDecoration(
                              color: Color(Hardcoded.textFieldBg),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: Color(Hardcoded.greyText),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Waiting for School Response",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color(Hardcoded.hintColor)),
                                ),
                              ),
                            ),
                          )
                        : Material(
                            color: Colors.white,
                            child: IOSKeyboardAction(
                              label: 'DONE',
                              focusNode: schoolResponseFocusNode,
                              focusActionType: FocusActionType.done,
                              onTap: () {},
                              child: CommonTextfield(
                                inputText: "School Response",
                                autoFocus: false,
                                focusNode: schoolResponseFocusNode,
                                hintText: "",
                                textEditingController: schoolResponseText,
                                maxLines: 7,
                                enabled: false,
                              ),
                            ),
                          ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Stack(
              children: [
                Column(
                  children: [
                    ExpansionWidget<RotationJournalData>(
                        inputText: "Rotation",
                        hintText: selectedRotation.toString().isNotEmpty
                            ? selectedRotation.toString()
                            : "Select rotation",
                        textColor: selectedRotation.toString().isNotEmpty
                            ? Colors.black
                            : Color(Hardcoded.greyText),
                        enabled:
                            widget.drIntractionAction == DrIntractionAction.add,
                        OnSelection: (value) {
                          setState(() {
                            // setValue();
                            RotationJournalData c =
                                value as RotationJournalData;
                            selectedRotationValue = c;
                            selectedRotation = selectedRotationValue.title!;
                            selectedRotationId =
                                selectedRotationValue.rotationId.toString();
                            getClinicianNameList();
                            store.dispatch(GetClinicianListAction(
                                rotationId: selectedRotationValue.rotationId
                                    .toString()));
                          });
                          log("id---------${selectedRotationValue.rotationId}");
                        },
                        items: List.of(rotationJournalList.map((item) {
                          String text = item.title.toString();
                          List<String> title = text.split("(");
                          String subText = title[1];
                          List<String> subTitle = subText.split(")");
                          return DropdownItem<RotationJournalData>(
                            value: item,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0,
                                    left: globalWidth * 0.06,
                                    right: globalWidth * 0.06,
                                    bottom: 8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title[0],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                      ),
                                      Text(subTitle[0],
                                          // widget.hintText,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Color(
                                                      Hardcoded.greyText))),
                                    ])),
                          );
                        }))),
                    // Expansion(
                    //   OnSelection: (String value) {
                    //     setState(() {
                    //       selectedRotation = value;
                    //       store.dispatch(GetClinicianListAction(
                    //           rotationId:
                    //               getRotationID(selectedRotation).toString()));
                    //       selectedRotationId = getRotationID(selectedRotation).toString();
                    //       getClinicanNameList();
                    //     });
                    //   },
                    //   inputText: "Rotation",
                    //   bodyList: rotationList,
                    //   trailIcon: "",
                    //   textColor: selectedRotation.toString().isNotEmpty ? Colors.black: Color(Hardcoded.greyText),
                    //   hintText: selectedRotation.isEmpty
                    //       ? "Select rotation"
                    //       : selectedRotation,
                    //   enabled:
                    //       widget.drIntractionAction == DrIntractionAction.add,
                    // ),
                  ],
                )
              ],
            ),
            Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height:
                          widget.drIntractionAction == DrIntractionAction.edit
                              ? 455
                              : selectedRotation.isNotEmpty &&
                                      clinicianList.isNotEmpty
                                  ? 455
                                  : 360,
                    ),
                    ExpansionWidget<Datum>(
                        inputText: "Hospital Site Unit",
                        hintText: selectedHospitalSiteUnit.isNotEmpty
                            ? selectedHospitalSiteUnit
                            : "Select hospital site unit",
                        textColor: selectedHospitalSiteUnit.isNotEmpty
                            ? Colors.black
                            : Color(Hardcoded.greyText),
                        enabled: widget.drIntractionAction !=
                            DrIntractionAction.view,
                        OnSelection: (value) {
                          setState(() {
                            // setValue();
                            Datum c = value as Datum;
                            selectedhospitalSiteUnitValue = c;
                            selectedHospitalSiteUnit =
                                selectedhospitalSiteUnitValue.title!.toString();
                            selectedHospitalUnitId =
                                selectedhospitalSiteUnitValue
                                    .hospitalSiteUnitId!;
                          });
                          log("id---------${selectedhospitalSiteUnitValue.hospitalSiteUnitId!}");
                        },
                        items: List.of(hospitalSiteUnitList.map((item) {
                          String text = item.title.toString();
                          // List<String> title = text.split("(");
                          // String subText = title[0];
                          // List<String> subTitle = subText.split(")");
                          return DropdownItem<Datum>(
                            value: item,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0,
                                    left: globalWidth * 0.06,
                                    right: globalWidth * 0.06,
                                    bottom: 8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        text,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                      ),
                                      // Text( subTitle[0],
                                      //     // widget.hintText,
                                      //     maxLines: 1,
                                      //     overflow: TextOverflow.ellipsis,
                                      //     style: Theme.of(context).textTheme.headline6?.copyWith(
                                      //         fontWeight: FontWeight.w400,
                                      //         fontSize: 14,
                                      //         color: Color(Hardcoded.greyText))),
                                    ])),
                          );
                        }))),
                    // Expansion(
                    //   OnSelection: (String value) {
                    //     setState(() {
                    //       selectedHospitalSiteUnit = value;
                    //     });
                    //   },
                    //   inputText: "Hospital Site Unit",
                    //   bodyList: hospitalSiteUnitList,
                    //   trailIcon: "",
                    //   textColor: selectedHospitalSiteUnit.toString().isNotEmpty ? Colors.black: Color(Hardcoded.greyText),
                    //   hintText: selectedHospitalSiteUnit.isEmpty
                    //       ? "Select hospital site unit"
                    //       : selectedHospitalSiteUnit,
                    //   enabled:
                    //       widget.drIntractionAction != DrIntractionAction.view,
                    // ),
                  ],
                )
              ],
            ),
            Visibility(
              visible: widget.drIntractionAction == DrIntractionAction.add
                  ? selectedRotation.isNotEmpty && clinicianList.isNotEmpty
                  : selectedClinicalInstructor.isNotEmpty,
              replacement: Container(),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 360),
                      ExpansionWidget<ClinicianData>(
                          inputText: "Clinician Name",
                          hintText: selectedClinicalInstructor.isNotEmpty
                              ? selectedClinicalInstructor
                              : "Select clinician name",
                          textColor:
                              selectedClinicalInstructor.toString().isNotEmpty
                                  ? Colors.black
                                  : Color(Hardcoded.greyText),
                          enabled: widget.drIntractionAction ==
                                  DrIntractionAction.add
                              ? true
                              : false,
                          // isSearch: true,
                          // searchWidget: Padding(
                          //   padding: EdgeInsets.only(
                          //     top: 5,
                          //   ),
                          //   child: Material(
                          //     color: Colors.white,
                          //     child: IOSKeyboardAction(
                          //       label: 'DONE',
                          //       focusNode: searchClinicianFocusNode,
                          //       focusActionType: FocusActionType.done,
                          //       onTap: () {},
                          //       child: CommonSearchTextfield(
                          //         focusNode: searchClinicianFocusNode,
                          //         hintText: 'Search here',
                          //         autoFocus: false,
                          //         textEditingController: searchClinicianName,
                          //         fillColor: Color(0x1413AD5D),
                          //         sufix: Container(
                          //           transform: Matrix4.translationValues(
                          //               0.0, 0.0, 0.0),
                          //           child: GestureDetector(
                          //             onTap: () {
                          //               searchClinicianName.text = '';
                          //               searchClinicianName.clear();
                          //               searchCourseTopic("");
                          //               // FocusManager.instance.primaryFocus!
                          //               //     .unfocus();
                          //             },
                          //             child: Icon(
                          //               Icons.clear,
                          //               color:
                          //               Color.fromARGB(255, 98, 105, 121),
                          //             ),
                          //           ),
                          //         ),
                          //         onChanged: (String coursetext) {
                          //           searchCourseTopic(coursetext);
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          OnSelection: (value) {
                            setState(() {
                              ClinicianData c = value as ClinicianData;
                              selectedClinicianValue = c;
                              selectedClinicalInstructor =
                                  selectedClinicianValue.title!;
                              selectedClinicianId =
                                  selectedClinicianValue.clinicianId.toString();
                            });
                            // log("id---------${selectedClinicianValue.clinicianId}");
                          },
                          items: List.of(clinicianList.map(
                            (item) => DropdownItem<ClinicianData>(
                              value: item,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0,
                                    left: globalWidth * 0.06,
                                    right: globalWidth * 0.06,
                                    bottom: 8.0),
                                child: Text(item.title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Colors.black,
                                        )),
                              ),
                            ),
                          ))),
                      // Expansion(
                      //   OnSelection: (String value) {
                      //     setState(() {
                      //       selectedClinicalInstructor = value;
                      //     });
                      //   },
                      //   inputText: "Clinician Name",
                      //   bodyList: clincianNameList,
                      //   textColor: selectedClinicalInstructor.toString().isNotEmpty ? Colors.black: Color(Hardcoded.greyText),
                      //   trailIcon: "",
                      //   hintText: selectedClinicalInstructor.isEmpty
                      //       ? "Select clinician name"
                      //       : selectedClinicalInstructor,
                      //   enabled:
                      //       widget.drIntractionAction != DrIntractionAction.view,
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  bool validationsForAdd() {
    if (selectedRotation.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select rotation");
      return false;
    }
    if (interactionDateController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please add interaction date");
      return false;
    }
    if (selectedClinicalInstructor.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select clinician name");
      return false;
    }

    if (selectedHospitalSiteUnit.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select hospital site unit");
      return false;
    }

    if (timeSpentController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please add amount of time spent");
      return false;
    }
    int decCount = int.parse("${widget.interactionDecCount.toString()}");
    if (studentResponseController.text.length < decCount) {
      AppHelper.buildErrorSnackbar(context,
          "Student response must contain ${widget.interactionDecCount} characters");
      return false;
    }

    // if (studentResponseController.text.isEmpty) {
    //   AppHelper.buildErrorSnackbar(
    //       context, "Please add student response in brif");
    //   return false;
    // }
    return true;
  }
}

class responseText extends StatelessWidget {
  const responseText(
      {super.key,
      required this.Response,
      required this.ResponseText,
      required this.inputText,
      // required this.Title,
      required this.enable});

  final bool Response;
  final TextEditingController ResponseText;

  // final String Title;
  final String inputText;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Response,
      replacement: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(Hardcoded.textFieldBg),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Color(Hardcoded.greyText),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Wait for $Title",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(Hardcoded.hintColor)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   Title,
          //   textAlign: TextAlign.start,
          //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 14,
          //       color: Color(Hardcoded.hintColor)),
          // ),
          CommonTextfield(
            inputText: inputText,
            autoFocus: false,
            hintText: "",
            enabled: enable,
            textEditingController: ResponseText,
            maxLines: 8,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
