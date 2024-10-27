import 'dart:developer';
import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';

// import 'package:clinicaltrac/common/common_dropDown_widget.dart';
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
import 'package:clinicaltrac/redux/action/checkoffs_action/get_course_topic_list_action.dart';
import 'package:clinicaltrac/redux/action/checkoffs_action/get_rotation_for_eval_action.dart';
import 'package:clinicaltrac/redux/action/dr_interaction/get_clinician_list_action.dart';
import 'package:clinicaltrac/view/check_offs/model/checkoffs_list_model.dart';
import 'package:clinicaltrac/view/check_offs/model/course_topic_list_model.dart';
import 'package:clinicaltrac/view/check_offs/model/create_checkoff_request_model.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/login_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddCheckoffsScreen extends StatefulWidget {
  AddCheckoffsScreen({
    Key? key,
    required this.userLoginResponse,
    required this.rotation,
    required this.courseTopicListModel,
    required this.rotationForEvalListModel,
    required this.studentCheckoffsListModel,
    required this.clinicianDataList,
    required this.allCourseTopicListModel,
    required this.hospitalUnitListResponseDart,
    required this.rotationListStudentJournal,
  }) : super(key: key);
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;
  final CourseTopicListModel courseTopicListModel;
  final CourseTopicListModel allCourseTopicListModel;
  final RotationForEvalListModel rotationForEvalListModel;
  final StudentCheckoffsListModel studentCheckoffsListModel;
  final ClinicianDataList clinicianDataList;
  final HospitalUnitListResponseDart hospitalUnitListResponseDart;
  final RotationListStudentJournal rotationListStudentJournal;

  @override
  State<AddCheckoffsScreen> createState() => _AddCheckoffsScreenState();
}

class _AddCheckoffsScreenState extends State<AddCheckoffsScreen> {
  Box<UserLoginResponseHive>? box = Boxes.getUserInfo();

  //controller
  TextEditingController checkoffDateController = TextEditingController();
  TextEditingController hospitalSiteUnitControler = TextEditingController();
  TextEditingController phoneNumberController =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController phoneNumber1Controller =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController phoneNumber2Controller =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController phoneNumber3Controller =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController phoneNumber4Controller =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController phoneNumber5Controller =
      MaskedTextController(mask: '000-000-0000');
  TextEditingController searchAllCourse = TextEditingController();
  TextEditingController searchSingleCourse = TextEditingController();
  TextEditingController searchClinicianName = TextEditingController();

  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();

  DateTime interactionDate = DateTime.now();
  DateTime clinicianSignatureDate = DateTime.now();
  DateTime schoolSignatureDate = DateTime.now();

  List<String> clincianNameList = [];
  List<String> courseTopicList = [];
  List<String> allCourseTopicList = [];
  CourseTopicListModel courseTopicListModel =
      CourseTopicListModel(data: <CourseTopicListData>[]);
  List<CourseTopicListData> usedCourseTopicList = <CourseTopicListData>[];
  List<CourseTopicListData> allUsedCourseTopicData = <CourseTopicListData>[];
  List<CourseTopicListData> singleCourseTopicList = <CourseTopicListData>[];
  List<CourseTopicListData> singleCourseTopicData = <CourseTopicListData>[];
  List<RotationForEvalListData> rotationEvalList = <RotationForEvalListData>[];
  List<ClinicianData> clinicianList = <ClinicianData>[];
  List<String> hospitalSiteUnitList = [];
  List<String> rotationList = [];
  CourseTopicListData selectedValue = new CourseTopicListData();
  CourseTopicListData selectedCourseValue = new CourseTopicListData();
  RotationForEvalListData selectedRotationValue = new RotationForEvalListData();
  ClinicianData selectedClinicianValue = new ClinicianData();

