// ignore_for_file: non_constant_identifier_names, must_be_immutable, null_argument_to_non_null_type

import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/common_widgets/app_text_field.dart';
import 'package:clinicaltrac/clinician/common_widgets/common_dropdown_widget.dart';
import 'package:clinicaltrac/clinician/common_widgets/selected_list_model.dart';
import 'package:clinicaltrac/clinician/model/clinician_rotation_list_model.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/clinician/view/rotation_module/rotation_detail_screen_widget.dart';
import 'package:clinicaltrac/clinician/view/rotation_module/rotation_list_widget.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_type_list_model.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/action/homeactions/get_active_rotation_list_action.dart';
import 'package:clinicaltrac/redux/action/rotations/filter_rotation_list_by_course.dart';
import 'package:clinicaltrac/redux/action/rotations/set_acive_inactive_status.dart';
import 'package:clinicaltrac/redux/action/rotations/set_course_list_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_rotation_list_action.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class RotationListScreen extends StatefulWidget {
  RotationListScreen({
    super.key,
  });

  @override
  State<RotationListScreen> createState() => _RotationListScreenState();
}

class _RotationListScreenState extends State<RotationListScreen> {
  ///list for the toggle value
// List<String> commonTypeList = <String>['Active', 'Inactive'];
  int pageNo = 1;
  int lastpage = 1;
  bool dataNotFound = false;

// is search button of appbar is click
  bool isSearchClicked = false;
  bool isDataLoaded = true;

  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController searchEditingController = TextEditingController();
  List<CommonTypeListModel> commonTypeList = [
    CommonTypeListModel(
      type: "active",
      typeName: "Active",
    ),
    CommonTypeListModel(
      type: "inActive",
      typeName: "Inactive",
    ),
  ];
  List<String> courseNameList = [];
  List<CourseData> courseList = <CourseData>[];
  CourseData selectedCourseValue = new CourseData();

  // RotaionListData rotationList = RotaionListData();
  String selectedCourse = '';
  String selectedCourseId = '';
  String courseHintText = 'All';
  bool isResetCombo = false;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
  List<ClinicianRotationDetailListData> clinicianRotationListData = [];

  CourseListModel courseListModel = CourseListModel(data: []);

  // Future<void> courseListData() async {
  //   UserDatRepo userDatRepo = UserDatRepo();
  //   return userDatRepo.courseList(box!.get(Hardcoded.hiveBoxKey)!.loggedUserId,
  //       box!.get(Hardcoded.hiveBoxKey)!.accessToken,
  //           (CourseListModel courseListModelData) {
  //         setState(() {
  //           courseListModel = courseListModelData;
  //         });
  //         return null;
  //       }, () {}, context);
  // }

  // final List<SelectedListItem> _listOfCities = [
  //   SelectedListItem(
  //     name: "Sample",
  //     value: "TYO",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Pune",
  //     value: "NY",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "London",
  //     value: "LDN",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Nashik",
  //     value: "TYO",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Nagpur",
  //     value: "NY",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Shirol",
  //     value: "LDN",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Karad",
  //     value: "TYO",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Nagar",
  //     value: "NY",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Mumbai",
  //     value: "LDN",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Sangli",
  //     value: "TYO",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Kolhapur",
  //     value: "NY",
  //     isSelected: false,
  //   ),
  //   SelectedListItem(
  //     name: "Satara",
  //     value: "LDN",
  //     isSelected: false,
  //   ),
  // ];
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    store.dispatch(GetStudActiveRotationsListAction());
    store.dispatch(SetCourseListAction());

