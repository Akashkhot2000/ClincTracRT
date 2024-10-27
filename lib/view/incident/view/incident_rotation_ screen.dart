import 'dart:convert';
import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_add_button.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_green_rotation.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/incident/models/incident_response.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class IncidentScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;
  final RotationListStudentJournal rotationListStudentJournal;
  Rotation? rotation;
  DailyJournalRoute route;

  IncidentScreen(
      {super.key,
      required this.rotationListStudentJournal,
      required this.userLoginResponse,
      required this.rotation,
      required this.route});

  @override
  State<IncidentScreen> createState() => _IncidentScreenState();
}

class _IncidentScreenState extends State<IncidentScreen> {
  bool isSearchClicked = false;
  TextEditingController searchQuery = TextEditingController();
  int pageNo = 1;
  String? selectedRotation;
  String? selectedRotationId;
  List<String> items = ['yoyo', 'test'];
  bool isDataLoaded = false;
  int lastpage = 1;
  bool dataNotfound = false;
  List<IncidentData> incidentList = [];
  ScrollController _scrollController = ScrollController();
  RoundedLoadingButtonController delete = RoundedLoadingButtonController();

  ///Use for web redirection
  int userId = 0;
  int rotationId = 0;
  int evaluationId = 0;
  int redirectId = 0;
  String evaluationDate = "";

  ///

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

