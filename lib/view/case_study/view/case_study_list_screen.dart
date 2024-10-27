import 'dart:convert';
import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_add_button.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/case_study/model/case_study_list_model.dart';
import 'package:clinicaltrac/view/case_study/model/case_study_type_list.model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CaseStudyListScreen extends StatefulWidget {
  CaseStudyListScreen({Key? key, required this.rotation}) : super(key: key);
  Rotation? rotation;

  @override
  State<CaseStudyListScreen> createState() => _CaseStudyListScreenState();
}

class _CaseStudyListScreenState extends State<CaseStudyListScreen> {
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<CaseStudySettingTypeData> caseStudySettingTypeData = [];
  bool isDataLoaded = true;
  bool isSearchClicked = false;

  ///Use for web redirection
  int userId = 0;
  int rotationId = 0;
  int evaluationId = 0;
  int redirectId = 0;
  String evaluationDate = "";
  ///

  TextEditingController textController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  RoundedLoadingButtonController delete = RoundedLoadingButtonController();

  void getCaseStudySettingType() async {
    // if (pageNo == 1 || pageNo <= lastpage) {
    setState(() {
      isDataLoaded = true;
    });
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();

    CommonRequest request = CommonRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      // RotationId: widget.allRotation.rotationId,
      pageNo: pageNo.toString(),
      RecordsPerPage: '10',
    );
    final DataResponseModel dataResponseModel =
        await dataService.getStudentCaseStudySettingList(request);
    CaseStudySettingTypeModel caseStudySettingTypeModel =
        CaseStudySettingTypeModel.fromJson(dataResponseModel.data);
    setState(() {
      caseStudySettingTypeData.addAll(caseStudySettingTypeModel.data);
      caseStudySettingTypeData = caseStudySettingTypeModel.data;
      isDataLoaded = false;
    });
    getStudentCaseStudyListData();
  }

  List<CaseStudyListModelData> caseStudyListModelData = [];

  // List<CaseStudy> caseStudyList = [];

  void getStudentCaseStudyListData() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest request = CommonRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        // RotationId: widget.rotation!.rotationId,
        type: caseStudySettingTypeData[_selectedIndex].caseType,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        SearchText: searchTextController.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getStudentCaseStudyList(request);
      CaseStudyListModel caseStudyListModel =
          CaseStudyListModel.fromJson(dataResponseModel.data);
      // log("Total Count ${caseStudyListModel.pager.totalRecords}");
      lastpage =
          (int.parse(caseStudyListModel.pager.totalRecords!) / 10).ceil();
      if (caseStudyListModel.pager.totalRecords == '0') {
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
          caseStudyListModelData.addAll(caseStudyListModel.data);
        } else {
          caseStudyListModelData = caseStudyListModel.data;
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
      getStudentCaseStudyListData();
    }
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    searchTextController.text = '';
    getCaseStudySettingType();
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
    setState(() {
      getCaseStudySettingType();
    });
  }

  List<Color> initialColor = [
    Color(Hardcoded.blue),
    Color(Hardcoded.orange),
    Color(Hardcoded.purple),
    Color(Hardcoded.pink)
  ];
  int _selectedIndex = 0;
  final searchFocusNode = FocusNode();
  String caseStudyType = '';

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
    // rotationId = int.parse("${widget.rotation.rotationId}");
    String rotationIdEncr = rotationId.toString();
    String rotationIdEncoded = base64Encode(utf8.encode(rotationIdEncr));
    String redirectIdEncoded = base64Encode(utf8.encode("0"));
    String redirectType =  _selectedIndex == 1 ? 'PACR' : _selectedIndex == 2 ? 'floorCaseStudy' :'adult';
    String webUrlAdd =
        'https://rt.clinicaltrac.net/appRedirect.html?AccessToken=' +
            '${box.get(Hardcoded.hiveBoxKey)!.accessToken}' +
            '&UserType=S&UserId=' +
            '${userIdEncoded}' +
            '&RedirectType=' +
            '${redirectType}' +
            '&RedirectId=' +
            '${redirectIdEncoded}' +
            '&IsMobile=1';
    // log("${webUrlAdd}");
    return Scaffold(
      appBar: CommonAppBar(
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
                      textEditingController: searchTextController,
                      onChanged: (value) {
                        pageNo = 1;
                        getStudentCaseStudyListData();
                      },
                    ),
                  ),
                ),
              )
            : Text(
                "Case Study",
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
            searchTextController.text = '';
            FocusScope.of(context).unfocus();
            if (isSearchClicked == false) getStudentCaseStudyListData();
          });
        },
      ),
      floatingActionButton:  _selectedIndex == 1 || _selectedIndex == 2 || _selectedIndex == 3
          ? commonAddButton(onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                WebRedirectionWithLoadingScreen(
                  url: webUrlAdd,
                  screenTitle: _selectedIndex == 1 ? 'Add PACR' : _selectedIndex == 2 ? 'Add Floor Therapy' : 'Add Adult ICU & NICU/PICU',
                  onSuccess: () async {
                    setState(() {
                      getStudentCaseStudyListData();
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
                      getStudentCaseStudyListData();
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
        pullToRefresh();
      })
          : null,
      body: Column(
        children: [
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: caseStudySettingTypeData.length,
              // controller: _scrollController,
              addSemanticIndexes: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    pageNo = 1;
                    getStudentCaseStudyListData();
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
                          left: 15,
                          right: caseStudySettingTypeData[index]
                                  .caseName
                                  .isNotEmpty
                              ? 15
                              : 0),
                      child: Container(
                        height: globalHeight * 0.06,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: globalHeight * 0.001),
                              child: Text(
                                caseStudySettingTypeData[index].caseName,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 0),
          Visibility(
            visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
            child: Padding(
              padding: EdgeInsets.only(top: globalHeight * 0.3),
              child: common_loader(),
            ),
            replacement: Visibility(
              visible: !datanotFound,
              replacement: isSearchClicked
                  ? Center(
                      child: Padding(
                          padding: EdgeInsets.only(top: globalHeight * 0.3),
                          child: NoDataFoundWidget(
                            // title: "Procedure count details not available",
                            title: "No data found",
                            imagePath: "assets/no_data_found.png",
                          )),
                    )
                  : Center(
                      child: Padding(
                          padding: EdgeInsets.only(
                            top: globalHeight * 0.3,
                          ),
                          child: NoDataFoundWidget(
                            title: "Case Study not available",
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
                      getStudentCaseStudyListData();
                    });
                  },
                  itemBuilder: (context, index) {
                    caseStudyType = caseStudyListModelData[index].isSelectedTab;
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
                    padding: const EdgeInsets.only(left:2,right: 2.0),
                    child:CupertinoScrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                            itemCount: caseStudyListModelData.length,
                            shrinkWrap: true,
                            controller: _scrollController,
                            // physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return
                                ListView.builder(
                                itemCount: caseStudyListModelData[index]
                                    .caseStudyList
                                    .length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                // controller: _scrollController,
                                itemBuilder: (BuildContext context, int index1) {
                                  evaluationDate =
                                  caseStudyListModelData[index].caseStudyList[index1].caseStudyDate !=
                                      ""
                                      ? dateConvert(caseStudyListModelData[index].caseStudyList[index1].caseStudyDate)
                                      : '';
                                  userId = int.parse(
                                      "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                                  String userIdEncr = userId.toString();
                                  String userIdEncoded =
                                  base64Encode(utf8.encode(userIdEncr));

                                  rotationId = int.parse(
                                      "${caseStudyListModelData[index].caseStudyList[index1].rotationId}");
                                  String rotationIdEncr = rotationId.toString();
                                  String rotationIdEncoded =
                                  base64Encode(utf8.encode(rotationIdEncr));
                                  evaluationId = int.parse(
                                      "${caseStudyListModelData[index].caseStudyList[index1].caseStudyId}");
                                  String evaluationIdEncr =
                                  evaluationId.toString();
                                  String evaluationIdEncoded =
                                  base64Encode(utf8.encode(evaluationIdEncr));
                                  String redirectType = caseStudyListModelData[index]
                                      .caseStudyList[index1]
                                      .type ==
                                      "PACR" ? "PACR" : caseStudyListModelData[index]
                                      .caseStudyList[index1]
                                      .type ==
                                      "Floor"
                                      ? "floorCaseStudy"
                                      : "adult";
                                  String webUrlEditView =
                                  // 'https://staging.clinicaltrac.net/appRedirect.html?AccessToken=' +
                                  'https://rt.clinicaltrac.net/appRedirect.html?AccessToken=' +
                                      '${box.get(Hardcoded.hiveBoxKey)!.accessToken}' +
                                      '&UserType=S&UserId=' +
                                      '${userIdEncoded}' +
                                      '&RedirectType=' +
                                      '${redirectType}' +
                                      '&RotationId=' +
                                      '${rotationIdEncoded}' +
                                      '&RedirectId=' +
                                      '${evaluationIdEncoded}' +
                                      '&IsMobile=1';
                                  // log("${webUrlEdit}");
                                  return CommonListContainerWidget(
                                    mainTitle:
                                        "Case Study Date : ${dateConvert("${caseStudyListModelData[index].caseStudyList[index1].caseStudyDate}")}",
                                    subTitle1: "Type : ",
                                    title1: caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .typeName,
                                    subTitle3: "Rotation : ",
                                    title3: caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .rotationName,
                                    subTitle26: "Clinician : ",
                                    title26: caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .clinician,
                                    subTitle27: "School : ",
                                    title27: caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .school,
                                    divider: caseStudyListModelData[index]
                                            .caseStudyList[index1]
                                            .chiefComplaintAdmitDiagnosis
                                            .isEmpty
                                        ? null
                                        : Divider(
                                            thickness: 1,
                                          ),
                                    title28: caseStudyListModelData[index]
                                            .caseStudyList[index1]
                                            .chiefComplaintAdmitDiagnosis
                                            .isEmpty
                                        ? ""
                                        : "Chief Complaint/Admitting Diagnosis : ",
                                    subTitle28: !caseStudyListModelData[index]
                                            .caseStudyList[index1]
                                            .chiefComplaintAdmitDiagnosis
                                            .contains('</br>')
                                        ? caseStudyListModelData[index]
                                            .caseStudyList[index1]
                                            .chiefComplaintAdmitDiagnosis
                                        : caseStudyListModelData[index]
                                            .caseStudyList[index1]
                                            .chiefComplaintAdmitDiagnosis
                                            .split('</br>')[0],
                                    subTitle29: !caseStudyListModelData[index]
                                            .caseStudyList[index1]
                                            .chiefComplaintAdmitDiagnosis
                                            .contains('</br>')
                                        ? null
                                        : caseStudyListModelData[index]
                                            .caseStudyList[index1]
                                            .chiefComplaintAdmitDiagnosis
                                            .split('</br>')[1],
                                    buttonTitle: caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .status ==
                                        "2"
                                        ? "View"
                                        : null,
                                    btnSvgImage: caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .status ==
                                        "2"
                                        ? "assets/images/eye.svg"
                                        : null,
                                    navigateButton: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WebRedirectionWithLoadingScreen(
                                                url: webUrlEditView,
                                                // url: "https://formsmarts.com/html-form-example",
                                                screenTitle: caseStudyListModelData[index]
                                                    .caseStudyList[index1]
                                                    .type == "PACR" ? "PACR View" : caseStudyListModelData[index]
                                                    .caseStudyList[index1]
                                                    .type == "Floor"
                                                    ? "Floor Therapy View"
                                                    : "Adult ICU & NICU/PICU View",
                                                onSuccess: () async {
                                                  setState(() {
                                                    getStudentCaseStudyListData();
                                                    pullToRefresh();
                                                  });
                                                },
                                                onFail: () async {
                                                  setState(() {
                                                    getStudentCaseStudyListData();
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
                                                // },
                                              ),
                                        ),
                                      );
                                    },
                                    btnSvgImage1: caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .status ==
                                        "2"
                                        ? "assets/images/eye.svg"
                                    : caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .status ==
                                        "3"
                                        ? "assets/images/Edit.svg"
                                        : null,
                                    buttonTitle1: caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .status ==
                                        "2"
                                        ? "View" : caseStudyListModelData[index]
                                        .caseStudyList[index1]
                                        .status ==
                                        "3" ? "Edit"
                                        : null,
                                    navigateButton1: () async {
                                      switch (caseStudyListModelData[index]
                                          .caseStudyList[index1].status) {
                                        case "2":
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WebRedirectionWithLoadingScreen(
                                                    url: webUrlEditView,
                                                    // url: "https://formsmarts.com/html-form-example",
                                                    screenTitle: caseStudyListModelData[index]
                                                        .caseStudyList[index1]
                                                        .type ==
                                                        "PACR" ? "PACR View" : caseStudyListModelData[index]
                                                        .caseStudyList[index1]
                                                        .type ==
                                                        "Floor"
                                                        ? "Floor Therapy View"
                                                        : "Adult ICU & NICU/PICU View",
                                                    onSuccess: () async {
                                                      setState(() {
                                                        getStudentCaseStudyListData();
                                                        pullToRefresh();
                                                      });
                                                    },
                                                    onFail: () async {
                                                      setState(() {
                                                        getStudentCaseStudyListData();
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
                                                    // },
                                                  ),
                                            ),
                                          );
                                          break;
                                        case "3":
                                          Navigator.push(
                                            context,
                                            // MaterialPageRoute(builder: (context) => WebRedirectionScreen(url: 'https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A=')),
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                // WebRedirectionScreen(url: webUrl, navigationRequestCallback: (NavigationRequest request) {if (request.url.contains('${cancel}')) {Navigator.pop(context);return NavigationDecision.prevent;}return NavigationDecision.navigate;},)
                                                WebRedirectionWithLoadingScreen(
                                                  url: webUrlEditView,
                                                  screenTitle: caseStudyListModelData[index]
                                                      .caseStudyList[index1]
                                                      .type ==
                                                      "PACR" ? "Edit PACR" : caseStudyListModelData[index]
                                                      .caseStudyList[index1]
                                                      .type ==
                                                      "Floor"
                                                      ? "Edit Floor Therapy"
                                                      : "Edit Adult ICU & NICU/PICU",
                                                  onSuccess: () async {
                                                    setState(() {
                                                      getStudentCaseStudyListData();
                                                      pullToRefresh()
                                                          .then((value) {
                                                        common_alert_pop(
                                                            context,
                                                            'Case Study Updated\nSuccessfully',
                                                            'assets/images/success_Icon.svg',
                                                                () {
                                                              Navigator.pop(context);
                                                            });
                                                      });
                                                    });
                                                  },
                                                  onFail: () async {
                                                    setState(() {
                                                      getStudentCaseStudyListData();
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
                                    verticalDivider: VerticalDivider(  thickness: 1,
                                      color: Color(0x3001A750),),
                                    btnSvgImage2: caseStudyListModelData[index]
                                                .caseStudyList[index1]
                                                .school ==
                                            "No"
                                        ? "assets/images/trash1.svg"
                                        : null,
                                    buttonTitle2: caseStudyListModelData[index]
                                                .caseStudyList[index1]
                                                .school ==
                                            "No"
                                        ? "Delete"
                                        : null,
                                    navigateButton2: () {
                                      common_popup_widget(
                                          context,
                                          'Do you want to delete Case Study?',
                                          'assets/images/deleteicon.svg',
                                          () async {
                                        // Navigator.pop(context);
                                        Box<UserLoginResponseHive>? box =
                                            Boxes.getUserInfo();
                                        final DataService dataService = locator();
                                        final DataResponseModel
                                            dataResponseModel =
                                            await dataService.deleteData(
                                          caseStudyListModelData[index]
                                              .caseStudyList[index1]
                                              .caseStudyId,
                                          box
                                              .get(Hardcoded.hiveBoxKey)!
                                              .loggedUserId,
                                          box
                                              .get(Hardcoded.hiveBoxKey)!
                                              .accessToken,
                                          "interaction | attendance | incident | volunteerEval | PACR | Adult | Floor",
                                          "${caseStudyListModelData[index].caseStudyList[index1].type}",
                                        );
                                        // log("${dataResponseModel.success}");
                                        if (dataResponseModel.success) {
                                          delete.success();
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            Navigator.pop(context);
                                            AppHelper.buildErrorSnackbar(context,
                                                "Case Study deleted successfully");
                                            getStudentCaseStudyListData();
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
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
