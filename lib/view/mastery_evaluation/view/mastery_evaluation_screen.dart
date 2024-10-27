import 'dart:convert';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_green_rotation.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/mastery_evaluation/models/mastery_evaluation_response.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class MasteryEvaluationScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;
  final RotationListStudentJournal rotationListStudentJournal;

  MasteryEvaluationScreen(
      {super.key,
      required this.userLoginResponse,
      required this.rotation,
      required this.rotationListStudentJournal});

  @override
  State<MasteryEvaluationScreen> createState() =>
      _MasteryEvaluationScreenState();
}

class _MasteryEvaluationScreenState extends State<MasteryEvaluationScreen> {
  bool isSearchClicked = false;
  int pageNo = 1;
  int lastpage = 1;
  bool isDataLoaded = false;
  bool dataNotfound = false;

  ///Use for web redirection
  int userId = 0;
  int rotationId = 0;
  int evaluationId = 0;
  int redirectId = 0;
  String evaluationDate = "";

  ///

  TextEditingController searchQuery = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<MasteryEvaluationInnerData> masteryEvaluationList = [];

  void getdailyWeeklyList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest elvationMasteryRequest = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '10',
          SearchText: searchQuery.text,
          RotationId: widget.rotation.rotationId!);
      final DataResponseModel dataResponseModel =
          await dataService.getMastryEvalution(elvationMasteryRequest);
      MasteryEvaluationResponse masteryEvalutionResponse =
          MasteryEvaluationResponse.fromJson(dataResponseModel.data);

      lastpage =
          (int.parse(masteryEvalutionResponse.payload!.pager!.totalRecords!) /
                  10)
              .ceil();
      if (masteryEvalutionResponse.payload!.pager!.totalRecords == '0') {
        setState(() {
          dataNotfound = true;
        });
      } else {
        setState(() {
          dataNotfound = false;
        });
      }
      setState(() {
        if (pageNo != 1) {
          masteryEvaluationList.addAll(masteryEvalutionResponse.payload!.data!);
        } else {
          masteryEvaluationList = masteryEvalutionResponse.payload!.data!;
        }
        isDataLoaded = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;
      getdailyWeeklyList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    getdailyWeeklyList();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getdailyWeeklyList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return '${formattedDate} ';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          title: "Mastery Evaluation",
          // searchEnabeled: true,
        ),
        backgroundColor: Color(Hardcoded.white),
        // floatingActionButton: GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => CreateDailyWeeklyEvalution(
        //             rotationList: widget.rotationListStudentJournal,
        //             user: widget.userLoginResponse,
        //             Viewtype: DailyWeeklyEval.add,
        //             rotationID: widget.rotation.rotationId,
        //             rotationname: widget.rotation.rotationTitle,
        //           )),
        //     );
        //   },
        //   child: Container(
        //     decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: Color(Hardcoded.orange),
        //         boxShadow: [
        //           BoxShadow(
        //               blurRadius: 10,
        //               offset: const Offset(2, 2),
        //               blurStyle: BlurStyle.normal,
        //               color: Color(Hardcoded.orange))
        //         ]),
        //     child: Padding(
        //       padding: const EdgeInsets.all(12.0),
        //       child: Icon(
        //         Icons.add,
        //         size: 35,
        //         color: Color(Hardcoded.white),
        //       ),
        //     ),
        //   ),
        // ),
        body: Column(
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
                visible: isDataLoaded && pageNo == 1,
                child: common_loader(),
                replacement: Visibility(
                  visible: !dataNotfound,
                  replacement: Padding(
                    padding: EdgeInsets.only(bottom: globalHeight * 0.03),
                    child: Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: NoDataFoundWidget(
                          title: "Mastery Evaluations not available",
                          imagePath: "assets/no_data_found.png",
                        ),
                      ),
                    ),
                  ),
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
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 2, right: 2.0),
                        child: CupertinoScrollbar(
                          controller: _scrollController,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: masteryEvaluationList.length,
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Box<UserLoginResponseHive>? box =
                                  Boxes.getUserInfo();
                              // log("***************** ${checkoffsListData[index].status}");
                              evaluationDate =
                                  masteryEvaluationList[index].evaluationDate !=
                                          ""
                                      ? dateConvert(masteryEvaluationList[index]
                                          .evaluationDate!)
                                      : '';

                              int userId = int.parse(
                                  "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                              String userIdEncr = userId.toString();
                              String userIdEncoded =
                                  base64Encode(utf8.encode(userIdEncr));

                              int rotationId = int.parse(
                                  "${masteryEvaluationList[index].rotationId}");
                              String rotationIdEncr = rotationId.toString();
                              String rotationIdEncoded =
                                  base64Encode(utf8.encode(rotationIdEncr));

                              int evaluationId = int.parse(
                                  "${masteryEvaluationList[index].evaluationId}");
                              String evaluationIdEncr = evaluationId.toString();
                              String evaluationIdEncoded =
                                  base64Encode(utf8.encode(evaluationIdEncr));
                              String webUrl =
                                  // 'https://staging.clinicaltrac.net/appRedirect.html?AccessToken=' +
                                  'https://rt.clinicaltrac.net/appRedirect.html?AccessToken=' +
                                      '${box.get(Hardcoded.hiveBoxKey)!.accessToken}' +
                                      '&UserType=S&UserId=' +
                                      '${userIdEncoded}' +
                                      '&RedirectType=' +
                                      'mastery' +
                                      '&RotationId=' +
                                      '${rotationIdEncoded}' +
                                      '&RedirectId=' +
                                      '${evaluationIdEncoded}' +
                                      '&IsMobile=1';
                              // log("uuuuuuuuuuuu ${webUrl}");
                              return CommonListContainerWidget(
                                mainTitle:
                                    "Evaluation date : ${dateConvert("${masteryEvaluationList[index].evaluationDate!}")}",
                                statusString:
                                    masteryEvaluationList[index].status == "0"
                                        ? "Pending"
                                        : null,
                                subTitle1: "Student sign date : ",
                                title1: masteryEvaluationList[index]
                                            .dateOfStudentSignature ==
                                        null
                                    ? "-"
                                    : DateFormat("MMM dd, yyyy").format(
                                        masteryEvaluationList[index]
                                            .dateOfStudentSignature!),
                                subTitle6: "Instructor sign date : ",
                                title6: masteryEvaluationList[index]
                                            .dateOfInstructorSignature ==
                                        null
                                    ? "-"
                                    : DateFormat("MMM dd, yyyy").format(
                                        masteryEvaluationList[index]
                                            .dateOfInstructorSignature!),

                                divider:
                                    masteryEvaluationList[index].status != "0"
                                        ? Divider(
                                            thickness: 1,
                                          )
                                        : null,
                                subTitle7:
                                    masteryEvaluationList[index].cPAP == ''
                                        ? ''
                                        : "CPAP : ",
                                title7: masteryEvaluationList[index].cPAP == ''
                                    ? ""
                                    : masteryEvaluationList[index].cPAP,
                                subTitle8: masteryEvaluationList[index]
                                            .delieveryOfNeonate ==
                                        ''
                                    ? ''
                                    : "Delivery of neonate : ",
                                title8: masteryEvaluationList[index]
                                            .delieveryOfNeonate ==
                                        ''
                                    ? ""
                                    : masteryEvaluationList[index]
                                        .delieveryOfNeonate,
                                subTitle9:
                                    masteryEvaluationList[index].totalAvg == ''
                                        ? ''
                                        : "Total Average : ",
                                title9: masteryEvaluationList[index].totalAvg ==
                                        ''
                                    ? ""
                                    : double.parse(
                                            "${masteryEvaluationList[index].totalAvg}")
                                        .toStringAsFixed(2),

                                subTitle12: masteryEvaluationList[index]
                                            .tracheostomyCare ==
                                        ''
                                    ? ''
                                    : "Tracheostomy Care : ",
                                title12: masteryEvaluationList[index]
                                            .tracheostomyCare ==
                                        ''
                                    ? ""
                                    : masteryEvaluationList[index]
                                        .tracheostomyCare,
                                subTitle13:
                                    masteryEvaluationList[index].hFOV == ''
                                        ? ''
                                        : "HFOV : ",
                                title13: masteryEvaluationList[index].hFOV == ''
                                    ? ""
                                    : masteryEvaluationList[index].hFOV,
                                // buttonTitle: masteryEvaluationList[index].status == "1"
                                //     ? "Signoff Evaluation"
                                //     : "View Evaluation",
                                // btnSvgImage: masteryEvaluationList[index].status == "1"
                                //     ? "assets/images/send-square.svg"
                                //     : "assets/images/eye.svg",
                                navigateButton: () async {
                                  switch (masteryEvaluationList[index].status) {
                                    case "1":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WebRedirectionWithLoadingScreen(
                                            url: webUrl,
                                            // url: "https://formsmarts.com/html-form-example",
                                            screenTitle: "Mastery Signoff",
                                            onSuccess: () async {
                                              setState(() {
                                                pullToRefresh().then((value) {
                                                  common_alert_pop(
                                                      context,
                                                      'Evaluation Successfully\nSigned Off',
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
                                          ),
                                        ),
                                      );
                                      break;
                                    case "2":
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                WebRedirectionWithLoadingScreen(
                                                  url: webUrl,
                                                  screenTitle: "Mastery View",
                                                  onSuccess: () async {
                                                    setState(() {
                                                      pullToRefresh();
                                                    });
                                                  },
                                                  onFail: () async {
                                                    setState(() {
                                                      pullToRefresh();
                                                    });
                                                  },
                                                  onError: () async {
                                                    setState(() {
                                                      pullToRefresh()
                                                          .then((value) {
                                                        common_alert_pop(
                                                            context,
                                                            '${"OOP's"}\nSomething went wrong',
                                                            'assets/images/error_Icon.svg',
                                                            () {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      });
                                                    });
                                                  },
                                                )),
                                      );
                                      break;
                                    default:
                                  }
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
          ],
        ),
      ),
    );
  }
}
