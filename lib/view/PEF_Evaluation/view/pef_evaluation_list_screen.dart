import 'dart:convert';
import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
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
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/model/pef_list_model.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/model/pef_type_list_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_request_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/student_procedure_list/student_procedure_list_request.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/student_procedure_list/student_procedure_list_responce.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/create_procedure_count_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_detail_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_steps_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class PEFListScreen extends StatefulWidget {
  PEFListScreen({
    Key? key,
    // this.allRotation,this.rotationId,
    this.isFromCheckoff,
    this.checkOffId,
    required this.userLoginResponse,
    required this.rotation,
  }) : super(key: key);

  // final AllRotation? allRotation;
  // String? rotationId;
  bool? isFromCheckoff;
  String? checkOffId;
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;

  @override
  State<PEFListScreen> createState() => _PEFListScreenState();
}

class _PEFListScreenState extends State<PEFListScreen> {
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<PEFListData> pefListData = [];
  bool isDataLoaded = true;
  bool isSearchClicked = false;

  TextEditingController textController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  ///Use for web redirection
  int userId = 0;
  int rotationId = 0;
  int evaluationId = 0;
  int redirectId = 0;
  String evaluationDate = "";

  ///

  List<PEFTypeListModel> pefTypeList = [
    PEFTypeListModel(
      type: "0",
      typeName: "All",
    ),
    PEFTypeListModel(
      type: "1",
      typeName: "PEF I",
    ),
    PEFTypeListModel(
      type: "2",
      typeName: "PEF II",
    ),
  ];