  ///Selected rotation
  String selectedRotation = '';
  int selectedIsActiveHospital = 0;
  String selectedClinicalInstructor = '';
  String selectCourseTopic = '';
  String selectAllCourseTopic = '';
  String selectedHospitalSiteUnit = '';
  String hospitalUnitId = '';
  String isActiveHospitalsite = '';
  String texts = '';
  String? hintString = 'Select course topic';

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  searchAllCourseTopic(String text) {
    if (text.isNotEmpty) {
      usedCourseTopicList = <CourseTopicListData>[];
      // usedCourseTopicList = <CourseTopicListData>[];
      // log("Search--------------${text}");
      for (int i = 0; i < allUsedCourseTopicData.length; i++) {
        if (allUsedCourseTopicData[i]
            .title!
            .toLowerCase()
            .contains(text.toLowerCase())) {
          usedCourseTopicList.add(allUsedCourseTopicData[i]);
        }
      }
    } else {
      // log("Search--------------${text}");
      usedCourseTopicList = <CourseTopicListData>[];
      usedCourseTopicList.addAll(allUsedCourseTopicData);
    }
    setState(() {});
  }

  searchCourseTopic(String coursetext) {
    if (coursetext.isNotEmpty) {
      singleCourseTopicList = <CourseTopicListData>[];
      singleCourseTopicList.clear();
      // log("Search--------------${coursetext}");
      for (int i = 0; i < singleCourseTopicData.length; i++) {
        if (singleCourseTopicData[i]
            .title!
            .toLowerCase()
            .contains(coursetext.toLowerCase())) {
          singleCourseTopicList.add(singleCourseTopicData[i]);
        }
      }
    } else {
      singleCourseTopicList.clear();
      // log("Search--------------${coursetext}");
      singleCourseTopicList = <CourseTopicListData>[];
      singleCourseTopicList.addAll(singleCourseTopicData);
    }
    setState(() {});
  }

