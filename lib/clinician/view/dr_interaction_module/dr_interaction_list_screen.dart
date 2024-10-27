import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/common_widgets/user_dr_interaction_container_widget.dart';
import 'package:clinicaltrac/clinician/model/clinician_rotation_list_model.dart';
import 'package:clinicaltrac/clinician/model/dropdown_models/student_dropdown_list_model.dart';
import 'package:clinicaltrac/clinician/model/user_daily_journal_list_model.dart';
import 'package:clinicaltrac/clinician/model/user_dr_interaction_list_model.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/clinician/view/daily_journal_module/edit_daily_journal_screen.dart';
import 'package:clinicaltrac/clinician/view/daily_journal_module/view_daily_journal_details_screen.dart';
import 'package:clinicaltrac/clinician/view/dr_interaction_module/edit_dr_interaction_screen.dart';
import 'package:clinicaltrac/clinician/view/dr_interaction_module/view_dr_interaction_dtails_screen.dart';
import 'package:clinicaltrac/clinician/view/login_screen/login_bottom_widget.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_green_rotation.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class DrInteractionListScreen extends StatefulWidget {
  DrInteractionListScreen({
    required this.route,
    this.rotationDetailListData,
    super.key,
  });

  DailyJournalRoute route;
  ClinicianRotationDetailListData? rotationDetailListData;

  @override
  State<DrInteractionListScreen> createState() =>
      _DrInteractionListScreenState();
}

class _DrInteractionListScreenState extends State<DrInteractionListScreen> {
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;

// is search button of appbar is click
  bool isSearchClicked = false;
  bool isDataLoaded = true;
  TextEditingController searchEditingController = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  List<String> courseNameList = [];
  List<UserDrInteractionListData> drInteractionListData = [];
  UserDrInteractionData userDrInteractionData = UserDrInteractionData();
  String selectedStudent = '';
  String selectedStudentId = '';
  String courseHintText = 'All';
  bool isResetCombo = false;
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
  List<StudentDropdownData> studentDropdownData = <StudentDropdownData>[];
  StudentDropdownData selectedStudentValue = new StudentDropdownData();
  StudentDropdownListModel studentDropdownListModel =
      StudentDropdownListModel(data: []);

