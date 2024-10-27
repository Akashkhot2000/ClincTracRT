import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_details_response.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/save_journal_request_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/update_journal_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DailyJournalDetailsScreen extends StatefulWidget {
  final String JournalId;
  final String rotationId;
  final String hospitalTitle;
  final String hospitalId;
  final String journalDecCount;
  final DailyJournalViewType Viewtype;
  final UserLoginResponse user;
  final RotationListStudentJournal rotationList;
  final HospitalUnitListResponseDart hospitalUnitList;
  final RotationForEvalListModel rotationForEvalListModel;

  const DailyJournalDetailsScreen({
    required this.JournalId,
    required this.rotationId,
    required this.hospitalTitle,
    required this.hospitalId,
    required this.journalDecCount,
    required this.Viewtype,
    required this.rotationList,
    required this.user,
    required this.hospitalUnitList,
    required this.rotationForEvalListModel,
  });

  @override
  State<DailyJournalDetailsScreen> createState() =>
      _DailyJournalDetailsScreenState();
}

class _DailyJournalDetailsScreenState extends State<DailyJournalDetailsScreen> {
  List<String> rotations = [];
  String selectedRotation = '';
  String selectedRotationId = '';
  DateTime journalDate = DateTime.now();
  TextEditingController journalDateText = TextEditingController();
  TextEditingController hospitalSite = TextEditingController();