  Future<void> getAllCourseTopicList() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getAllCourseTopicList(
      box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      box.get(Hardcoded.hiveBoxKey)!.accessToken,
    );
    CourseTopicListModel courseTopicListModel =
        CourseTopicListModel.fromJson(dataResponseModel.data);
    setState(() {
      // courseTopicListModel = CourseTopicListData.fromJson(dataResponseModel.data);
      usedCourseTopicList = courseTopicListModel.data!;
      allUsedCourseTopicData = courseTopicListModel.data!;
      // announcementList.clear();
    });
    // log("${dataResponseModel.data}");
  }

  Future<void> getCourseTopicList() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getCourseTopicList(
      box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      box.get(Hardcoded.hiveBoxKey)!.accessToken,
      selectedRotationValue.rotationId.toString(),
    );
    CourseTopicListModel courseTopicListModel =
        CourseTopicListModel.fromJson(dataResponseModel.data);
    setState(() {
      // courseTopicListModel = CourseTopicListData.fromJson(dataResponseModel.data);
      singleCourseTopicList = courseTopicListModel.data!;
      singleCourseTopicData = courseTopicListModel.data!;
      // announcementList.clear();
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
      selectedRotationValue.rotationId.toString(),
    );
    ClinicianDataList clinicianDataList =
        ClinicianDataList.fromJson(dataResponseModel.data);
    setState(() {
      // courseTopicListModel = CourseTopicListData.fromJson(dataResponseModel.data);
      clinicianList = clinicianDataList.data!;
      // allUsedCourseTopicData = courseTopicListModel.data!;
    });
    // log("${dataResponseModel.data}");
  }

  @override
  void initState() {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    setState(() {
      store.dispatch(
          GetClinicianListAction(rotationId: widget.rotation.rotationId));
      store.dispatch(GetAllCourseTopicListAction());
      getAllCourseTopicList();
      getCourseTopicList();
      getClinicianNameList();
      store.dispatch(GetRotationForEvalListAction(
          isAdvanceCheckoff:
              box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Advanced"
                  ? "true"
                  : "false"));
      rotationEvalList = widget.rotationForEvalListModel.data!;
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
        checkoffDateController.text =
            DateFormat('MM-dd-yyyy').format(interactionDate);
      });
    }
  }

  RotationForEvalListModel rotationForEvalList =
      RotationForEvalListModel(data: []);
  List<String> rotationsList = [];

  final checkoffDateFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final phoneNumber1FocusNode = FocusNode();
  final phoneNumber2FocusNode = FocusNode();
  final phoneNumber3FocusNode = FocusNode();
  final phoneNumber4FocusNode = FocusNode();
  final phoneNumber5FocusNode = FocusNode();
  final searchFocusNode = FocusNode();
  final allSearchFocusNode = FocusNode();
  final searchClinicianFocusNode = FocusNode();
  bool isEnable = false;

  @override
  Widget build(BuildContext context) {
    rotationEvalList = widget.rotationForEvalListModel.data!;
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    return Scaffold(
      backgroundColor: Color(Hardcoded.white),
      appBar: CommonAppBar(
        title: 'Create Checkoff',
      ),
      bottomNavigationBar: BottomAppBar(
        height: globalHeight * 0.085,
        // color: Colors.amber,
        elevation: 0,
        child: CommonRoundedLoadingButton(
          controller: save,
          width: globalWidth * 0.9,
          title: 'Create Checkoff',
          textcolor: Colors.white,
          onTap: () async {
            Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
            final DataService dataService = locator();
            late DataResponseModel dataResponseModel;
            if (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                "Advanced") {
              if (validationsForAdvanced()) {
                DateTime checkoffDate =
                    DateFormat("MM-dd-yyyy").parse(checkoffDateController.text);
                String checkoffdate =
                    DateFormat("yyyy-MM-dd").format(checkoffDate);
                CreateCheckoffRequestRequest request =
                    CreateCheckoffRequestRequest(
                  accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
                  userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                  RotationId: selectedRotationValue.rotationId.toString(),
                  checkoffDate: checkoffdate.toString(),
                  clinicianId: selectedClinicianValue.clinicianId.toString(),
                  hospitalSiteId: hospitalUnitId,
                  isActiveHospitalsite: selectedIsActiveHospital.toString(),
                  preceptorMobile1: phoneNumber1Controller.text,
                  preceptorMobile2: phoneNumber2Controller.text,
                  preceptorMobile3: phoneNumber3Controller.text,
                  preceptorMobile4: phoneNumber4Controller.text,
                  preceptorMobile5: phoneNumber5Controller.text,
                  topicId: selectCourseTopic.isEmpty
                      ? selectedValue.topicId.toString()
                      : selectedCourseValue.topicId.toString(),
                );
                log("${selectedIsActiveHospital.toString()}");
                dataResponseModel = await dataService.createCheckoff(request);
              } else {
                save.error();
                Future.delayed(Duration(seconds: 2), () {
                  save.reset();
                });
              }
            } else {
              if (validationsForStandard()) {
                DateTime checkoffDate =
                    DateFormat("MM-dd-yyyy").parse(checkoffDateController.text);
                String checkoffdate =
                    DateFormat("yyyy-MM-dd").format(checkoffDate);
                CreateCheckoffRequestRequest request =
                    CreateCheckoffRequestRequest(
                  accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
                  userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                  RotationId: selectedRotationValue.rotationId.toString(),
                  checkoffDate: checkoffdate.toString(),
                  clinicianId: selectedClinicianValue.clinicianId.toString(),
                  hospitalSiteId: hospitalUnitId,
                  isActiveHospitalsite: selectedIsActiveHospital.toString(),
                  standardPreceptorMob: phoneNumberController.text,
                  topicId: selectCourseTopic.isEmpty
                      ? selectedValue.topicId.toString()
                      : selectedCourseValue.topicId.toString(),
                );
                log("${selectedIsActiveHospital.toString()}");
                dataResponseModel = await dataService.createCheckoff(request);
              } else {
                save.error();
                Future.delayed(Duration(seconds: 2), () {
                  save.reset();
                });
              }
            }
            if (dataResponseModel.status == 200) {
              save.success();
              Navigator.pop(context);
              common_alert_pop(
                  context,
                  'Successfully created\nCheckoff and SMS has been sent.',
                  'assets/images/success_Icon.svg',
                  () {});
            } else {
              save.error();
              AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
            }
            FocusScope.of(context).unfocus();
          },
          color: Color(Hardcoded.primaryGreen),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5.0, left: 20, right: 20, bottom: 15),
        child: SingleChildScrollView(
          child: Stack(children: [
            Column(
              children: [
                SizedBox(
                  height: 103,
                ),

                ///interaction date
                GestureDetector(
                  child: CommonTextfield(
                    inputText: "Checkoff Date",
                    autoFocus: false,
                    hintText: 'Checkoff date',
                    readOnly: true,
                    textEditingController: checkoffDateController,
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
                SizedBox(
                    height: selectedRotation.isEmpty
                        ? 93
                        : clinicianList.isEmpty
                            ? 275
                            : 373
                    // height: selectedRotation.isNotEmpty ? 373 :93 ,
                    ),
                SizedBox(
                  height: 10,
                ),

                box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                        "Advanced"
                    ?
                    // Visibility(visible: selectedRotation.isNotEmpty && selectedIsActive == 0, child:
                    selectedIsActiveHospital == 0
                        ? Column(
                            children: [
                              Material(
                                color: Colors.white,
                                child: IOSKeyboardAction(
                                  label: 'DONE',
                                  focusNode: phoneNumber1FocusNode,
                                  focusActionType: FocusActionType.done,
                                  onTap: () {},
                                  child: CommonTextfield(
                                    inputText: "Preceptor 1 Phone Number",
                                    autoFocus: false,
                                    focusNode: phoneNumber1FocusNode,
                                    hintText: '123-456-7812',
                                    textEditingController:
                                        phoneNumber1Controller,
                                    readOnly: false,
                                    keyboardType: TextInputType.number,
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
                                  focusNode: phoneNumber2FocusNode,
                                  focusActionType: FocusActionType.done,
                                  onTap: () {},
                                  child: CommonTextfield(
                                    inputText: "Preceptor 2 Phone Number",
                                    autoFocus: false,
                                    focusNode: phoneNumber2FocusNode,
                                    hintText: '123-456-7812',
                                    textEditingController:
                                        phoneNumber2Controller,
                                    readOnly: false,
                                    keyboardType: TextInputType.number,
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
                                  focusNode: phoneNumber3FocusNode,
                                  focusActionType: FocusActionType.done,
                                  onTap: () {},
                                  child: CommonTextfield(
                                    inputText: "Preceptor 3 Phone Number",
                                    autoFocus: false,
                                    focusNode: phoneNumber3FocusNode,
                                    hintText: '123-456-7812',
                                    textEditingController:
                                        phoneNumber3Controller,
                                    readOnly: false,
                                    keyboardType: TextInputType.number,
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
                                  focusNode: phoneNumber4FocusNode,
                                  focusActionType: FocusActionType.done,
                                  onTap: () {},
                                  child: CommonTextfield(
                                    inputText: "Preceptor 4 Phone Number",
                                    autoFocus: false,
                                    focusNode: phoneNumber4FocusNode,
                                    hintText: '123-456-7812',
                                    textEditingController:
                                        phoneNumber4Controller,
                                    readOnly: false,
                                    keyboardType: TextInputType.number,
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
                                  focusNode: phoneNumber5FocusNode,
                                  focusActionType: FocusActionType.done,
                                  onTap: () {},
                                  child: CommonTextfield(
                                    inputText: "Preceptor 5 Phone Number",
                                    autoFocus: false,
                                    focusNode: phoneNumber5FocusNode,
                                    hintText: '123-456-7812',
                                    textEditingController:
                                        phoneNumber5Controller,
                                    readOnly: false,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                            // ),
                          )
                        : SizedBox()
                    : Material(
                        color: Colors.white,
                        child: IOSKeyboardAction(
                          label: 'DONE',
                          focusNode: phoneNumberFocusNode,
                          focusActionType: FocusActionType.done,
                          onTap: () {},
                          child: CommonTextfield(
                            inputText: "Preceptor Phone Number",
                            autoFocus: false,
                            focusNode: phoneNumberFocusNode,
                            hintText: '123-456-7812',
                            textEditingController: phoneNumberController,
                            readOnly: false,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                SizedBox(
                  height: Platform.isIOS ? globalHeight * 0.05 : 10,
                ),
              ],
            ),
            Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: clinicianList.isNotEmpty ? 475 : 380),
                    Visibility(
                      visible: selectedRotation.isNotEmpty,
                      child: Material(
                        color: Colors.white,
                        child: IOSKeyboardAction(
                          label: 'DONE',
                          focusNode: phoneNumber2FocusNode,
                          focusActionType: FocusActionType.done,
                          onTap: () {},
                          child: CommonTextfield(
                            inputText: "Hospital Site",
                            autoFocus: false,
                            focusNode: phoneNumber2FocusNode,
                            hintText: 'Hospital site',
                            textEditingController: hospitalSiteUnitControler,
                            readOnly: false,
                            enabled: false,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ),
                    // Expansion(
                    //   OnSelection: (String value) {
                    //     setState(() {
                    //       selectedHospitalSiteUnit = value;
                    //     });
                    //     // fetchStateList(getHospitalSiteUnitId().toString());
                    //   },
                    //   inputText: "Hospital Site Unit",
                    //   bodyList: hospitalSiteUnitList,
                    //   trailIcon: "",
                    //   hintText: selectedHospitalSiteUnit,
                    //   enabled: true,
                    // ),
                  ],
                )
              ],
            ),
            Visibility(
              visible: selectedRotation.isNotEmpty && clinicianList.isNotEmpty,
              replacement: Container(),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: selectedRotation.isNotEmpty ? 370 : 275),
                      ExpansionWidget<ClinicianData>(
                          inputText: "Clinician Name",
                          hintText: "Select clinician name",
                          textColor:
                              selectedClinicalInstructor.toString().isNotEmpty
                                  ? Colors.black
                                  : Color(Hardcoded.greyText),
                          // enabled: selectAllCourseTopic.toString().isEmpty
                          //     ? true
                          //     : false,
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
                              searchSingleCourse.text = '';
                              searchSingleCourse.clear();
                              // searchCourseTopic("");
                            });
                            // log("id---------${selectedClinicianValue.clinicianId}");
                            // log("${selectedClinicianValue.clinicianId} ===== ${selectedClinicianValue.title}");
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
                                          // color: selectedClinicianValue.title == item.title! &&  item.title! != "All" ? Color(Hardcoded.primaryGreen):Colors.black,
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
                      //   trailIcon: "",
                      //   hintText: "Select clinician name",
                      //   enabled: true,
                      // ),
                    ],
                  )
                ],
              ),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: selectedRotation.isNotEmpty ? 275 : 180,
                    ),
                    // Expansion(
                    //   OnSelection: (String value) {
                    //     setState(() {
                    //       selectAllCourseTopic = value;
                    //       searchQuery.clear();
                    //      log("id---------${getAllCourseTopicID().toString()}");
                    //     });
                    //   },
                    //   inputText: "All Topics",
                    //   bodyList: allCourseTopicList,
                    //   trailIcon: "",
                    //   hintText: "Select topic",
                    //   isSearch: true,
                    //   searchWidget: Padding(
                    //     padding: EdgeInsets.only(
                    //       top: 5,
                    //     ),
                    //     child: Material(
                    //       color: Colors.white,
                    //       child: IOSKeyboardAction(
                    //         label: 'DONE',
                    //         focusNode: searchFocusNode,
                    //         focusActionType: FocusActionType.done,
                    //         onTap: () {},
                    //         child: CommonSearchTextfield(
                    //           focusNode: searchFocusNode,
                    //           hintText: 'Search here',
                    //           textEditingController: searchQuery,
                    //           fillColor: Color(0x1413AD5D),
                    //           sufix: Container(
                    //             transform:
                    //                 Matrix4.translationValues(0.0, 0.0, 0.0),
                    //             child: GestureDetector(
                    //               onTap: () {
                    //                 searchQuery.text = '';
                    //                 searchQuery.clear();
                    //                 searchDocument("");
                    //                 FocusManager.instance.primaryFocus!
                    //                     .unfocus();
                    //               },
                    //               child: const Icon(
                    //                 Icons.clear,
                    //                 color: Color.fromARGB(255, 98, 105, 121),
                    //               ),
                    //             ),
                    //           ),
                    //           onChanged: (String text) {
                    //             // setState(() {
                    //               searchDocument(text);
                    //               // log("Search--------------${text}");
                    //             // });
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   // hintText: selectAllCourseTopic,
                    //   enabled:
                    //       selectCourseTopic.toString().isEmpty ? true : false,
                    // ),
                    // SizedBox(
                    //   height: selectedRotation.isNotEmpty ? 275 : 180,
                    // ),
                    ExpansionWidget<CourseTopicListData>(
                        inputText: "All Topics",
                        hintText: "Select topic",
                        enabled:
                            selectCourseTopic.toString().isEmpty ? true : false,
                        textColor: selectAllCourseTopic.toString().isNotEmpty
                            ? Colors.black
                            : Color(Hardcoded.greyText),
                        isSearch: true,
                        searchWidget: Padding(
                          padding: EdgeInsets.only(
                            top: 5,
                          ),
                          child: Material(
                            color: Colors.white,
                            child: CommonSearchTextfield(
                              focusNode: allSearchFocusNode,
                              hintText: 'Search here',
                              autoFocus: false,
                              textEditingController: searchAllCourse,
                              fillColor: Color(0x1413AD5D),
                              sufix: Container(
                                transform:
                                    Matrix4.translationValues(0.0, 0.0, 0.0),
                                child: GestureDetector(
                                  onTap: () {
                                    searchAllCourse.text = '';
                                    searchAllCourse.clear();
                                    searchAllCourseTopic("");
                                    // FocusManager.instance.primaryFocus!
                                    //     .unfocus();
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: Color.fromARGB(255, 98, 105, 121),
                                  ),
                                ),
                              ),
                              onChanged: (String text) {
                                setState(() {
                                  searchAllCourseTopic(text);
                                });
                              },
                            ),
                          ),
                        ),
                        OnSelection: (value) {
                          setState(() {
                            CourseTopicListData c =
                                value as CourseTopicListData;
                            selectedValue = c;
                            selectAllCourseTopic = selectedValue.title!;
                            searchAllCourse.text = '';
                            searchAllCourse.clear();
                            searchAllCourseTopic("");
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          });
                          // log("id---------${selectedValue.topicId}");
                          // log("Course Topic --- ${selectedValue.topicId} ===== ${selectedValue.title}");
                        },
                        items: List.of(usedCourseTopicList.map(
                          (item) => DropdownItem<CourseTopicListData>(
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
                  ],
                )
              ],
            ),
            Visibility(
              visible: selectedRotation.isNotEmpty,
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 180),
                      ExpansionWidget<CourseTopicListData>(
                          inputText: "Course Topics",
                          hintText: "Select course topic",
                          enabled: selectAllCourseTopic.toString().isEmpty
                              ? true
                              : false,
                          textColor: selectCourseTopic.toString().isNotEmpty
                              ? Colors.black
                              : Color(Hardcoded.greyText),
                          isSearch: true,
                          searchWidget: Padding(
                            padding: EdgeInsets.only(
                              top: 5,
                            ),
                            child: Material(
                              color: Colors.white,
                              child: CommonSearchTextfield(
                                focusNode: searchFocusNode,
                                hintText: 'Search here',
                                autoFocus: false,
                                textEditingController: searchSingleCourse,
                                fillColor: Color(0x1413AD5D),
                                sufix: Container(
                                  transform:
                                      Matrix4.translationValues(0.0, 0.0, 0.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      searchSingleCourse.text = '';
                                      searchSingleCourse.clear();
                                      searchCourseTopic("");
                                      // FocusManager.instance.primaryFocus!
                                      //     .unfocus();
                                    },
                                    child: Icon(
                                      Icons.clear,
                                      color: Color.fromARGB(255, 98, 105, 121),
                                    ),
                                  ),
                                ),
                                onChanged: (String coursetext) {
                                  searchCourseTopic(coursetext);
                                },
                              ),
                            ),
                          ),
                          OnSelection: (value) {
                            setState(() {
                              CourseTopicListData c =
                                  value as CourseTopicListData;
                              selectedCourseValue = c;
                              selectCourseTopic = selectedCourseValue.title!;
                              searchSingleCourse.text = '';
                              searchSingleCourse.clear();
                              // searchCourseTopic("");
                            });
                            // log("id---------${selectedCourseValue.topicId}");
                            // log("Course Topic --- ${selectedCourseValue.topicId} ===== ${selectedCourseValue.title}");
                          },
                          items: List.of(singleCourseTopicList.map(
                            (item) => DropdownItem<CourseTopicListData>(
                              value: item,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                      //       selectCourseTopic = value;
                      //     });
                      //   },
                      //   inputText: "Course Topic",
                      //   bodyList: courseTopicList,
                      //   trailIcon: "",
                      //   hintText: hintString!,
                      //   // hintText: "Select course topic",
                      //   enabled: selectAllCourseTopic.toString().isEmpty
                      //       ? true
                      //       : false,
                      // ),
                    ],
                  )
                ],
              ),
            ),
            Stack(
              children: [
                Column(
                  children: [
                    ExpansionWidget<RotationForEvalListData>(
                        inputText: "Rotation",
                        hintText: "Select rotation",
                        // enabled: selectAllCourseTopic.toString().isEmpty
                        //     ? true
                        //     : false,
                        textColor: selectedRotation.toString().isNotEmpty
                            ? Colors.black
                            : Color(Hardcoded.greyText),
                        OnSelection: (value) {
                          setState(() {
                            RotationForEvalListData c =
                                value as RotationForEvalListData;
                            selectedRotationValue = c;
                            // singleCourseTopicList.clear();
                            getCourseTopicList();
                            getClinicianNameList();
                            store.dispatch(GetClinicianListAction(
                                rotationId: selectedRotationValue.rotationId!));
                            store.dispatch(GetCourseTopicListAction(
                                rotationId: selectedRotationValue.rotationId!));
                            // getRotationID(selectedRotation).toString()));
                            selectedRotation = selectedRotationValue.title!;
                            selectedIsActiveHospital =
                                selectedRotationValue.isActiveHospitalsite!;
                            hospitalSiteUnitControler.text =
                                selectedRotationValue.hospitalTitle!.toString();
                            hospitalUnitId =
                                selectedRotationValue.hospitalId.toString();
                            isActiveHospitalsite = selectedRotationValue
                                .isActiveHospitalsite
                                .toString();
                            widget.courseTopicListModel.data;
                          });
                          // log("id---------${selectedRotationValue.rotationId}");
                          // log("hospitalId---------${selectedRotationValue.hospitalId.toString()}");
                        },
                        items: List.of(rotationEvalList.map((item) {
                          String text = item.title.toString();
                          List<String> title = text.split("(");
                          String subText = title[1].toString();
                          List<String> subTitle = subText.split(")");
                          return DropdownItem<RotationForEvalListData>(
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
                                              .titleLarge
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
                    //       getClinicanNameList();
                    //       store.dispatch(GetCourseTopicListAction(
                    //           rotationId:
                    //               getRotationID(selectedRotation).toString()));
                    //       // getCourseTopicList();
                    //       widget.courseTopicListModel.data;
                    //       // selectedHospitalSiteUnit = selectedRotation.las
                    //     });
                    //   },
                    //   inputText: "Rotation",
                    //   isSubString: true,
                    //   bodyList: rotationList,
                    //   trailIcon: "",
                    //   hintText: "Select rotation",
                    //   enabled: true,
                    // ),
                  ],
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  bool validationsForStandard() {
    if (selectedRotation.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select rotation");
      return false;
    }
    if (checkoffDateController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter checkoff date");
      return false;
    }
    if (selectAllCourseTopic.isEmpty) {
      if (selectCourseTopic.isEmpty) {
        AppHelper.buildErrorSnackbar(context, "Please select course topic");
        return false;
      }
    }
    if (selectCourseTopic.isEmpty) {
      if (selectAllCourseTopic.isEmpty) {
        AppHelper.buildErrorSnackbar(context, "Please select topic");
        return false;
      }
    }
    if (phoneNumberController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(
          context, "Please enter preceptor phone number");
      return false;
    }
    if (phoneNumberController.text.length < 12) {
      AppHelper.buildErrorSnackbar(
          context, "Please enter valid preceptor phone number");
      return false;
    }
    return true;
  }

  bool validationsForAdvanced() {
    if (selectedRotation.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select rotation");
      return false;
    }
    if (checkoffDateController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter checkoff date");
      return false;
    }
    if (selectAllCourseTopic.isEmpty) {
      if (selectCourseTopic.isEmpty) {
        AppHelper.buildErrorSnackbar(context, "Please select course topic");
        return false;
      }
    }
    if (selectCourseTopic.isEmpty) {
      if (selectAllCourseTopic.isEmpty) {
        AppHelper.buildErrorSnackbar(context, "Please select topic");
        return false;
      }
    }
    if (selectedIsActiveHospital == 1) {
      if (selectedClinicalInstructor.isEmpty) {
        AppHelper.buildErrorSnackbar(context, "Please select clinician name");
        return false;
      }
    }
    if (selectedIsActiveHospital == 0) {
      if (phoneNumber1Controller.text.isEmpty) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter preceptor 1 phone number");
        return false;
      }
      if (phoneNumber1Controller.text.length < 12) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter valid preceptor 1 phone number");
        return false;
      }
      if (phoneNumber2Controller.text.isEmpty) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter preceptor 2 phone number");
        return false;
      }
      if (phoneNumber2Controller.text.length < 12) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter valid preceptor 2 phone number");
        return false;
      }
      if (phoneNumber3Controller.text.isEmpty) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter preceptor 3 phone number");
        return false;
      }
      if (phoneNumber3Controller.text.length < 12) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter valid preceptor 3 phone number");
        return false;
      }
      if (phoneNumber4Controller.text.isEmpty) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter preceptor 4 phone number");
        return false;
      }
      if (phoneNumber4Controller.text.length < 12) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter valid preceptor 4 phone number");
        return false;
      }
      if (phoneNumber5Controller.text.isEmpty) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter preceptor 5 phone number");
        return false;
      }
      if (phoneNumber5Controller.text.length < 12) {
        AppHelper.buildErrorSnackbar(
            context, "Please enter valid preceptor 5 phone number");
        return false;
      }
    }
    return true;
  }
}