  void getIncidentList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest incidenceRequest = CommonRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        pageNo: pageNo.toString(),
        RecordsPerPage: '7',
        SearchText: searchQuery.text,
        RotationId: widget.rotation!.rotationId!,
        // RotationId: selectedRotationId!
      );
      final DataResponseModel dataResponseModel =
          await dataService.getIncident(incidenceRequest);
      IncidentResponse incidentResponse =
          IncidentResponse.fromJson(dataResponseModel.data);
      lastpage = (int.parse(incidentResponse.pager.totalRecords!) / 7).ceil();
      // log(lastpage.toString());
      if (incidentResponse.pager.totalRecords == '0') {
        setState(() {
          dataNotfound = true;
        });
      } else {
        setState(() {
          dataNotfound = false;
        });
      }
      setState(() {
        if (pageNo == 1) {
          incidentList = incidentResponse.data;
        } else {
          for (int i = 0; i < incidentResponse.data.length; i++) {
            incidentList.add(incidentResponse.data[i]);
          }
        }
        isDataLoaded = false;
      });
      // log(dataNotfound.toString());
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;
      getIncidentList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    // log(widget.route.toString());
    if (widget.rotationListStudentJournal.data.isEmpty) {
      selectedRotation = items[0];
    } else {
      if (widget.route == DailyJournalRoute.direct)
        setValue();
      else {
        selectedRotation = widget.rotation!.rotationTitle;
        selectedRotationId = widget.rotation!.rotationId;
      }
    }
    // setValue();
    getIncidentList();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getIncidentList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return '${formattedDate} ';
  }

  @override
  Widget build(BuildContext context) {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    userId = int.parse("${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
    String userIdEncr = userId.toString();
    String userIdEncoded = base64Encode(utf8.encode(userIdEncr));
    rotationId = int.parse("${widget.rotation!.rotationId}");
    String rotationIdEncr = rotationId.toString();
    String rotationIdEncoded = base64Encode(utf8.encode(rotationIdEncr));
    String webUrlAdd =
        'https://rt.clinicaltrac.net/appRedirect.html?AccessToken=' +
            '${box.get(Hardcoded.hiveBoxKey)!.accessToken}' +
            '&UserType=S&UserId=' +
            '${userIdEncoded}' +
            '&RedirectType=' +
            'incident' +
            '&RotationId=' +
            '${rotationIdEncoded}' +
            '&IsMobile=1';
    // log("${webUrlAdd}");
    return NoInternet(
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
                          child: CommonSearchTextfield(
                            focusNode: searchFocusNode,
                            hintText: 'Search',
                            textEditingController: searchQuery,
                            onChanged: (value) {
                              pageNo = 1;
                              getIncidentList();
                            },
                          ),
                        ),
                      ),
                    )
                  : Text("Incident",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                          )),
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
                  searchQuery.text = '';
                  // FocusScope.of(context).unfocus();
                  if (isSearchClicked == false) {}
                  getIncidentList();
                });
              },
            ),
            backgroundColor: Color(Hardcoded.white),
            // floatingActionButton: !widget.rotation!.isHospitalSiteActive
            //     ? null
            //     : commonAddButton(onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) =>
            //           WebRedirectionWithLoadingScreen(
            //             url: webUrlAdd,
            //             screenTitle: "Add Incident Evaluation",
            //             onSuccess: () async {
            //               setState(() {
            //                 pullToRefresh().then((value) {
            //                   common_alert_pop(
            //                       context,
            //                       'Successfully created\nEvaluation.',
            //                       'assets/images/success_Icon.svg',
            //                           () {
            //                         Navigator.pop(context);
            //                       });
            //                 });
            //               });
            //             },
            //             onFail: () async {
            //               setState(() {
            //                 pullToRefresh();
            //                 // pageNo=1;
            //               });
            //             },
            //             onError: () async {
            //               setState(() {
            //                 pullToRefresh().then((value) {
            //                   common_alert_pop(
            //                       context,
            //                       '${"OOP's"}\nSomething went wrong',
            //                       'assets/images/error_Icon.svg',
            //                           () {
            //                         Navigator.pop(context);
            //                       });
            //                 });
            //               });
            //             },
            //             // },
            //           ),
            //     ),
            //   );
            //   pullToRefresh();
            // }),
            body:
                // items.length != 1 ?
                Column(
              children: [
                common_green_rotation_card(
                  date: '${widget.rotation?.startDate.day}',
                  month:
                      "${Hardcoded.getMonthString(widget.rotation?.startDate.month)}",
                  text1: "${widget.rotation?.rotationTitle}",
                  text2: "${widget.rotation?.hospitalTitle}",
                  text3: "${widget.rotation?.courseTitle}",
                  Index: 0,
                ),
                Expanded(
                  child: Visibility(
                    visible:
                        isSearchClicked == false && isDataLoaded && pageNo == 1,
                    child: common_loader(),
                    replacement: Visibility(
                      visible: dataNotfound,
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
                                        title: "Incidents not available",
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
                                )
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2, right: 2.0),
                              child: CupertinoScrollbar(
                                controller: _scrollController,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: incidentList.length,
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    evaluationDate = incidentList[index]
                                                .incidentDate !=
                                            ""
                                        ? dateConvert(
                                            incidentList[index].incidentDate)
                                        : '';
                                    userId = int.parse(
                                        "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                                    String userIdEncr = userId.toString();
                                    String userIdEncoded =
                                        base64Encode(utf8.encode(userIdEncr));

                                    rotationId = int.parse(
                                        "${incidentList[index].rotationId}");
                                    String rotationIdEncr =
                                        rotationId.toString();
                                    String rotationIdEncoded = base64Encode(
                                        utf8.encode(rotationIdEncr));

                                    evaluationId = int.parse(
                                        "${incidentList[index].incidentId}");
                                    String evaluationIdEncr =
                                        evaluationId.toString();
                                    String evaluationIdEncoded = base64Encode(
                                        utf8.encode(evaluationIdEncr));
                                    String webUrlEdit =
                                        // 'https://staging.clinicaltrac.net/appRedirect.html?AccessToken=' +
                                        'https://rt.clinicaltrac.net/appRedirect.html?AccessToken=' +
                                            '${box.get(Hardcoded.hiveBoxKey)!.accessToken}' +
                                            '&UserType=S&UserId=' +
                                            '${userIdEncoded}' +
                                            '&RedirectType=' +
                                            'incident' +
                                            '&RotationId=' +
                                            '${rotationIdEncoded}' +
                                            '&RedirectId=' +
                                            '${evaluationIdEncoded}' +
                                            '&IsMobile=1';
                                    // log("${webUrlEdit}");
                                    return CommonListContainerWidget(
                                      mainTitle: toBeginningOfSentenceCase(
                                          incidentList[index].title),
                                      subTitle1: "Incident date : ",
                                      title1:
                                          "${dateConvert("${incidentList[index].incidentDate}")}",
                                      subTitle3: "Clinician : ",
                                      title3: incidentList[index].clinicianName,
                                      subTitle4: "Rotation : ",
                                      title4: incidentList[index].rotationName,
                                      navigateButton1: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WebRedirectionWithLoadingScreen(
                                              url: webUrlEdit,
                                              // url: "https://formsmarts.com/html-form-example",
                                              screenTitle:
                                                  "Edit Incident Evaluation",
                                              onSuccess: () async {
                                                setState(() {
                                                  pullToRefresh().then((value) {
                                                    common_alert_pop(
                                                        context,
                                                        'Evaluation Updated\nSuccessfully',
                                                        'assets/images/success_Icon.svg',
                                                        () {
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                });
                                              },
                                              onFail: () async {
                                                setState(() {
                                                  pullToRefresh();
                                                  // pageNo=1;
                                                });
                                              },
                                              onError: () async {
                                                setState(() {
                                                  pullToRefresh().then((value) {
                                                    common_alert_pop(
                                                        context,
                                                        '${"OOP's"}\nSomething went wrong',
                                                        'assets/images/error_Icon.svg',
                                                        () {
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                });
                                              },
                                              // },
                                            ),
                                          ),
                                        );
                                      },
                                      // buttonTitle1: "Edit",
                                      // btnSvgImage1: "assets/images/Edit.svg",
                                      // verticalDivider: VerticalDivider(
                                      //   thickness: 1,
                                      //   color: Color(0x3001A750),
                                      // ),
                                      // btnSvgImage2: "assets/images/trash1.svg",
                                      // buttonTitle2: "Delete",
                                      navigateButton2: () {
                                        common_popup_widget(
                                            context,
                                            'Do you want to delete Incident?',
                                            'assets/images/deleteicon.svg',
                                            () async {
                                          // Navigator.pop(context);
                                          Box<UserLoginResponseHive>? box =
                                              Boxes.getUserInfo();
                                          final DataService dataService =
                                              locator();
                                          final DataResponseModel
                                              dataResponseModel =
                                              await dataService.deleteData(
                                            incidentList[index].incidentId,
                                            box
                                                .get(Hardcoded.hiveBoxKey)!
                                                .loggedUserId,
                                            box
                                                .get(Hardcoded.hiveBoxKey)!
                                                .accessToken,
                                            "interaction | attendance | incident | volunteerEval",
                                            "incident",
                                          );
                                          // log("${dataResponseModel.success}");
                                          if (dataResponseModel.success) {
                                            delete.success();
                                            Future.delayed(
                                                const Duration(seconds: 3), () {
                                              Navigator.pop(context);
                                              AppHelper.buildErrorSnackbar(
                                                  context,
                                                  "Incident deleted successfully");
                                              getIncidentList();
                                            });
                                          } else {
                                            delete.error();
                                            Future.delayed(
                                                const Duration(seconds: 3), () {
                                              delete.reset();
                                            });
                                          }
                                        });
                                      },
                                      // btnSvgImage1:
                                      // incidentList[index].status == false
                                      //     ? "assets/images/trash1.svg"
                                      //     : null,
                                      // buttonTitle1:
                                      // attendanceList[index].status == false
                                      //     ? "Delete"
                                      //     : null,
                                      // navigateButton1: () {
                                      //   common_popup_widget(
                                      //       context,
                                      //       'Do you want to delete Attendance?',
                                      //       'assets/images/deleteicon.svg',
                                      //           () async {
                                      //         // Navigator.pop(context);
                                      //         final DataService dataService = locator();
                                      //         final DataResponseModel
                                      //         dataResponseModel =
                                      //         await dataService.deleteData(
                                      //           attendanceList[index].attendanceId,
                                      //           widget.userLoginResponse.data
                                      //               .loggedUserId,
                                      //           widget
                                      //               .userLoginResponse.data.accessToken,
                                      //           "interaction | attendance | incident | volunteerEval",
                                      //           "attendance",
                                      //         );
                                      //         // log("${dataResponseModel.success}");
                                      //         if (dataResponseModel.success) {
                                      //           delete.success();
                                      //           Future.delayed(
                                      //               const Duration(seconds: 3), () {
                                      //             Navigator.pop(context);
                                      //             AppHelper.buildErrorSnackbar(context,
                                      //                 "Attendance deleted successfully");
                                      //             getAttedanceList();
                                      //           });
                                      //         } else {
                                      //           delete.error();
                                      //           Future.delayed(
                                      //               const Duration(seconds: 3), () {
                                      //             delete.reset();
                                      //           });
                                      //         }
                                      //       });
                                      // },
                                      // verticalDivider: VerticalDivider(
                                      //     thickness: 1, color: Color(0x3001A750)),
                                      // btnSvgImage2:
                                      // attendanceList[index].status == false
                                      //     ? "assets/images/add1.svg"
                                      //     : null,
                                      // buttonTitle2:
                                      // attendanceList[index].status == false
                                      //     ? "Add Exception"
                                      //     : null,
                                      // navigateButton2: () async{
                                      //   await Navigator.pushNamed(
                                      //       context, Routes.exceptionScreen,
                                      //       arguments:
                                      //       AddAttendExceptionRoutingData(
                                      //           attendanceData:
                                      //           attendanceList[index]));
                                      //   getAttedanceList();
                                      // },
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
              ],
            )
            // : Align(
            //     alignment: Alignment.center,
            //     child: Padding(
            //       padding: EdgeInsets.only(bottom: globalHeight * 0.15),
            //       child: NoDataFoundWidget(
            //         title: "Incident not available",
            //         imagePath: "assets/no_data_found.png",
            //       ),
            //     ),
            //   ),
            ));
    // :Scaffold(body: Center(child: Text("No Internet Conection")));
  }
}