  List<String> HospitalUnit = [];
  String selectedHospitalUnit = '';
  String selectedHospitalUnitId = '';
  String hospitalSiteId = '';
  TextEditingController studentJournalEntry = TextEditingController();
  bool clinicianResponse = false;
  TextEditingController clinicianResponseText = TextEditingController();
  bool schoolResponse = false;
  TextEditingController schoolResponseText = TextEditingController();
  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();
  bool isDataLoading = true;
  List<RotationJournalData> rotationJournalList = <RotationJournalData>[];
  RotationJournalData selectedRotationValue = RotationJournalData();
  List<Datum> hospitalSiteUnitList = <Datum>[];
  Datum selectedhospitalSiteUnitValue = Datum();

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
    });
    // log("${dataResponseModel.data}");
  }

  @override
  void initState() {
    setValue();
    setState(() {
      getRotationList();
      selectedRotation =
          widget.JournalId.isNotEmpty && widget.hospitalTitle.isNotEmpty
              ? "${widget.JournalId}(${widget.hospitalTitle})"
              : selectedRotation;
      hospitalSiteUnitList = widget.hospitalUnitList.data;
    });
    super.initState();
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  void setValue() async {
    switch (widget.Viewtype) {
      case DailyJournalViewType.add:
        List<String> temp = [];
        temp = [];
        for (var cnt in widget.hospitalUnitList.data) {
          temp.add(cnt.title!);
        }
        setState(() {
          HospitalUnit = temp;
          hospitalSite.text = widget.hospitalTitle!;
          hospitalSiteId = widget.rotationList.data[0].hospitalSiteId!;
        });
        setState(() {
          isDataLoading = false;
        });
        break;

      case DailyJournalViewType.addDash:
        List<String> temp = [];
        for (var cnt in widget.rotationList.data) {
          temp.add(cnt.title!);
        }
        setState(() {
          rotations = temp;
          selectedRotation;
        });
        rotations.remove('All');
        setState(() {
          HospitalUnit = temp;
        });
        setState(() {
          isDataLoading = false;
        });
        break;
      case DailyJournalViewType.edit:
        List<String> temp = [];
        for (var cnt in widget.rotationList.data) {
          temp.add(cnt.title!);
        }
        setState(() {
          rotations = temp;
          rotations.remove('All');
        });

        setState(() {
          HospitalUnit = temp;
        });
        Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
        JournalDetailsRequest journalDetailsRequest = JournalDetailsRequest(
            accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
            userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
            journalId: widget.JournalId);
        final DataService dataService = locator();
        DataResponseModel dataResponseModel =
            await dataService.getDailyJournalDetails(journalDetailsRequest);
        DailyJournalDetailsResponse response =
            DailyJournalDetailsResponse.fromJson(dataResponseModel.data);
        setState(() {
          journalDate = DateTime.parse("${response.data.journalDate}");
          selectedRotationId = response.data.rotationId;
          journalDateText.text = convertDate(response.data.journalDate);
          hospitalSite.text = response.data.hospitalName;
          selectedHospitalUnit = response.data.hospitalSiteunitName;
          selectedRotation = response.data.rotationName.isNotEmpty &&
                  response.data.hospitalName.isNotEmpty
              ? "${response.data.rotationName} (${response.data.hospitalName})"
              : selectedRotation;
          selectedHospitalUnitId = response.data.hospitalSiteUnitId;
          studentJournalEntry.text = response.data.studentResponseForEdit;
          if (clinicianResponse)
            clinicianResponseText.text = response.data.clinicianResponseForEdit;
          schoolResponse = response.data.schoolResponse;
          if (schoolResponse)
            schoolResponseText.text = response.data.schoolResponseForEdit;
        });
        setState(() {
          isDataLoading = false;
        });
        break;
    }
  }

  final journalDateFocusNode = FocusNode();
  final hospitalSiteFocusNode = FocusNode();
  final hospitalSiteIdFocusNode = FocusNode();
  final studentJournalEntryFocusNode = FocusNode();
  final clinicianResponseFocusNode = FocusNode();
  final schoolResponseFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    String title = '';
    switch (widget.Viewtype) {
      case DailyJournalViewType.add:
        title = "Add Daily Journal";
        break;
      case DailyJournalViewType.addDash:
        title = "Add Daily Journal";
        break;
      case DailyJournalViewType.view:
        title = "View Daily Journal";
        break;
      case DailyJournalViewType.edit:
        title = "Edit Daily Journal";
        break;
    }
    // log(selectedRotation);
    hospitalSiteUnitList = widget.hospitalUnitList.data;
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
      backgroundColor: Color(Hardcoded.white),
      bottomNavigationBar: Visibility(
        visible: widget.Viewtype != DailyJournalViewType.view,
        child: BottomAppBar(
          height: globalHeight * 0.085,
          // color: Colors.amber,
          elevation: 0,
          child: CommonRoundedLoadingButton(
            controller: save,
            width: globalWidth * 0.9,
            textcolor: Color(Hardcoded.white),
            onTap: () async {
              Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
              final DataService dataService = locator();
              final DataResponseModel dataResponseModel;
              if (widget.Viewtype == DailyJournalViewType.edit) {
                DateTime journalDate1 =
                    DateFormat("MM-dd-yyyy").parse(journalDateText.text);

                String journalDate3 =
                    DateFormat("yyyy-MM-dd").format(journalDate1);
                if (validateDailyjournal()) {
                  UpdateJournalRequest updateJournalRequest =
                      UpdateJournalRequest(
                    journalId: widget.JournalId,
                    userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                    rotationId: selectedRotationId.isEmpty
                        ? widget.rotationId
                        : selectedRotationId,
                    journalDate: journalDate3.toString(),
                    hospitalSiteId: hospitalSiteId,
                    hospitalSiteUnitId: selectedHospitalUnitId,
                    studentJournalEntry: studentJournalEntry.text,
                    accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
                  );

                  dataResponseModel = await dataService
                      .updateStudentJournal(updateJournalRequest);
                  if (dataResponseModel.success) {
                    Future.delayed(const Duration(seconds: 1), () {})
                        .then((value) {
                      Navigator.pop(context);
                      common_alert_pop(
                          context,
                          'Successfully updated\nDaily Journal.',
                          'assets/images/success_Icon.svg', () {
                        Navigator.pop(context);
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    });
                  }
                } else {
                  save.error();
                  Future.delayed(Duration(seconds: 2), () {
                    save.reset();
                  });
                }
              } else if (widget.Viewtype == DailyJournalViewType.add) {
                if (validateDailyjournal()) {
                  SaveJournalRequest saveJournalRequest = SaveJournalRequest(
                    userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                    rotationId: selectedRotationId.isEmpty
                        ? widget.rotationId
                        : selectedRotationId,
                    journalDate: journalDate,
                    hospitalSiteId: hospitalSiteId,
                    hospitalSiteUnitId: selectedHospitalUnitId,
                    studentJournalEntry: studentJournalEntry.text,
                    accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
                  );

                  dataResponseModel =
                      await dataService.saveStudentJournal(saveJournalRequest);
                  if (dataResponseModel.success) {
                    Future.delayed(const Duration(seconds: 1), () {})
                        .then((value) {
                      Navigator.pop(context);
                      common_alert_pop(
                          context,
                          'Successfully added\nDaily Journal.',
                          'assets/images/success_Icon.svg', () {
                        Navigator.pop(context);
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    });
                  } else {
                    Future.delayed(const Duration(seconds: 1), () {}).then(
                      (value) => AppHelper.buildErrorSnackbar(context,
                          dataResponseModel.errorResponse.errorMessage),
                    );
                  }
                } else {
                  save.error();
                  Future.delayed(Duration(seconds: 2), () {
                    save.reset();
                  });
                }
              } else if (widget.Viewtype == DailyJournalViewType.addDash) {
                if (validateDailyjournal()) {
                  SaveJournalRequest saveJournalRequest = SaveJournalRequest(
                    userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                    rotationId: selectedRotationId.isEmpty
                        ? widget.rotationId
                        : selectedRotationId,
                    journalDate: journalDate,
                    hospitalSiteId: hospitalSiteId,
                    hospitalSiteUnitId: selectedHospitalUnitId,
                    studentJournalEntry: studentJournalEntry.text,
                    accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
                  );
                  dataResponseModel =
                      await dataService.saveStudentJournal(saveJournalRequest);
                  if (dataResponseModel.success) {
                    Future.delayed(const Duration(seconds: 1), () {})
                        .then((value) {
                      Navigator.pop(context);
                      common_alert_pop(
                          context,
                          'Successfully added\nDaily Journal.',
                          'assets/images/success_Icon.svg', () {
                        Navigator.pop(context);
                      });
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.pop(context);
                      });
                    });
                  } else {
                    Future.delayed(const Duration(seconds: 1), () {}).then(
                      (value) => AppHelper.buildErrorSnackbar(context,
                          dataResponseModel.errorResponse.errorMessage),
                    );
                  }
                } else {
                  save.error();
                  Future.delayed(Duration(seconds: 2), () {
                    save.reset();
                  });
                }
              }
            },
            title: 'Save',
            color: Color(Hardcoded.primaryGreen),
          ),
        ),
      ),
      body: NoInternet(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Visibility(
              visible: !isDataLoading,
              replacement: common_loader(),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: globalHeight * 0.13,
                      ),
                      GestureDetector(
                        child: CommonTextfield(
                          inputText: "Journal Date",
                          autoFocus: false,
                          focusNode: journalDateFocusNode,
                          hintText: 'Select journal date',
                          textEditingController: journalDateText,
                          readOnly: true,
                          enabled: widget.Viewtype != DailyJournalViewType.view,
                          onTap: () async {
                            var results = await showCalendarDatePicker2Dialog(
                              context: context,
                              value: [journalDate],
                              config:
                                  CalendarDatePicker2WithActionButtonsConfig(
                                lastDate: DateTime.now(),
                                selectedDayHighlightColor:
                                    Color(Hardcoded.primaryGreen),
                              ),
                              dialogSize: const Size(325, 400),
                              borderRadius: BorderRadius.circular(15),
                            );
                            if (results!.first!.compareTo(DateTime.now()) < 0 ||
                                results.first!.compareTo(DateTime.now()) == 0) {
                              setState(() {
                                journalDate = results.first!;
                                journalDateText.text = DateFormat('MM-dd-yyyy')
                                    .format(journalDate);
                                // log(journalDateText.text);
                              });
                            } else {
                              AppHelper.buildErrorSnackbar(context,
                                  "From Date cannot be greater than to Date");
                            }
                          },
                          sufix: GestureDetector(
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
                      SizedBox(
                          height: selectedRotation.isNotEmpty
                              ? globalHeight * 0.015
                              : globalHeight * 0.009),
                      Visibility(
                        visible: selectedRotation.isNotEmpty,
                        child: Material(
                          color: Colors.white,
                          child: IOSKeyboardAction(
                            label: 'DONE',
                            focusNode: hospitalSiteFocusNode,
                            focusActionType: FocusActionType.done,
                            onTap: () {},
                            child: CommonTextfield(
                              inputText: "Hospital Site",
                              autoFocus: false,
                              overflow: TextOverflow.ellipsis,
                              focusNode: hospitalSiteFocusNode,
                              hintText: "Hospital Site",
                              enabled: false,
                              readOnly: false,
                              textEditingController: hospitalSite,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: selectedRotation.isNotEmpty
                            ? globalHeight * 0.132
                            : globalHeight * 0.13,
                      ),
                      Column(
                        children: [
                          Material(
                            color: Colors.white,
                            child: IOSKeyboardAction(
                              label: 'DONE',
                              focusNode: studentJournalEntryFocusNode,
                              focusActionType: FocusActionType.done,
                              onTap: () {},
                              child: CommonTextfield(
                                buildCounter: (context,
                                    {required currentLength,
                                    required isFocused,
                                    maxLength}) {
                                  return Visibility(
                                    visible: studentJournalEntry.text.length <=
                                        int.parse("${widget.journalDecCount}"),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "${studentJournalEntry.text.length} characters (Minimum ${widget.journalDecCount} characters)",
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
                                inputText: "Student Journal Entry",
                                autoFocus: false,
                                focusNode: studentJournalEntryFocusNode,
                                hintText: "Enter student journal entry",
                                enabled:
                                    widget.Viewtype != DailyJournalViewType.view
                                        ? true
                                        : false,
                                textEditingController: studentJournalEntry,
                                maxLines: 8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: selectedRotation.isNotEmpty
                                ? globalHeight * 0.335
                                : globalHeight * 0.23,
                          ),
                          ExpansionWidget<Datum>(
                            inputText: "Hospital Site Unit",
                            enabled:
                                widget.Viewtype != DailyJournalViewType.view
                                    ? true
                                    : false,
                            hintText:
                                widget.Viewtype != DailyJournalViewType.add ||
                                        widget.Viewtype !=
                                            DailyJournalViewType.addDash
                                    ? (selectedHospitalUnit.isEmpty
                                        ? "Select hospital site unit"
                                        : selectedHospitalUnit.toString())
                                    : "Select hospital site unit",
                            textColor:
                                selectedHospitalUnit.toString().isNotEmpty
                                    ? Colors.black
                                    : Color(Hardcoded.greyText),
                            OnSelection: (value) {
                              setState(() {
                                // setValue();
                                Datum c = value as Datum;
                                selectedhospitalSiteUnitValue = c;
                                selectedHospitalUnit =
                                    selectedhospitalSiteUnitValue.title!
                                        .toString();
                                selectedHospitalUnitId =
                                    selectedhospitalSiteUnitValue
                                        .hospitalSiteUnitId!;
                              });
                              // log("id---------${selectedhospitalSiteUnitValue.hospitalSiteUnitId!}");
                            },
                            items: List.of(
                              hospitalSiteUnitList.map(
                                (item) {
                                  String text = item.title.toString();
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
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      ExpansionWidget<RotationJournalData>(
                        inputText: "Rotation",
                        hintText: selectedRotation.toString().isNotEmpty
                            ? selectedRotation.toString()
                            : "Select rotation",
                        textColor: selectedRotation.toString().isNotEmpty
                            ? Colors.black
                            : Color(Hardcoded.greyText),
                        enabled: widget.Viewtype == DailyJournalViewType.add ||
                            widget.Viewtype == DailyJournalViewType.addDash,
                        OnSelection: (value) {
                          setState(() {
                            RotationJournalData c =
                                value as RotationJournalData;
                            selectedRotationValue = c;
                            selectedRotation =
                                selectedRotationValue.title.toString();
                            selectedRotationId =
                                selectedRotationValue.rotationId.toString();
                            hospitalSite.text =
                                selectedRotationValue.hospitalTitle!.toString();
                            hospitalSiteId =
                                selectedRotationValue.hospitalSiteId.toString();
                          });
                          // log("id---------${selectedRotationValue.rotationId}");
                        },
                        items: List.of(
                          rotationJournalList.map(
                            (item) {
                              String text = item.title.toString();
                              List<String> title = text.split("(");
                              String subText = title[1].toString();
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
                                      Text(
                                        subTitle[0],
                                        // widget.hintText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Color(Hardcoded.greyText),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validateDailyjournal() {
    if (selectedRotation.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select rotation");
      return false;
    }
    if (journalDateText.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select journal date");
      return false;
    }
    if (selectedHospitalUnit.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select hospital site unit");
      return false;
    }
    int decCount = int.parse("${widget.journalDecCount.toString()}");
    if (studentJournalEntry.text.length < decCount) {
      AppHelper.buildErrorSnackbar(context,
          "Student journal entry must contain ${widget.journalDecCount} characters");
      return false;
    }
    return true;
  }
}

class responseText extends StatelessWidget {
  const responseText(
      {super.key,
      required this.Response,
      required this.ResponseText,
      required this.Title});

  final bool Response;
  final TextEditingController ResponseText;
  final String Title;

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
                  "Waiting for $Title",
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
          Text(
            Title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(Hardcoded.hintColor)),
          ),
          CommonTextfield(
            autoFocus: false,
            hintText: "",
            enabled: false,
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
