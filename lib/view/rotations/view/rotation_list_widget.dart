// ignore_for_file: non_constant_identifier_names, must_be_immutable, null_argument_to_non_null_type

import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
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
import 'package:clinicaltrac/view/rotations/view/rotation_list_screen.dart';
import 'package:clinicaltrac/view/rotations/view/rotation_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

enum ROTATIONSTATUS {
  active,
  trends,
}

class RotationsListScreenWidget extends StatefulWidget {
  RotationsListScreenWidget(
      {super.key,
      required this.rotationListModel,
      required this.courseListModel,
      required this.active_status});

  final RotationListModel rotationListModel;

  final CourseListModel courseListModel;

  Active_status active_status;

  @override
  State<RotationsListScreenWidget> createState() =>
      _RotationsListScreenWidgetState();
}

class _RotationsListScreenWidgetState extends State<RotationsListScreenWidget> {
  ///list for the toggle value
// List<String> commonTypeList = <String>['Active', 'Inactive'];
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;

// is search button of appbar is click
  bool isSearchClicked = false;
  bool isDataLoaded = true;

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
  List<Rotation> rotationListData = [];
  List<CourseData> courseList = <CourseData>[];
  CourseData selectedCourseValue = new CourseData();
  RotaionListData rotationList = RotaionListData();
  String selectedCourse = '';
  String selectedCourseId = '';
  String courseHintText = 'All';
  bool isResetCombo = false;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    store.dispatch(GetStudActiveRotationsListAction());
    widget.active_status = Active_status.active;
    // store.dispatch(SetRotationsListAction(active_status: widget.active_status));
    store.dispatch(
        SetActiveInactiveStatusAction(active_status: widget.active_status));
    store.dispatch(SetCourseListAction());

    getRotationListData();

    super.initState();
  }

  Future<void> getRotationListData() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      if(mounted) {
        setState(() {
          isDataLoaded = true;
        });
      }
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();
      CommonRequest request = CommonRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        isActive: commonTypeList[_selectedIndex].type == "active" ? "0" : "1",
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        title: searchEditingController.text,
        courseId: selectedCourseId,
      );
      final DataResponseModel dataResponseModel =
      await dataService.getRotationListDemo(request);
      RotationListModel rotationListModel =
      RotationListModel.fromJson(dataResponseModel.data);
      // log("${box.get(Hardcoded.hiveBoxKey)!.accessToken} ${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
      lastpage = (int.parse(rotationListModel.pager.totalRecords!) / 10).ceil();
      if (rotationListModel.pager.totalRecords == '0') {
        if(mounted) {
          setState(() {
            datanotFound = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            datanotFound = false;
          });
        }
      }
      if (mounted) {
        setState(() {
          if (pageNo != 1) {
            rotationListData.addAll(rotationListModel.data.rotationList!);
          } else {
            rotationListData = rotationListModel.data.rotationList!;
            rotationList = rotationListModel.data;
          }
          isDataLoaded = false;
        });
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;
      getRotationListData();
    }
  }

  Future<void> pullToRefresh() async {
    // isDataLoaded = true;
    pageNo = 1;
    getRotationListData();
    searchEditingController.text = '';
    isSearchClicked = false;
    store.dispatch(SetRotationsListAction(active_status: widget.active_status));
    store.dispatch(
        SetActiveInactiveStatusAction(active_status: widget.active_status));
    store.dispatch(SetCourseListAction());
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
    courseList = widget.courseListModel.data;
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
                          getRotationListData();
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
              if (isSearchClicked == false) getRotationListData();
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
                GestureDetector(
          onTap: () {
            isResetCombo = false;
          },
          child: GestureDetector(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Container(
                        height: globalHeight * 0.13,
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
                                isSearchClicked = false;
                                getRotationListData();

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
                                              commonTypeList[index].typeName,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                // letterSpacing: 1,
                                                fontSize: 16,
                                                color: index == _selectedIndex
                                                    ? Color(
                                                        Hardcoded.primaryGreen)
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
                      SizedBox(height: 10),
                      const SizedBox(
                        height: 12,
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
                          visible: !datanotFound,
                          replacement: isSearchClicked
                              ? Center(
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: globalHeight * 0.2),
                                      child: NoDataFoundWidget(
                                        // title: "Procedure count details not available",
                                        title: "No data found",
                                        imagePath: "assets/no_data_found.png",
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
                                  getRotationListData();
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
                                    child:Padding(
                                      padding: const EdgeInsets.only(left:2,right: 2.0),
                                      child:CupertinoScrollbar(
                                         controller: _scrollController,
                                        child:  ListView.builder(
                                          itemCount: rotationListData.length,
                                          shrinkWrap: true,
                                          controller: _scrollController,
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, int index1) {
                                            return GestureDetector(
                                              onTap: () {
                                                if (!rotationListData
                                                    .elementAt(index1)
                                                    .isExpired) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RotationDetailsPage(
                                                        rotation: rotationListData
                                                            .elementAt(index1),
                                                        rotationListModel: widget
                                                            .rotationListModel,
                                                            activeStatus:
                                                            commonTypeList[_selectedIndex]
                                                                .type
                                                                .toString(),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: RotationContainerScreen(
                                                pendingRotationList:
                                                    rotationList.pendingRotation!,
                                                activeStatus:
                                                    commonTypeList[_selectedIndex]
                                                        .type
                                                        .toString(),
                                                showClockIn: true,
                                                duration: true,
                                                endDate: true,
                                                color: initialColor.elementAt(
                                                    index % initialColor.length),
                                                rotation: rotationListData
                                                    .elementAt(index1),
                                                rotationListModel:
                                                    widget.rotationListModel,
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
                Padding(
                  padding: const EdgeInsets.only(left: 17, right: 17),
                  child: ExpansionWidget<CourseData>(
                    hintText: selectedCourseValue.title != "All" ? "All" : '',
                    // enabled: selectAllCourseTopic.toString().isEmpty
                    //     ? true
                    //     : false,
                    textColor: Colors.black,
                    OnSelection: (value) {
                      setState(() {
                        CourseData c = value as CourseData;
                        selectedCourseValue = c;
                        // singleCourseTopicList.clear();
                        selectedCourseId =
                            selectedCourseValue.courseId.toString();
                        selectedCourse = selectedCourseValue.title.toString();
                        pageNo = 1;
                        searchEditingController.text = '';
                        isSearchClicked = false;
                        getRotationListData();
                      });
                      // log("id---------${selectedCourseValue.courseId}");
                    },
                    items: List.of(courseList.map((item) {
                      String text = item.title.toString();
                      return DropdownItem<CourseData>(
                        value: item,
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: 8.0,
                                left: globalWidth * 0.06,
                                right: globalWidth * 0.06,
                                bottom: 8.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                ])),
                      );
                    })),
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
              ],
            ),
          ),
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
}