    getClinicianRotationList();
    // courseListData();
    super.initState();
  }

  Future<void> getClinicianRotationList() async {
    UserDatRepo userDatRepo = await UserDatRepo();

    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      CommonRequest request = CommonRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        userType: AppConsts.userType,
        isActive: commonTypeList[_selectedIndex].type == "active" ? "0" : "1",
        roleType: box.get(Hardcoded.hiveBoxKey)!.loggedUserRoleType,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        fromDate:
            fromDate.text.isEmpty ? "" : DateFormat('yyyy-MM-dd').format(from),
        todate: toDate.text.isEmpty ? "" : DateFormat('yyyy-MM-dd').format(to),
        SearchText: searchEditingController.text,
        // rankId: selectedRankId,
      );
      return userDatRepo.clinicianRotationList(request,
          (ClinicianRotationListModel clinicianRotationListModel) {
        lastpage =
            (int.parse(clinicianRotationListModel.pager!.totalRecords!) / 10)
                .ceil();
        if (clinicianRotationListModel.pager!.totalRecords == '0') {
          setState(() {
            dataNotFound = false;
          });
        } else {
          setState(() {
            dataNotFound = true;
            log("Total ${clinicianRotationListModel.pager!.totalRecords}");
          });
        }
        setState(() {
          if (pageNo != 1) {
            clinicianRotationListData.addAll(clinicianRotationListModel.data!);
          } else {
            clinicianRotationListData = clinicianRotationListModel.data!;
            // studentDetailListData = studentDetailListModel.data!;
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
      getClinicianRotationList();
    }
  }

  Future<void> pullToRefresh() async {
    // isDataLoaded = true;
    pageNo = 1;
    fromDate.text = "";
    toDate.text = "";
    getClinicianRotationList();
    store.dispatch(SetCourseListAction());

    isSearchClicked = false;
  }

  // getCourseList() {
  //   courseNameList = [];
  //   for (var value in widget.courseListModel.data) {
  //     setState(() {
  //       courseNameList.add(value.title!);
  //     });
  //   }
  // }

  // String getCourseIdByName(String name) {
  //   for (var value in widget.courseListModel.data) {
  //     if (value.title == name) {
  //       return value.courseId!;
  //     }
  //   }
  //   return '';
  // }

  final searchFocusNode = FocusNode();
  int _selectedIndex = 0;
  List<Color> initialColor = [
    Color(Hardcoded.orange),
    Color(Hardcoded.blue),
    Color(Hardcoded.pink)
  ];

  @override
  Widget build(BuildContext context) {
    // courseList = widget.courseListModel.data;
    // getCourseList();
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(
          context,
          Routes.bodySwitcher,
          arguments:
              BodySwitcherData(initialPage: Bottom_navigation_control.home),
        );
        return Future.value();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
          appBarColor: Colors.white,
          isBackArrow: false,
          isCenterTitle: true,
          titles: isSearchClicked
              ? Padding(
                  padding: const EdgeInsets.only(
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
                          getClinicianRotationList();
                        },
                      ),
                    ),
                  ),
                )
              : Text(
                  "Rotations",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                ),
          searchEnabeled: true,
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
              if (isSearchClicked == false) getClinicianRotationList();
            });
          },
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              Routes.bodySwitcher,
              arguments:
                  BodySwitcherData(initialPage: Bottom_navigation_control.home),
            );
          },
        ),
        body: NoInternet(
            child:
                // courseNameList.length != 1 || rotationListData.isNotEmpty ?
                Stack(
          children: [
            GestureDetector(
              onTap: () {
                isResetCombo = false;
              },
              child: GestureDetector(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: globalHeight * 0.07),
                      child: Column(
                        children: [
                          Container(
                            // color: Colors.green,
                            height: globalHeight * 0.05,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: commonTypeList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                    searchEditingController.text = '';
                                    pageNo = 1;
                                    getClinicianRotationList();
                                    isSearchClicked = false;
                                  },
                                  child: Container(
                                    height: globalHeight * 1,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: index == _selectedIndex
                                                ? Color(Hardcoded.primaryGreen)
                                                : Color(0xFFBBBBC6),
                                            width: 2),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 7,
                                        left: globalWidth * 0.17,
                                        right: globalWidth * 0.2,
                                        // left: globalWidth * 0.06, right: globalWidth * 0.06,
                                      ),
                                      child: Container(
                                        height: globalHeight * 0.1,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: globalHeight * 0.001,
                                                ),
                                                child: Text(
                                                  commonTypeList[index]
                                                      .typeName,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    // letterSpacing: 1,
                                                    fontSize: 16,
                                                    color:
                                                        index == _selectedIndex
                                                            ? Color(Hardcoded
                                                                .primaryGreen)
                                                            : Color(0xFFBBBBC6),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: globalHeight * 0.01,
                          ),
                          const SizedBox(
                            height: 1,
                          ),
                          Visibility(
                            visible: isSearchClicked == false &&
                                isDataLoaded &&
                                pageNo == 1,
                            child: Padding(
                              padding: EdgeInsets.only(top: globalHeight * 0.2),
                              child: common_loader(),
                            ),
                            replacement: Visibility(
                              visible: dataNotFound,
                              replacement: isSearchClicked
                                  ? Center(
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: globalHeight * 0.2),
                                          child: NoDataFoundWidget(
                                            // title: "Procedure count details not available",
                                            title: "No data found",
                                            imagePath:
                                                "assets/no_data_found.png",
                                          )),
                                    )
                                  : Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: globalHeight * 0.2,
                                        ),
                                        child: NoDataFoundWidget(
                                          title: "Rotations not available",
                                          imagePath: "assets/no_data_found.png",
                                        ),
                                      ),
                                    ),
                              child: Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: 1,
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _selectedIndex = index;
                                      getClinicianRotationList();
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return RefreshIndicator(
                                      onRefresh: () => pullToRefresh(),
                                      color: Color(0xFFBBBBC6),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                24,
                                                203,
                                                204,
                                                208,
                                              ),
                                              blurRadius: 35.0,
                                              // soften the shadow
                                              spreadRadius: 10.0,
                                              //extend the shadow
                                              offset: Offset(
                                                15.0,
                                                15.0,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2, right: 2.0),
                                          child: CupertinoScrollbar(
                                            controller: _scrollController,
                                            child: ListView.builder(
                                              itemCount:
                                                  clinicianRotationListData
                                                      .length,
                                              shrinkWrap: true,
                                              controller: _scrollController,
                                              physics:
                                                  const AlwaysScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index1) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    // if (!rotationListData
                                                    //     .elementAt(index1)
                                                    //     .isExpired) {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              RotationDetailScreenWidget(
                                                                activeStatus:
                                                                commonTypeList[
                                                                _selectedIndex]
                                                                    .type
                                                                    .toString(),
                                                                rotationListModel: clinicianRotationListData[index1],
                                                              ),
                                                        ),
                                                      );
                                                    // }
                                                  },
                                                  child: RotationListWidget(
                                                    duration: true,
                                                    endDate: true,
                                                    activeStatus:
                                                        commonTypeList[
                                                                _selectedIndex]
                                                            .type
                                                            .toString(),
                                                    color: initialColor
                                                        .elementAt(index %
                                                            initialColor
                                                                .length),
                                                    rotation:
                                                        clinicianRotationListData
                                                            .elementAt(index1),
                                                    // rotationListModel:
                                                    // widget.rotationListModel,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //         padding: EdgeInsets.only(
                    //             left: 17, right: 17),
                    //         child:  Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //         Expanded(
                    //         child: ExpansionWidget<CourseData>(
                    //             hintText:
                    //                 selectedCourseValue.title != "All" ? "All" : '',
                    //             // enabled: selectAllCourseTopic.toString().isEmpty
                    //             //     ? true
                    //             //     : false,
                    //             textColor: Colors.black,
                    //             OnSelection: (value) {
                    //               setState(() {
                    //                 CourseData c = value as CourseData;
                    //                 selectedCourseValue = c;
                    //                 // singleCourseTopicList.clear();
                    //                 selectedCourseId =
                    //                     selectedCourseValue.courseId.toString();
                    //                 selectedCourse =
                    //                     selectedCourseValue.title.toString();
                    //                 pageNo = 1;
                    //                 searchEditingController.text = '';
                    //                 isSearchClicked = false;
                    //                 getClinicianRotationList();
                    //               });
                    //               log("id---------${selectedCourseValue.courseId}");
                    //             },
                    //             items: List.of(
                    //               courseList.map(
                    //                 (item) {
                    //                   String text = item.title.toString();
                    //                   return DropdownItem<CourseData>(
                    //                     value: item,
                    //                     child: Padding(
                    //                       padding: EdgeInsets.only(
                    //                           top: 8.0,
                    //                           left: globalWidth * 0.06,
                    //                           right: globalWidth * 0.06,
                    //                           bottom: 8.0),
                    //                       child: Column(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             text,
                    //                             maxLines: 1,
                    //                             overflow: TextOverflow.ellipsis,
                    //                             style: Theme.of(context)
                    //                                 .textTheme
                    //                                 .bodyMedium!
                    //                                 .copyWith(
                    //                                   fontWeight: FontWeight.w500,
                    //                                   fontSize: 14,
                    //                                   color: Colors.black,
                    //                                 ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //             // Padding(
                    //             //   padding:  EdgeInsets.only(left: 2,top: 0.013.sh),
                    //             //   child: Container(
                    //             //     height: 0.07.sh,
                    //             //     width: 0.08.sw,
                    //             //     color: Colors.white,
                    //             //     child: GestureDetector(
                    //             //       onTap: (){
                    //             //         DropDownState(
                    //             //           DropDown(
                    //             //             isDismissible: true,
                    //             //             bottomSheetTitle: const Text(
                    //             //               "Select Course",
                    //             //               style: TextStyle(
                    //             //                 fontWeight: FontWeight.bold,
                    //             //                 fontSize: 20.0,
                    //             //               ),
                    //             //             ),
                    //             //             submitButtonChild: const Text(
                    //             //               'Done',
                    //             //               style: TextStyle(
                    //             //                 fontSize: 16,
                    //             //                 fontWeight: FontWeight.bold,
                    //             //               ),
                    //             //             ),
                    //             //             data: _listOfCities ?? [],
                    //             //             selectedItems: (List<dynamic> selectedList) {
                    //             //               List<String> list = [];
                    //             //               for (var item in selectedList) {
                    //             //                 if (item is SelectedListItem) {
                    //             //                   list.add(item.name);
                    //             //                 }
                    //             //               }
                    //             //               log(list.toString());
                    //             //             },
                    //             //             // enableMultipleSelection: false,
                    //             //           ),
                    //             //         ).showModal(context);
                    //             //       },
                    //             //       child: SvgPicture.asset(
                    //             //         'assets/images/filter.svg',
                    //             //       ),
                    //             //     ),
                    //             //   ),
                    //             // ),
                    //           ],),
                    //         // child: CommonExpansion(
                    //         //   OnSelection: (String value) {
                    //         //     setState(() {
                    //         //       isResetCombo = false;
                    //         //       courseHintText = value;
                    //         //       isSearchClicked = false;
                    //         //     });
                    //         //     store.dispatch(
                    //         //       FilterRotationListByCourseList(
                    //         //           active_status:
                    //         //               commonTypeList[_selectedIndex].type,
                    //         //           courseId: getCourseIdByName(value),
                    //         //           searchText: ''),
                    //         //     );
                    //         //     getClinicianRotationList();
                    //         //   },
                    //         //   bodyList: courseNameList,
                    //         //   trailIcon: "",
                    //         //   hintText: courseHintText,
                    //         //   isReset: isResetCombo,
                    //         //   decoration: BoxDecoration(
                    //         //     color: Color(Hardcoded.textFieldBg),
                    //         //     borderRadius: BorderRadius.circular(12),
                    //         //     // border: Border.all(color: Colors.transparent),
                    //         //     boxShadow: [
                    //         //       BoxShadow(
                    //         //         color: Colors.black12,
                    //         //         offset: const Offset(
                    //         //           0.0,
                    //         //           5.0,
                    //         //         ),
                    //         //         blurRadius: 7.0,
                    //         //         spreadRadius: 2.0,
                    //         //       ),
                    //         //     ],
                    //         //   ),
                    //         // ),
                    //
                    //
                    // ),
                  ],
                ),
              ),
            ),
            dateModule(context),
          ].reversed.map((e) => e).toList(),
        )
            // : Center(
            //     child: NoDataFoundWidget(
            //     title: "Rotations not available",
            //     imagePath: "assets/no_data_found.png",
            //   )),
            ),
      ),
    );
  }

  Padding dateModule(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 15, right: 15),
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
                          getClinicianRotationList();
                        }
                      });
                    } else {
                      AppHelper.buildErrorSnackbar(
                          context, "From date can not be greater than To date");
                    }
                  },
                  sufix: Padding(
                    padding: EdgeInsets.only(right: 2.0),
                    child: GestureDetector(
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
                            fromDate.text =
                                DateFormat('MM-dd-yyyy').format(from);
                            if (toDate.text.isNotEmpty) {
                              getClinicianRotationList();
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
                          getClinicianRotationList();
                        }
                      });
                    } else {
                      AppHelper.buildErrorSnackbar(
                          context, "To date can not be smaller than from date");
                    }
                  }
                },
                sufix: Padding(
                  padding: EdgeInsets.only(right: 2.0),
                  child: GestureDetector(
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
                              getClinicianRotationList();
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
          ),
          // ),
        ],
      ),
    );
  }
}