  Future<void> studentListData() async {
    UserDatRepo userDatRepo = UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    CommonRequest request = CommonRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      userType: AppConsts.userType,
    );
    return userDatRepo.studentDropdownList(request,
        (StudentDropdownListModel studentDropdownListModel) {
      setState(() {
        studentDropdownData = studentDropdownListModel.data;
      });
      return null;
    }, () {}, context);
  }

  void getDrInteractionListData() async {
    UserDatRepo userDatRepo = UserDatRepo();

    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      CommonRequest request = CommonRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        userType: AppConsts.userType,
        roleType: box.get(Hardcoded.hiveBoxKey)!.loggedUserRoleType,
        RotationId: widget.route == DailyJournalRoute.direct
            ? ""
            : widget.rotationDetailListData!.rotationId!,
        fromDate:
            fromDate.text.isEmpty ? "" : DateFormat('yyyy-MM-dd').format(from),
        todate: toDate.text.isEmpty ? "" : DateFormat('yyyy-MM-dd').format(to),
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        title: searchEditingController.text,
        studentId: selectedStudentId,
      );
      return userDatRepo.drInteractionList(request,
          (UserDrInteractionListModel userDrInteractionListModel) {
        lastpage =
            (int.parse(userDrInteractionListModel.pager!.totalRecords!) / 10)
                .ceil();
        if (userDrInteractionListModel.pager!.totalRecords == '0') {
          setState(() {
            datanotFound = true;
          });
        } else {
          setState(() {
            datanotFound = false;
          });
        }
        setState(() {
          if (pageNo != 1) {
            drInteractionListData
                .addAll(userDrInteractionListModel.data!.interactionList!);
          } else {
            drInteractionListData =
                userDrInteractionListModel.data!.interactionList!;
            userDrInteractionData = userDrInteractionListModel.data!;
          }
          isDataLoaded = false;
        });
      }, () {}, context);
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;
      getDrInteractionListData();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    studentListData();
    getDrInteractionListData();

    super.initState();
    _scrollController.addListener(_scrollListener);
    // rotationEvalList = widget.rotationListStudentJournal.data!;
  }

  Future<void> pullToRefresh() async {
    // isDataLoaded = true;
    pageNo = 1;
    getDrInteractionListData();
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();
  final fromDateFocusNode = FocusNode();
  final toDateFocusNode = FocusNode();

  DateTime convertDateToUTC(String dateUtc) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
    var formattedTime = dateTime.toLocal();
    return formattedTime;
  }

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return '${formattedDate} ';
  }

  List<Color> initialColor = [
    Color(Hardcoded.orange),
    Color(Hardcoded.blue),
    Color(Hardcoded.pink)
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // widget.route == DailyJournalRoute.rotation
        //     ?  Navigator.pop(context):Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
        //     arguments: BodySwitcherData(
        //         initialPage: Bottom_navigation_control.home));
        return Future.value(true);
      },
      child: Scaffold(
          appBar: CommonAppBar(
            titles: isSearchClicked
                ? Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                    ),
                    child: Material(
                      color: Colors.white,
                      child: IOSKeyboardAction(
                        label: 'DONE',
                        focusNode: searchFocusNode,
                        focusActionType: FocusActionType.done,
                        onTap: () {},
                        child: CommonSearchTextfield(
                          focusNode: searchFocusNode,
                          hintText: 'Search',
                          textEditingController: searchEditingController,
                          onChanged: (value) {
                            pageNo = 1;
                            getDrInteractionListData();
                          },
                        ),
                      ),
                    ),
                  )
                : Text("Dr. Interaction",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        )),
            searchEnabeled: true,
            onTap: () {
              Navigator.pop(context);
              // widget.route == DailyJournalRoute.rotation
              //     ?  Navigator.pop(context):  Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
              //     arguments: BodySwitcherData(
              //         initialPage: Bottom_navigation_control.home));
            },
            image: !isSearchClicked
                ? SvgPicture.asset(
                    'assets/images/search.svg',
                  )
                : SvgPicture.asset(
                    'assets/images/closeicon.svg',
                  ),
            onSearchTap: () {
              setState(() {
                isSearchClicked = !isSearchClicked;
                searchEditingController.text = '';
                FocusScope.of(context).unfocus();
                if (isSearchClicked == false) getDrInteractionListData();
              });
            },
          ),
          backgroundColor: Color(Hardcoded.white),
          body:
              // items.length != 1 ?
              widget.route == DailyJournalRoute.direct
                  // AppConsts.isFromDashboard == false
                  ? Stack(
                      children: [
                      Padding(
                        padding: EdgeInsets.only(left: 17, right: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ExpansionWidget<StudentDropdownData>(
                                hintText: selectedStudentValue.title != "All"
                                    ? "All"
                                    : '',
                                // enabled: selectAllCourseTopic.toString().isEmpty
                                //     ? true
                                //     : false,
                                textColor: Colors.black,
                                OnSelection: (value) {
                                  setState(() {
                                    StudentDropdownData c =
                                        value as StudentDropdownData;
                                    selectedStudentValue = c;
                                    // singleCourseTopicList.clear();
                                    selectedStudentId = selectedStudentValue
                                        .studentId
                                        .toString();
                                    selectedStudent =
                                        selectedStudentValue.title.toString();
                                    pageNo = 1;
                                    searchEditingController.text = '';
                                    isSearchClicked = false;
                                    getDrInteractionListData();
                                  });
                                  // log("id---------${selectedStudentValue.studentId}");
                                },
                                items: List.of(
                                  studentDropdownData.map(
                                    (item) {
                                      String text = item.title.toString();
                                      return DropdownItem<StudentDropdownData>(
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                            ),
                            // Padding(
                            //   padding:  EdgeInsets.only(left: 2,top: 0.013.sh),
                            //   child: Container(
                            //     height: 0.07.sh,
                            //     width: 0.08.sw,
                            //     color: Colors.white,
                            //     child: GestureDetector(
                            //       onTap: (){
                            //         DropDownState(
                            //           DropDown(
                            //             isDismissible: true,
                            //             bottomSheetTitle: const Text(
                            //               "Select Course",
                            //               style: TextStyle(
                            //                 fontWeight: FontWeight.bold,
                            //                 fontSize: 20.0,
                            //               ),
                            //             ),
                            //             submitButtonChild: const Text(
                            //               'Done',
                            //               style: TextStyle(
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.bold,
                            //               ),
                            //             ),
                            //             data: rankDropdownData ?? [],
                            //             selectedItems: (List<dynamic> selectedList) {
                            //               List<String> list = [];
                            //               for (var item in selectedList) {
                            //                 if (item is SelectedListItem) {
                            //                   list.add(item.name);
                            //                 }
                            //               }
                            //               log(list.toString());
                            //             },
                            //             // enableMultipleSelection: false,
                            //           ),
                            //         ).showModal(context);
                            //       },
                            //       child: SvgPicture.asset(
                            //         'assets/images/filter.svg',
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        // child: CommonExpansion(
                        //   OnSelection: (String value) {
                        //     setState(() {
                        //       isResetCombo = false;
                        //       courseHintText = value;
                        //       isSearchClicked = false;
                        //     });
                        //     store.dispatch(
                        //       FilterRotationListByCourseList(
                        //           active_status:
                        //               commonTypeList[_selectedIndex].type,
                        //           courseId: getCourseIdByName(value),
                        //           searchText: ''),
                        //     );
                        //     getRotationListData();
                        //   },
                        //   bodyList: courseNameList,
                        //   trailIcon: "",
                        //   hintText: courseHintText,
                        //   isReset: isResetCombo,
                        //   decoration: BoxDecoration(
                        //     color: Color(Hardcoded.textFieldBg),
                        //     borderRadius: BorderRadius.circular(12),
                        //     // border: Border.all(color: Colors.transparent),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black12,
                        //         offset: const Offset(
                        //           0.0,
                        //           5.0,
                        //         ),
                        //         blurRadius: 7.0,
                        //         spreadRadius: 2.0,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: ExpansionWidget<RotationJournalData>(
                      //     hintText:
                      //     selectedRotationValue.title != "All" ? "All" : '',
                      //     // enabled: selectAllCourseTopic.toString().isEmpty
                      //     //     ? true
                      //     //     : false,
                      //     textColor: selectedRotation.toString().isNotEmpty
                      //         ? Colors.black
                      //         : Color(Hardcoded.greyText),
                      //     OnSelection: (value) {
                      //       setState(() {
                      //         RotationJournalData c =
                      //         value as RotationJournalData;
                      //         selectedRotationValue = c;
                      //         // singleCourseTopicList.clear();
                      //         selectedRotation = selectedRotationValue.title;
                      //         selectedRotationId =
                      //             selectedRotationValue.rotationId;
                      //         pageNo = 1;
                      //         searchQuery.text = '';
                      //         isSearchClicked = false;
                      //         getJournalList();
                      //       });
                      //       // log("id---------${selectedRotationValue.rotationId}");
                      //     },
                      //     items: List.of(rotationEvalList.map((item) {
                      //       String text = item.title.toString();
                      //       List<String> title = text.split("(");
                      //       String subText = title[0].toString() == "All"
                      //           ? title[0]
                      //           : title[1].toString();
                      //       List<String> subTitle = subText.split(")");
                      //       return DropdownItem<RotationJournalData>(
                      //         value: item,
                      //         child: Padding(
                      //             padding: EdgeInsets.only(
                      //                 top: 8.0,
                      //                 left: globalWidth * 0.06,
                      //                 right: globalWidth * 0.06,
                      //                 bottom: 8.0),
                      //             child: Column(
                      //                 crossAxisAlignment:
                      //                 CrossAxisAlignment.start,
                      //                 children: [
                      //                   Text(
                      //                     title[0],
                      //                     maxLines: 1,
                      //                     overflow: TextOverflow.ellipsis,
                      //                     style: Theme.of(context)
                      //                         .textTheme
                      //                         .bodyMedium!
                      //                         .copyWith(
                      //                       fontWeight: FontWeight.w500,
                      //                       fontSize: 14,
                      //                       color: Colors.black,
                      //                     ),
                      //                   ),
                      //                   subTitle[0] != "All" && title[0] != "All"
                      //                       ? Text(subTitle[0],
                      //                       // widget.hintText,
                      //                       maxLines: 1,
                      //                       overflow: TextOverflow.ellipsis,
                      //                       style: Theme.of(context)
                      //                           .textTheme
                      //                           .titleLarge
                      //                           ?.copyWith(
                      //                           fontWeight:
                      //                           FontWeight.w400,
                      //                           fontSize: 14,
                      //                           color: Color(
                      //                               Hardcoded.greyText)))
                      //                       : Container(),
                      //                 ])),
                      //       );
                      //     })),
                      //   ),
                      //   // child: CommonExpansion(
                      //   //   OnSelection: (String value) {
                      //   //     setState(() {
                      //   //       selectedRotation = value;
                      //   //       selectedRotationId = widget
                      //   //           .rotationListStudentJournal
                      //   //           .data[widget.rotationListStudentJournal.data
                      //   //               .indexWhere((element) =>
                      //   //                   element.title == selectedRotation)]
                      //   //           .rotationId;
                      //   //       pageNo = 1;
                      //   //       searchQuery.text = '';
                      //   //       isSearchClicked = false;
                      //   //       getJournalList();
                      //   //     });
                      //   //   },
                      //   //   bodyList: items,
                      //   //   trailIcon: "",
                      //   //   hintText: selectedRotation!,
                      //   //   decoration: BoxDecoration(
                      //   //     color: Color(Hardcoded.textFieldBg),
                      //   //     borderRadius: BorderRadius.circular(30),
                      //   //     // border: Border.all(color: Colors.transparent),
                      //   //     boxShadow: [
                      //   //       BoxShadow(
                      //   //         color: Colors.black12,
                      //   //         offset: const Offset(
                      //   //           0.0,
                      //   //           5.0,
                      //   //         ),
                      //   //         blurRadius: 7.0,
                      //   //         spreadRadius: 2.0,
                      //   //       ),
                      //   //     ],
                      //   //   ),
                      //   // ),
                      // ),
                      listModule(),
                    ].reversed.map((e) => e).toList())
                  : Column(children: [
                      common_green_rotation_card(
                        date:
                            "${DateFormat("dd").format(convertDateToUTC("${widget.rotationDetailListData!.startDate!}"))}",
                        month:
                            "${DateFormat("MMM").format(convertDateToUTC("${widget.rotationDetailListData!.startDate!}"))}",
                        text1:
                            "${widget.rotationDetailListData!.rotationName!}",
                        text2:
                            "${widget.rotationDetailListData!.hospitalName!}",
                        text3: "${widget.rotationDetailListData!.courseName!}",
                        Index: 0,
                      ),
                      Expanded(
                        child: listModule(),
                      ),
                    ])
          //   : Center(
          // child: Padding(
          //     padding: EdgeInsets.only(bottom: globalHeight * 0.1),
          //     child: NoDataFoundWidget(
          //       title: "Daily Journals not available",
          //       imagePath: "assets/no_data_found.png",
          //     )),
          // ),
          ),
    );
  }

  Padding listModule() {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.route == DailyJournalRoute.direct ? 70.0 : 0
          // AppConsts.isFromDashboard == false ? 50.0 : 0
          ),
      child: Visibility(
        visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
        child: common_loader(),
        replacement: Visibility(
          visible: datanotFound,
          child: isSearchClicked
              ? Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Container(
                      // width: double.infinity,
                      //height: 100,
                      child: Padding(
                          padding: EdgeInsets.only(
                              bottom: widget.route == DailyJournalRoute.direct
                                  ? 0
                                  : globalHeight * 0.02),
                          child: NoDataFoundWidget(
                            title: "No data found",
                            imagePath: "assets/no_data_found.png",
                          )),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Container(
                      // width: double.infinity,
                      //height: 100,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top:
                                  // globalHeight * 0.01
                                  // DailyJournalRoute.direct
                                  AppConsts.isFromDashboard == true
                                      ? globalHeight * 0.01
                                      : 0,
                              bottom: AppConsts.isFromDashboard == true
                                  ? globalHeight * 0.1
                                  : globalHeight * 0.15),
                          child: NoDataFoundWidget(
                            title: "Daily Journals not available",
                            imagePath: "assets/no_data_found.png",
                          )),
                    ),
                  ),
                ),
          replacement: Padding(
            padding: EdgeInsets.only(top: 10.0),
            // child: SlidableAutoCloseBehavior(
            child: RefreshIndicator(
              onRefresh: () => pullToRefresh(),
              color: Color(0xFFBBBBC6),
              child:
                  // SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(), child:
                  Container(
                decoration: const BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color.fromARGB(24, 203, 204, 208),
                      blurRadius: 35.0, // soften the shadow
                      spreadRadius: 10.0, //extend the shadow
                      offset: Offset(
                        15.0,
                        15.0,
                      ),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: CupertinoScrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: drInteractionListData.length,
                        controller: _scrollController,
                        //scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return UserDrInteractionContainerWidget(
                              // onTap: () {
                              //   setState(() {});
                              //   Navigator.pushNamed(
                              //     context,
                              //     Routes.addDrInteractionScreen,
                              //     arguments: AddViewDrIntgeractionData(
                              //         rotationId: widget.drIntraction.rotationId,
                              //         rotationTitle:
                              //             widget.drIntraction.rotationName,
                              //         drIntractionAction: DrIntractionAction.edit,
                              //         drIntraction: widget.drIntraction,
                              //         isFromDashboard: widget.isFromDashboard),
                              //   );
                              //   addNewInteractionAsPerPageChange();
                              // },
                              color: initialColor
                                  .elementAt(index % initialColor.length),
                              drInteractionListData:
                                  drInteractionListData[index],
                              isFromDashboard: false,
                              interactionDecCount: userDrInteractionData
                                  .interactionDescriptionCount!,
                              // pullToRefresh: addNewInteractionAsPerPageChange,
                              pullToRefresh: pullToRefresh,
                              onTapDelete: () {});
                          //   CommonListContainerWidget(
                          //   mainTitle:
                          //       drInteractionListData[index].studentFullName,
                          //   date:  "${DateFormat("dd").format(convertDateToUTC("${drInteractionListData[index].interactionDate!}"))}",
                          //   monthTitle:"${DateFormat("MMM").format(convertDateToUTC("${drInteractionListData[index].interactionDate!}"))}",
                          //   subTitle1: "Clinician : ",
                          //   score: drInteractionListData[index].pointsAwarded,
                          //   title1:
                          //       drInteractionListData[index].clinicianFullName,
                          //   // title1: "${dateConvert("${drInteractionListData[index].interactionDate!}")}",
                          //   subTitle2: "Rotation : ",
                          //   title2: drInteractionListData[index].rotationName,
                          //   subTitle3: "Hospital site units : ",
                          //   title3:
                          //       drInteractionListData[index].hospitalUnitName,
                          //   divider: Divider(
                          //     thickness: 1,
                          //   ),
                          //   subTitle7: "Time spent : ",
                          //   title7: drInteractionListData[index].timeSpent,
                          //   subTitle8: "Clinician sign : ",
                          //   title8: drInteractionListData[index]
                          //           .clinicianDate!
                          //           .toString()
                          //           .isNotEmpty
                          //       ? "${dateConvert("${drInteractionListData[index].clinicianDate!}")}"
                          //       : null,
                          //   subTitle12: "Clinician response : ",
                          //   title12: drInteractionListData[index]
                          //           .clinicianResponse!
                          //           .isNotEmpty
                          //       ? "Yes"
                          //       : "No",
                          //   subTitle13: "School sign : ",
                          //   title13: drInteractionListData[index]
                          //           .schoolDate!
                          //           .toString()
                          //           .isNotEmpty
                          //       ? "${dateConvert("${drInteractionListData[index].schoolDate!}")}"
                          //       : null,
                          //
                          //   btnSvgImage: drInteractionListData[index]
                          //           .clinicianDate!
                          //           .isEmpty
                          //       ? "assets/images/Edit.svg"
                          //       : "assets/images/eye.svg",
                          //   buttonTitle: drInteractionListData[index]
                          //           .clinicianDate!
                          //           .isEmpty
                          //       ? "Edit"
                          //       : "View",
                          //   navigateButton: drInteractionListData[index]
                          //           .clinicianDate!
                          //           .isEmpty
                          //       ? () async {
                          //           await Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //               builder: (context) =>
                          //                   EditDrInteractionScreen(
                          //                 userDrInteractionListData:
                          //                     drInteractionListData[index],
                          //                 interactionId:
                          //                     drInteractionListData[index]
                          //                         .interactionId!,
                          //                 interactionDecCount:
                          //                     userDrInteractionData
                          //                         .interactionDescriptionCount!,
                          //               ),
                          //             ),
                          //           );
                          //           setState(() {
                          //             pullToRefresh();
                          //           });
                          //         }
                          //       : () {
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     ViewDrInteractionDetailScreen(
                          //                       userDrInteractionListData:
                          //                           drInteractionListData[
                          //                               index],
                          //                       interactionId:
                          //                           drInteractionListData[index]
                          //                               .interactionId!,
                          //                     )),
                          //           );
                          //         },
                          // );
                        }),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
