import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
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
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/attendance/vm_connector/add_exception_vm_connector.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AttendanceScreen extends StatefulWidget {
  UserLoginResponse userLoginResponse;
  RotationListStudentJournal rotationListStudentJournal;

  AttendanceScreen(
      {required this.userLoginResponse,
      required this.rotationListStudentJournal});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool isSearchClicked = false;
  TextEditingController searchQuery = TextEditingController(text: '');
  ScrollController scrollController = ScrollController();
  String? selectedRotation;
  String? selectedRotationId;
  List<String> items = ['yoyo', 'test'];
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<AttendanceData> attendanceList = [];
  bool isDataLoaded = true;
  RoundedLoadingButtonController delete = RoundedLoadingButtonController();
  List<RotationJournalData> rotationEvalList = <RotationJournalData>[];
  RotationJournalData selectedRotationValue = new RotationJournalData();

  void setValue() {
    List<String> temp = [];
    for (var cnt in widget.rotationListStudentJournal.data) {
      temp.add(cnt.title!);
    }
    setState(() {
      items = temp;
      selectedRotation = items[0];
    });
    selectedRotationId = widget.rotationListStudentJournal.data[0].rotationId;
  }

  DateTime convertDateToUTC(String dateUtc) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
    var formattedTime = dateTime.toLocal();
    return formattedTime;
  }

  void getAttedanceList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest request = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '5',
          RotationId: selectedRotationId!,
          SearchText: searchQuery.text);
      final DataResponseModel dataResponseModel =
          await dataService.getAttedance(request);
      AttendanceResponseDart attendanceResponse =
          AttendanceResponseDart.fromJson(dataResponseModel.data);
      lastpage = (int.parse(attendanceResponse.pager.totalRecords!) / 5).ceil();
      if (attendanceResponse.pager.totalRecords == '0') {
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
          attendanceList.addAll(attendanceResponse.data);
        } else {
          attendanceList = attendanceResponse.data;
        }
        isDataLoaded = false;
      });
    }
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;

      getAttedanceList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    setValue();
    _scrollController.addListener(_scrollListener);
    super.initState();
    getAttedanceList();
    rotationEvalList = widget.rotationListStudentJournal.data!;
  }

  Future<void> pullToRefresh() async {
    pageNo = 1;
    getAttedanceList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    rotationEvalList = widget.rotationListStudentJournal.data!;
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
                        textEditingController: searchQuery,
                        onChanged: (value) {
                          pageNo = 1;
                          getAttedanceList();
                        },
                      ),
                    ),
                  ),
                )
              : Text(
                  "Attendance",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                ),
          searchEnabeled: true,
          onTap: () {
            Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                arguments: BodySwitcherData(
                    initialPage: Bottom_navigation_control.home));
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
              searchQuery.text = '';
              FocusScope.of(context).unfocus();
              if (isSearchClicked == false) {}
              getAttedanceList();
            });
          },
        ),
        backgroundColor: Color(Hardcoded.white),
        body: NoInternet(
            child:
                // items.length != 1 ?
                Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: globalHeight * 0.09),
              child: Visibility(
                visible:
                    isSearchClicked == false && isDataLoaded && pageNo == 1,
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
                                      top: globalHeight * 0.01,
                                      bottom: globalHeight * 0.1),
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
                                      top: globalHeight * 0.01,
                                      bottom: globalHeight * 0.15),
                                  child: NoDataFoundWidget(
                                    title: "Attendance not available",
                                    imagePath: "assets/no_data_found.png",
                                  )),
                            ),
                          ),
                        ),
                  replacement: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: RefreshIndicator(
                      onRefresh: () => pullToRefresh(),
                      color: Color(0xFFBBBBC6),
                      child: Container(
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
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left:2,right: 2),
                          child:CupertinoScrollbar(
                    controller: _scrollController,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: attendanceList.length,
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommonListContainerWidget(
                                  mainTitle: attendanceList[index].rotationName,
                                  statusString:
                                      attendanceList[index].status == true
                                          ? "Approved"
                                          : null,
                                  subTitle4: "Hospital site : ",
                                  title4: attendanceList[index].hospitalSiteName,
                                  subTitle5: "Course : ",
                                  title5: attendanceList[index].courseName,
                                  divider: Divider(
                                    thickness: 1,
                                  ),
                                  icon7: "assets/images/clockin.svg",
                                  subTitle7: "Clock In : ",
                                  title7: DateFormat("MMM dd yyyy, hh:mm aa")
                                      .format(convertDateToUTC(
                                          attendanceList[index]
                                              .clockInDateTime
                                              .toString())),
                                  icon8: "assets/images/clockout.svg",
                                  subTitle8: "Clock Out : ",
                                  title8:
                                      attendanceList[index].clockOutDateTime ==
                                              null
                                          ? "-"
                                          : DateFormat("MMM dd yyyy, hh:mm aa")
                                              .format(convertDateToUTC(
                                                  attendanceList[index]
                                                      .clockOutDateTime
                                                      .toString())),
                                  subTitle17: "Original hours : ",
                                  title17:
                                      "${attendanceList[index].orignalhours} hrs",
                                  subTitle18: "Approved hours : ",
                                  title18: attendanceList[index].status == false
                                      ? ''
                                      : "${attendanceList[index].approvedhours} hrs",
                                  subTitle24: "View note : ",
                                  title24: attendanceList[index].notes.isNotEmpty
                                      ? "View"
                                      : "-",
                                  navigateText: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20.0),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: globalHeight * 0.3,
                                          child: Padding(
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10, left: 10),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "View Note",
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 21,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                top: 5,
                                                                right: 10),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topRight,
                                                          child: Icon(
                                                            Icons.clear,
                                                            color:
                                                                Color(0xFF000000),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 5, left: 13, right: 5),
                                                  child: Text(
                                                    "${toBeginningOfSentenceCase(attendanceList[index].notes)}",
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  subTitle25: "Exception added : ",
                                  title25:
                                      attendanceList[index].isException == false
                                          ? "-"
                                          : "Yes",
                                  // btnSvgImage: attendanceList[index].status == true ? "assets/images/add1.svg" : null,
                                  // buttonTitle: attendanceList[index].status == true ? "Add Exception" : null,
                                  // navigateButton: attendanceList[index].approvedhours == '00:00' ? () {
                                  //   Navigator.pushNamed(context, Routes.exceptionScreen,
                                  //       arguments: AddAttendExceptionRoutingData(attendanceData: attendanceList[index]));} : () {},
                                  btnSvgImage1:
                                      attendanceList[index].status == false
                                          ? "assets/images/trash1.svg"
                                          : null,
                                  buttonTitle1:
                                      attendanceList[index].status == false
                                          ? "Delete"
                                          : null,
                                  navigateButton1: () {
                                    common_popup_widget(
                                        context,
                                        'Do you want to delete Attendance?',
                                        'assets/images/deleteicon.svg', () async {
                                      // Navigator.pop(context);
                                      Box<UserLoginResponseHive>? box =
                                          Boxes.getUserInfo();
                                      final DataService dataService = locator();
                                      final DataResponseModel dataResponseModel =
                                          await dataService.deleteData(
                                        attendanceList[index].attendanceId,
                                        box
                                            .get(Hardcoded.hiveBoxKey)!
                                            .loggedUserId,
                                        box
                                            .get(Hardcoded.hiveBoxKey)!
                                            .accessToken,
                                        "interaction | attendance | incident | volunteerEval",
                                        "attendance",
                                      );
                                      // log("${dataResponseModel.success}");
                                      if (dataResponseModel.success) {
                                        delete.success();
                                        Future.delayed(const Duration(seconds: 3),
                                            () {
                                          Navigator.pop(context);
                                          AppHelper.buildErrorSnackbar(context,
                                              "Attendance deleted successfully.");
                                          // getAttedanceList();
                                          pullToRefresh();
                                        });
                                      } else {
                                        delete.error();
                                        Future.delayed(const Duration(seconds: 3),
                                            () {
                                          delete.reset();
                                        });
                                      }
                                    });
                                  },
                                  verticalDivider: VerticalDivider(
                                      thickness: 1, color: Color(0x3001A750)),
                                  btnSvgImage2: attendanceList[index].status ==
                                          false
                                      ? attendanceList[index].isException == false
                                          ? "assets/images/add1.svg"
                                          : "assets/images/Edit.svg"
                                      : null,
                                  buttonTitle2: attendanceList[index].status ==
                                          false
                                      ? attendanceList[index].isException == false
                                          ? "Add Exception"
                                          : "Edit Exception"
                                      : null,
                                  navigateButton2: () async {
                                    await Navigator.pushNamed(
                                        context, Routes.exceptionScreen,
                                        arguments: AddAttendExceptionRoutingData(
                                            attendanceData:
                                                attendanceList[index]));
                                    getAttedanceList();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: ExpansionWidget<RotationJournalData>(
                hintText: selectedRotationValue.title != "All" ? "All" : '',
                // enabled: selectAllCourseTopic.toString().isEmpty
                //     ? true
                //     : false,
                textColor: selectedRotation.toString().isNotEmpty
                    ? Colors.black
                    : Color(Hardcoded.greyText),
                OnSelection: (value) {
                  setState(() {
                    RotationJournalData c = value as RotationJournalData;
                    selectedRotationValue = c;
                    // singleCourseTopicList.clear();
                    selectedRotation = selectedRotationValue.title;
                    selectedRotationId = selectedRotationValue.rotationId;
                    pageNo = 1;
                    searchQuery.text = '';
                    isSearchClicked = false;
                    getAttedanceList();
                  });
                  // log("id---------${selectedRotationValue.rotationId}");
                },
                items: List.of(rotationEvalList.map((item) {
                  String text = item.title.toString();
                  List<String> title = text.split("(");
                  String subText = title[0].toString() == "All"
                      ? title[0]
                      : title[1].toString();
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              subTitle[0] != "All" && title[0] != "All"
                                  ? Text(subTitle[0],
                                      // widget.hintText,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Color(Hardcoded.greyText)))
                                  : Container(),
                            ])),
                  );
                })),
              ),
              // child: CommonExpansion(
              //   OnSelection: (String value) {
              //     setState(() {
              //       selectedRotation = value;
              //       selectedRotationId = widget
              //           .rotationListStudentJournal
              //           .data[widget.rotationListStudentJournal.data.indexWhere(
              //               (element) => element.title == selectedRotation)]
              //           .rotationId;
              //       pageNo = 1;
              //       searchQuery.text = '';
              //       isSearchClicked = false;
              //       getAttedanceList();
              //     });
              //   },
              //   bodyList: items,
              //   trailIcon: "",
              //   hintText: selectedRotation!,
              //   decoration: BoxDecoration(
              //     color: Color(Hardcoded.textFieldBg),
              //     borderRadius: BorderRadius.circular(30),
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
            //Visibility(visible: isDataLoaded && pageNo != 1, child: common_loader())
          ],
        )
            // : Align(
            //     alignment: Alignment.center,
            //     child: NoDataFoundWidget(
            //       title: "Attendance not available",
            //       imagePath: "assets/no_data_found.png",
            //     ),
            //   ),
            // floatingActionButton: FloatingActionButton(
            //     backgroundColor: Color(Hardcoded.orange),
            //     child: Icon(
            //       Icons.add,
            //       size: 35,
            //     ),
            //     onPressed: () {
            //       Navigator.pushNamed(context, Routes.exceptionScreen);
            //     }),
            ),
      ),
    );
  }
}
