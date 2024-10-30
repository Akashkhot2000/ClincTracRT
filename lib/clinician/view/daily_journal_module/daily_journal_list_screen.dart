import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/model/clinician_rotation_list_model.dart';
import 'package:clinicaltrac/clinician/model/dropdown_models/student_dropdown_list_model.dart';
import 'package:clinicaltrac/clinician/model/user_daily_journal_list_model.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/clinician/view/daily_journal_module/edit_daily_journal_screen.dart';
import 'package:clinicaltrac/clinician/view/daily_journal_module/view_daily_journal_details_screen.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class DailyJournalListScreen extends StatefulWidget {
   DailyJournalListScreen({
    required this.route,
     this.rotationDetailListData,
    super.key,
  });
  DailyJournalRoute route;
  ClinicianRotationDetailListData? rotationDetailListData;
  @override
  State<DailyJournalListScreen> createState() => _DailyJournalListScreenState();
}

class _DailyJournalListScreenState extends State<DailyJournalListScreen> {
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
  List<JournalListData> journalListData = [];
  JournalData journalData = JournalData();
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
  StudentDropdownListModel studentDropdownListModel = StudentDropdownListModel(data: []);

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

  void getDailyJournalListData() async {
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
        RotationId: widget.route == DailyJournalRoute
            .direct ? "": widget.rotationDetailListData!.rotationId!,
        fromDate:
            fromDate.text.isEmpty ? "" : DateFormat('yyyy-MM-dd').format(from),
        todate: toDate.text.isEmpty ? "" : DateFormat('yyyy-MM-dd').format(to),
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        title: searchEditingController.text,
        studentId: selectedStudentId,
      );
      return userDatRepo.dailyJournalList(request,
          (DailyJournalListModel dailyJournalListModel) {
        lastpage =
            (int.parse(dailyJournalListModel.pager!.totalRecords!) / 10).ceil();
        if (dailyJournalListModel.pager!.totalRecords == '0') {
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
            journalListData
                .addAll(dailyJournalListModel.data!.journalListData!);
          } else {
            journalListData = dailyJournalListModel.data!.journalListData!;
            journalData = dailyJournalListModel.data!;
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
      getDailyJournalListData();
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
    getDailyJournalListData();

    super.initState();
    _scrollController.addListener(_scrollListener);
    // rotationEvalList = widget.rotationListStudentJournal.data!;
  }

  Future<void> pullToRefresh() async {
    // isDataLoaded = true;
    pageNo = 1;
    getDailyJournalListData();
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
                            getDailyJournalListData();
                          },
                        ),
                      ),
                    ),
                  )
                : Text("Daily Journal",
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
                if (isSearchClicked == false) getDailyJournalListData();
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
                          padding: EdgeInsets.only(
                              left: 17, right: 17),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ExpansionWidget<StudentDropdownData>(
                                  hintText:
                                  selectedStudentValue.title != "All" ? "All" : '',
                                  // enabled: selectAllCourseTopic.toString().isEmpty
                                  //     ? true
                                  //     : false,
                                  textColor: Colors.black,
                                  OnSelection: (value) {
                                    setState(() {
                                      StudentDropdownData c = value as StudentDropdownData;
                                      selectedStudentValue = c;
                                      // singleCourseTopicList.clear();
                                      selectedStudentId =
                                          selectedStudentValue.studentId.toString();
                                      selectedStudent =
                                          selectedStudentValue.title.toString();
                                      pageNo = 1;
                                      searchEditingController.text = '';
                                      isSearchClicked = false;
                                      getDailyJournalListData();
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
                            ],),
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
                      //                           .headline6
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
                      dateModule(context),
                    ].reversed.map((e) => e).toList())
                  : Column(children: [
                      common_green_rotation_card(
                        date:"${DateFormat("dd").format(convertDateToUTC("${widget.rotationDetailListData!.startDate!}"))}",
                        month:
                        "${DateFormat("MMM").format(convertDateToUTC("${widget.rotationDetailListData!.startDate!}"))}",
                        text1: "${widget.rotationDetailListData!.rotationName!}",
                        text2: "${widget.rotationDetailListData!.hospitalName!}",
                        text3: "${widget.rotationDetailListData!.courseName!}",
                        Index: 0,
                      ),
                      dateModule(context),
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
      padding:
      EdgeInsets.only(top: widget.route == DailyJournalRoute.direct ? 130.0 : 0
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
                          padding: EdgeInsets.only(bottom:
                               widget.route == DailyJournalRoute.direct ? 0 : globalHeight * 0.02
                              ),
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
                        itemCount: journalListData.length,
                        controller: _scrollController,
                        //scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return CommonListContainerWidget(
                            mainTitle: journalListData[index].rotationName,
                            subTitle1: "Journal date : ",
                            title1: "${dateConvert("${journalListData[index].journalDate!}")}",
                            subTitle3: "Hospital site : ",
                            title3: journalListData[index].hospitalName,
                            subTitle4: "Course : ",
                            title4: journalListData[index].hospitalName,
                            subTitle17: "Clinician response : ",
                            title17:
                                journalListData[index].clinicianResponse == true
                                    ? "Yes"
                                    : "No",
                            subTitle18: "School response : ",
                            title18:
                                journalListData[index].schoolResponse == true
                                    ? "Yes"
                                    : "No",
                            btnSvgImage:
                                (!journalListData[index].clinicianResponse! &&
                                        !journalListData[index].schoolResponse!)
                                    ? "assets/images/Edit.svg"
                                    : "assets/images/eye.svg",
                            buttonTitle:
                                (!journalListData[index].clinicianResponse! &&
                                        !journalListData[index].schoolResponse!)
                                    ? "Edit"
                                    : "View",
                            navigateButton: (!journalListData[index]
                                        .clinicianResponse! &&
                                    !journalListData[index].schoolResponse!)
                                ? () async {
                                    // await Navigator.pushNamed(
                                    //   context,
                                    //   Routes.dailyJournalDetailsScreen,
                                    //   arguments: DailyJournalData(
                                    //       JournalId: Journallist[index].journalId,
                                    //       rotationId: Journallist[index].rotationId,
                                    //       hospitalTitle:
                                    //           Journallist[index].hospitalName,
                                    //       hospitalId:
                                    //           Journallist[index].hospitalSiteId,
                                    //       viewType: DailyJournalViewType.edit,
                                    //       journalDecCount: journalDecCount),
                                    // );
                             await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  EditDailyJournalScreen(
                                  journalListData: journalListData[index],journalId:journalListData[index].journalId!,
                                  journalDecCount: journalData.journalDescriptionCount!,
                                )),
                              );
                                    setState(() {
                                      pullToRefresh();
                                    });
                                  }
                                : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  ViewDailyJournalDetailScreen(
                                  journalListData: journalListData[index],journalId:journalListData[index].journalId!,
                                )),
                              );
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   Routes.dailyJournalDetailDataScreen,
                                    //   arguments: DailyJournalDetailData(
                                    //     JournalId: Journallist[index].journalId,
                                    //     // viewType: DailyJournalViewType.view,
                                    //   ),
                                    // );
                                  },
                          );
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

  Padding dateModule(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.route == DailyJournalRoute.direct ? 80 : 20,
          left: 15,
          right: 15),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              child: Material(
                color: Colors.white,
                // child: IOSKeyboardAction(
                //   label: 'DONE',
                //   focusNode: fromDateFocusNode,
                //   focusActionType: FocusActionType.done,
                //   onTap: () {},
                child: CommonTextfield(
                  autoFocus: false,
                  // focusNode: fromDateFocusNode,
                  hintText: 'From date',
                  textEditingController: fromDate,
                  validation: (value) {
                    fromDate.text = value!;
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () async {
                    var results = await showCalendarDatePicker2Dialog(
                      context: context,
                      value: [from],
                      config: CalendarDatePicker2WithActionButtonsConfig(
                          lastDate: DateTime.now(),
                          selectedDayHighlightColor:
                              Color(Hardcoded.primaryGreen)),
                      dialogSize: const Size(325, 400),
                      borderRadius: BorderRadius.circular(15),
                    );
                    if (results!.first!.compareTo(to) < 0 ||
                        results.first!.compareTo(to) == 0) {
                      setState(() {
                        from = results.first!;
                        fromDate.text = DateFormat('MM-dd-yyyy').format(from);
                        if (toDate.text.isNotEmpty) {
                          getDailyJournalListData();
                        }
                      });
                    } else {
                      AppHelper.buildErrorSnackbar(
                          context, "From date can not be greater than To date");
                    }
                  },
                  sufix: GestureDetector(
                    onTap: () async {
                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        value: [from],
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            lastDate: DateTime.now(),
                            selectedDayHighlightColor:
                                Color(Hardcoded.primaryGreen)),
                        dialogSize: const Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                      );
                      if (results!.first!.compareTo(to) < 0 ||
                          results.first!.compareTo(to) == 0) {
                        setState(() {
                          from = results.first!;
                          fromDate.text = DateFormat('MM-dd-yyyy').format(from);
                          if (toDate.text.isNotEmpty) {
                            getDailyJournalListData();
                          }
                        });
                      } else {
                        if (fromDate.text.isEmpty) {
                          AppHelper.buildErrorSnackbar(
                              context, "Select first from date");
                        }
                        AppHelper.buildErrorSnackbar(context,
                            "From date can not be greater than To date");
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
            // ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Material(
              color: Colors.white,
              // child: IOSKeyboardAction(
              //   label: 'DONE',
              //   focusNode: toDateFocusNode,
              //   focusActionType: FocusActionType.done,
              //   onTap: () {},
              child: CommonTextfield(
                autoFocus: false,
                // focusNode: toDateFocusNode,
                hintText: 'To date',
                textEditingController: toDate,
                readOnly: true,
                onTap: () async {
                  if (fromDate.text.isEmpty) {
                    AppHelper.buildErrorSnackbar(
                        context, "Select first from date");
                  } else {
                    var results = await showCalendarDatePicker2Dialog(
                      context: context,
                      value: [to],
                      config: CalendarDatePicker2WithActionButtonsConfig(
                          lastDate: DateTime.now(),
                          selectedDayHighlightColor:
                              Color(Hardcoded.primaryGreen)),
                      dialogSize: const Size(325, 400),
                      borderRadius: BorderRadius.circular(15),
                    );
                    if (results!.first!.compareTo(from) > 0 ||
                        results.first!.compareTo(from) == 0) {
                      setState(() {
                        to = results.first!;
                        toDate.text = DateFormat('MM-dd-yyyy').format(to);
                        if (fromDate.text.isNotEmpty) {
                          getDailyJournalListData();
                        }
                      });
                    } else {
                      AppHelper.buildErrorSnackbar(
                          context, "To date can not be smaller than from date");
                    }
                  }
                },
                sufix: GestureDetector(
                  onTap: () async {
                    if (fromDate.text.isEmpty) {
                      AppHelper.buildErrorSnackbar(
                          context, "Please select from date first");
                    } else {
                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        value: [to],
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            lastDate: DateTime.now(),
                            selectedDayHighlightColor:
                                Color(Hardcoded.primaryGreen)),
                        dialogSize: const Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                      );
                      if (results!.first!.compareTo(from) > 0 ||
                              results.first!.compareTo(from) == 0
                          // && results.first!.compareTo(to) != DateTime.now()
                          ) {
                        setState(() {
                          to = results.first!;
                          toDate.text = DateFormat('MM-dd-yyyy').format(to);
                          if (fromDate.text.isNotEmpty) {
                            getDailyJournalListData();
                          }
                        });
                      } else {
                        AppHelper.buildErrorSnackbar(context,
                            "To date can not be smaller than from date");
                      }
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
          // ),
        ],
      ),
    );
  }
}