  Future<void> getPEFListData() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      if (mounted) {
        setState(() {
          isDataLoaded = true;
        });
      }
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest request = CommonRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        RotationId: widget.rotation.rotationId,
        type: pefTypeList[_selectedIndex].type,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        SearchText: searchTextController.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getPEFList(request);
      PEFListModel pefListModel = PEFListModel.fromJson(dataResponseModel.data);
      log("Total Count ${pefTypeList[_selectedIndex].type}");
      lastpage = (int.parse(pefListModel.pager.totalRecords!) / 5).ceil();
      if (pefListModel.pager.totalRecords == '0') {
        if (mounted) {
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
      setState(() {
        if (pageNo != 1) {
          pefListData.addAll(pefListModel.data);
        } else {
          pefListData = pefListModel.data;
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
      // getStudentProcedureListData();
    }
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    searchTextController.text = '';
    getPEFListData();
    isSearchClicked = false;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();

    getPEFListData();
  }

  List<Color> initialColor = [
    Color(Hardcoded.blue),
    Color(Hardcoded.orange),
    Color(Hardcoded.purple),
    Color(Hardcoded.pink)
  ];
  int _selectedIndex = 0;
  final searchFocusNode = FocusNode();
  String proTopicId = '';

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return '${formattedDate} ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        titles: Text(
          "PEF Evaluation",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
        ),
      ),
      body: NoInternet(
        child: Column(
          children: [
            common_green_rotation_card(
              date: '${widget.rotation.startDate.day}',
              month:
                  "${Hardcoded.getMonthString(widget.rotation.startDate.month)}",
              text1: "${widget.rotation.rotationTitle}",
              text2: "${widget.rotation.hospitalTitle}",
              text3: "${widget.rotation.courseTitle}",
              Index: 0,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pefTypeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      pageNo = 1;
                      getPEFListData();
                    },
                    child: Container(
                      height: globalHeight * 0.06,
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
                          left: globalWidth * 0.11,
                          right: globalWidth * 0.15,
                        ),
                        child: Container(
                          height: globalHeight * 0.06,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: globalHeight * 0.001),
                                  child: Text(
                                    pefTypeList[index].typeName,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      // letterSpacing: 1,
                                      fontSize: 16,
                                      color: index == _selectedIndex
                                          ? Color(Hardcoded.primaryGreen)
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
            Visibility(
              visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
              child: Padding(
                padding: EdgeInsets.only(top: globalHeight * 0.3),
                child: common_loader(),
              ),
              replacement: Visibility(
                visible: !datanotFound,
                replacement: Center(
                  child: Padding(
                      padding: EdgeInsets.only(
                        top: globalHeight * 0.23,
                      ),
                      child: NoDataFoundWidget(
                        title: "PEF Evaluations not available",
                        // title: "No data found",
                        imagePath: "assets/no_data_found.png",
                      )),
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
                        getPEFListData();
                      });
                    },
                    itemBuilder: (context, index) {
                      proTopicId = pefListData[index].type;
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
                                itemCount: pefListData.length,
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder:
                                    (BuildContext context, int index1) {
                                  Box<UserLoginResponseHive>? box =
                                      Boxes.getUserInfo();
                                  log("***************** ${pefListData[index].status}");
                                  evaluationDate = pefListData[index]
                                              .evaluationDate !=
                                          ""
                                      ? dateConvert(
                                          pefListData[index].evaluationDate!)
                                      : '';

                                  int userId = int.parse(
                                      "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                                  String userIdEncr = userId.toString();
                                  String userIdEncoded =
                                      base64Encode(utf8.encode(userIdEncr));

                                  int rotationId = int.parse(
                                      "${pefListData[index].rotationId}");
                                  String rotationIdEncr = rotationId.toString();
                                  String rotationIdEncoded =
                                      base64Encode(utf8.encode(rotationIdEncr));

                                  int evaluationId = int.parse(
                                      "${pefListData[index].evaluationId}");
                                  String evaluationIdEncr =
                                      evaluationId.toString();
                                  String evaluationIdEncoded = base64Encode(
                                      utf8.encode(evaluationIdEncr));
                                  String webUrl =
                                      // 'https://staging.clinicaltrac.net/appRedirect.html?AccessToken=' +
                                      'https://rt.clinicaltrac.net/appRedirect.html?AccessToken=' +
                                          '${box.get(Hardcoded.hiveBoxKey)!.accessToken}' +
                                          '&UserType=S&UserId=' +
                                          '${userIdEncoded}' +
                                          '&RedirectType=' +
                                          'pefEvaluation' +
                                          '&RotationId=' +
                                          '${rotationIdEncoded}' +
                                          '&RedirectId=' +
                                          '${evaluationIdEncoded}' +
                                          '&IsMobile=1';
                                  // log("uuuuuuuuuuuu ${webUrl}");
                                  return CommonListContainerWidget(
                                    mainTitle:
                                        "Evaluation Date : ${dateConvert("${pefListData[index1].evaluationDate!}")}",
                                    statusString: pefListData[index].status ==
                                            "0"
                                        ? "Pending"
                                        : pefListData[index].status == "1" ||
                                                pefListData[index].status == "2"
                                            ? "Completed"
                                            : null,
                                    subTitle1: "Type : ",
                                    title1: pefListData[index1].type,
                                    subTitle20: "Student sign date : ",
                                    title20: pefListData[index1]
                                                .dateOfStudentSignature ==
                                            null
                                        ? "-"
                                        : "${DateFormat("MMM dd, yyyy").format(pefListData[index1].dateOfStudentSignature!)}",
                                    subTitle21: "Status : ",
                                    title21: pefListData[index1].pefStatus,
                                    score: pefListData[index1].score,
                                    buttonTitle: pefListData[index1].status == "1"
                                        ? "Edit Evaluation"
                                        :  pefListData[index1].status == "2"
                                        ? "View Evaluation":null,
                                    btnSvgImage:
                                    pefListData[index1].status == "1"
                                        ? "assets/images/send-square.svg"
                                    :  pefListData[index1].status == "2"
                                        ?"assets/images/eye.svg" :null,
                                    navigateButton: () async {
                                      switch (pefListData[index1].status) {
                                        case "1":
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WebRedirectionWithLoadingScreen(
                                                url: webUrl,
                                                screenTitle: pefListData[index1]
                                                            .type ==
                                                        "PEF I"
                                                    ? "Edit PEF I Evaluation"
                                                    : "Edit PEF II Evaluation",
                                                onSuccess: () async {
                                                  setState(() {
                                                    pullToRefresh()
                                                        .then((value) {
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
                                                    pullToRefresh()
                                                        .then((value) {
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
                                                      screenTitle: pefListData[
                                                                      index1]
                                                                  .type ==
                                                              "PEFI"
                                                          ? "View PEFI Evaluation"
                                                          : "View PEFII Evaluation",
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
                      );
                    },
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
