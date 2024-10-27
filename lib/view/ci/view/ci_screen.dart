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
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/ci/models/ci_response.dart';
import 'package:clinicaltrac/view/formative/models/formative_response.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CIScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;

  CIScreen(
      {super.key, required this.userLoginResponse, required this.rotation});

  @override
  State<CIScreen> createState() => _CIScreenState();
}

class _CIScreenState extends State<CIScreen> {
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
  List<CIData> ciList = [];

  void getCIEvaluationList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest Request = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '10',
          SearchText: searchQuery.text,
          RotationId: widget.rotation.rotationId!);
      final DataResponseModel dataResponseModel =
          await dataService.getCiEvalauionList(Request);
      CIResponse ciResponse = CIResponse.fromJson(dataResponseModel.data);

      lastpage = (int.parse(ciResponse.pager.totalRecords!) / 10).ceil();
      if (ciResponse.pager.totalRecords == '0') {
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
          ciList.addAll(ciResponse.data);
        } else {
          ciList = ciResponse.data;
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
      getCIEvaluationList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    getCIEvaluationList();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getCIEvaluationList();
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
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    userId = int.parse("${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
    String userIdEncr = userId.toString();
    String userIdEncoded = base64Encode(utf8.encode(userIdEncr));
    rotationId = int.parse("${widget.rotation.rotationId}");
    String rotationIdEncr = rotationId.toString();
    String rotationIdEncoded = base64Encode(utf8.encode(rotationIdEncr));
    String webUrlAdd =
        'https://rt.clinicaltrac.net/appRedirect.html?AccessToken=' +
            '${box.get(Hardcoded.hiveBoxKey)!.accessToken}' +
            '&UserType=S&UserId=' +
            '${userIdEncoded}' +
            '&RedirectType=' +
            'ciEvaluation' +
            '&RotationId=' +
            '${rotationIdEncoded}' +
            '&IsMobile=1';
    // log("${webUrlAdd}");
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          titles: isSearchClicked
              ? Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: CommonSearchTextfield(
                    hintText: 'Search',
                    textEditingController: searchQuery,
                    onChanged: (value) {
                      pageNo = 1;
                      getCIEvaluationList();
                    },
                  ),
                )
              : Text("CI Evaluation",
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
              if (isSearchClicked == false) {}
              getCIEvaluationList();
            });
          },
        ),
        backgroundColor: Color(Hardcoded.white),
        floatingActionButton: !widget.rotation.isHospitalSiteActive
            ? null
            : commonAddButton(onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WebRedirectionWithLoadingScreen(
                    url: webUrlAdd,
                    screenTitle: "Add CI Evaluation",
                    onSuccess: () async {
                      setState(() {
                        getCIEvaluationList();
                        pullToRefresh().then((value) {
                          common_alert_pop(
                              context,
                              'Successfully created\nEvaluation.',
                              'assets/images/success_Icon.svg',
                                  () {
                                Navigator.pop(context);
                              });
                        });
                      });
                    },
                    onFail: () async {
                      setState(() {
                        getCIEvaluationList();
                        pullToRefresh();
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
          pullToRefresh();
        }),
        body: NoInternet(
          child: Column(
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
                                      title: "CI Evaluations not available",
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
                            padding: const EdgeInsets.only(
                                top: 2.0, left: 2, right: 2.0),
                            child: CupertinoScrollbar(
                              controller: _scrollController,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: ciList.length,
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  evaluationDate =
                                      ciList[index].evaluationDate != ""
                                          ? dateConvert(
                                              ciList[index].evaluationDate)
                                          : '';
                                  userId = int.parse(
                                      "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                                  String userIdEncr = userId.toString();
                                  String userIdEncoded =
                                      base64Encode(utf8.encode(userIdEncr));

                                  rotationId =
                                      int.parse("${ciList[index].rotationId}");
                                  String rotationIdEncr = rotationId.toString();
                                  String rotationIdEncoded =
                                      base64Encode(utf8.encode(rotationIdEncr));

                                  evaluationId = int.parse(
                                      "${ciList[index].evaluationId}");
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
                                          'ciEvaluation' +
                                          '&RotationId=' +
                                          '${rotationIdEncoded}' +
                                          '&RedirectId=' +
                                          '${evaluationIdEncoded}' +
                                          '&IsMobile=1';
                                  // log("${webUrlEdit}");
                                  return CommonListContainerWidget(
                                    mainTitle:
                                        "Evaluation date : ${dateConvert("${ciList[index].evaluationDate}")}",
                                    subTitle1: "Clinician : ",
                                    title1:
                                        "${ciList[index].firstName} ${ciList[index].lastName}",
                                    subTitle4: "Overall Rating : ",
                                    title4: ciList[index].OverallRating,
                                    buttonTitle: "Edit",
                                    btnSvgImage: "assets/images/Edit.svg",
                                    navigateButton: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WebRedirectionWithLoadingScreen(
                                            url: webUrlEdit,
                                            screenTitle: "Edit CI Evaluation",
                                            onSuccess: () async {
                                              setState(() {
                                                getCIEvaluationList();
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
                                                getCIEvaluationList();
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
          ),
        ),
      ),
    );
  }
}
