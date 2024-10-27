import 'dart:convert';
import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_add_button.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_notify_again_widget.dart';
import 'package:clinicaltrac/common/common_notify_popup_widget.dart';
import 'package:clinicaltrac/common/common_send_email_widget.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/common_copy_url_response_model.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/check_offs/model/checkoffs_list_model.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/check_offs/vm_connector/add_checkoffs_connector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/create_procedure_count_list_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class CheckOffsListScreen extends StatefulWidget {
  CheckOffsListScreen({
    Key? key,
    required this.userLoginResponse,
    required this.checkoffsListModel,
    required this.rotationListStudentJournal,
    this.rotation,
    required this.route,
    required this.rotationForEvalListModel,
    // required this.showAdd,
  }) : super(key: key);
  final UserLoginResponse userLoginResponse;
  final StudentCheckoffsListModel checkoffsListModel;
  RotationListStudentJournal rotationListStudentJournal;
  RotationForEvalListModel rotationForEvalListModel;
  DailyJournalRoute route;
  Rotation? rotation;

  // final bool showAdd;

  @override
  State<CheckOffsListScreen> createState() => _CheckOffsListScreenState();
}

class _CheckOffsListScreenState extends State<CheckOffsListScreen> {
  bool isSearchClicked = false;
  int pageNo = 1;
  int lastpage = 1;
  bool isDataLoaded = true;
  bool isFromCheckoff = true;
  bool isDataLoading = true;
  bool dataNotfound = false;
  TextEditingController textController = TextEditingController();
  TextEditingController searchQuery = TextEditingController();
  List<String> items = [];
  List<CheckoffsListData> checkoffsListData = [];
  CopyUrlData copyUrlData = CopyUrlData();
  String? selectedRotation = '';
  String? selectedRotationId = '';
  String? evaluationDate;
  final searchFocusNode = FocusNode();
  String isAllText = '';
  List<RotationJournalData> rotationEvalList = <RotationJournalData>[];
  RotationJournalData selectedRotationValue = new RotationJournalData();

  void setValue() {
    List<String> temp = [];
    for (var cnt in widget.rotationListStudentJournal.data) {
      temp.add(cnt.title!);
    }
    setState(() {
      items = temp;
      selectedRotation = widget.rotationListStudentJournal.data[0].title;
    });
    selectedRotationId = widget.rotationListStudentJournal.data[0].rotationId;
  }

  Future<void> getStudentCheckoffsList() async {
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
        pageNo: pageNo.toString(),
        RecordsPerPage: '5',
        RotationId: selectedRotationId!,
        SearchText: searchQuery.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getCheckoffsList(request);
      StudentCheckoffsListModel studentCheckoffsListModel =
          StudentCheckoffsListModel.fromJson(dataResponseModel.data);
      // log("${dataResponseModel.data}");
      lastpage =
          (int.parse(studentCheckoffsListModel.pager.totalRecords!) / 5).ceil();
      if (studentCheckoffsListModel.pager.totalRecords == '0') {
        if (mounted) {
          setState(() {
            dataNotfound = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            dataNotfound = false;
          });
        }
      }
      if (mounted) {
        setState(() {
          if (pageNo == 1)
            checkoffsListData = studentCheckoffsListModel.data;
          else {
            for (int i = 0; i < studentCheckoffsListModel.data.length; i++) {
              checkoffsListData.add(studentCheckoffsListModel.data[i]);
            }
          }
          // setState(() {
          //   if (pageNo != 1) {
          //     checkoffsListData.addAll(studentCheckoffsListModel.data);
          //   } else {
          //     checkoffsListData = studentCheckoffsListModel.data;
          //   }
          isDataLoaded = false;
        });
      }
    }
  }

  ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;
      getStudentCheckoffsList();
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
      selectedRotation = widget.rotationListStudentJournal.data![0].title;
      rotationEvalList = widget.rotationListStudentJournal.data!;
    } else {
      if (widget.route == DailyJournalRoute.direct)
        setValue();
      else {
        selectedRotation = widget.rotation!.rotationTitle;
        selectedRotationId = widget.rotation!.rotationId;
      }
    }

    getStudentCheckoffsList();

    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> pullToRefresh() async {
    pageNo = 1;
    getStudentCheckoffsList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return '${formattedDate} ';
    // ' ${formattedTime}';
  }

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
                          getStudentCheckoffsList();
                        },
                      ),
                    ),
                  ),
                )
              : Text("Checkoff",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      )),
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
              if (isSearchClicked == false) getStudentCheckoffsList();
            });
          },
        ),
        backgroundColor: Color(Hardcoded.white),
        body: items.length != 1
            // ? listModule()
            ? Stack(
                children: [
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
                        getStudentCheckoffsList();
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0,
                                    left: globalWidth * 0.06,
                                    right: globalWidth * 0.02,
                                    bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      title[0],
                                      // "wertuyiknbvc hgj zcxvbnm ryt ertyu zxcvcbvnb ret",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: Colors.black,
                                            // color:  selectedRotationValue.title == item.title &&  item.title != "All" ? Color(Hardcoded.primaryGreen):Colors.black,
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
                                                    color: Color(
                                                        Hardcoded.greyText)))
                                        // color: selectedRotationValue.title == item.title &&  item.title != "All" ? Color(Hardcoded.primaryGreen): Color(Hardcoded.greyText)))
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            // selectedRotationValue.title == item.title &&  selectedRotationValue.title != "All" ?  Padding(
                            //   padding: const EdgeInsets.only(right: 8.0),
                            //   child: Icon(Icons.check_rounded,color: Color(Hardcoded.primaryGreen),),
                            // ): SizedBox()
                          ],
                        ),
                      );
                    })),
                  ),
                  // child: CommonExpansion(
                  //   OnSelection: (String value) {
                  //     setState(() {
                  //       selectedRotation = value;
                  //       selectedRotationId = widget
                  //           .rotationListStudentJournal
                  //           .data[widget.rotationListStudentJournal.data
                  //               .indexWhere((element) =>
                  //                   element.title == selectedRotation)]
                  //           .rotationId;
                  //       pageNo = 1;
                  //       searchQuery.text = '';
                  //       isSearchClicked = false;
                  //       getStudentCheckoffsList();
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
                listModule(),
              ].reversed.map((e) => e).toList())
            : Center(
                child: Padding(
                    padding: EdgeInsets.only(bottom: globalHeight * 0.1),
                    child: NoDataFoundWidget(
                      title: "Checkoffs not available",
                      imagePath: "assets/no_data_found.png",
                    )),
              ),
        floatingActionButton: NoInternet(
          child: commonAddButton(
              // backgroundColor: Color(Hardcoded.orange),
              // child: Icon(
              //   Icons.add,
              //   size: 35,
              // ),
              onTap: () async {
            await Navigator.pushNamed(context, Routes.addCheckoffScreen,
                arguments: AddCheckoffRoutingData(rotation: widget.rotation));
            // AddCheckoffRoutingData(rotationId: widget.rotationForEvalListModel!.data.first.rotationId, rotationTitle: widget.rotationForEvalListModel!.data.first.title,)
            //   AddCheckOffsScreen(
            //       JournalId: widget.rotation?.rotationTitle,
            //       viewType: DailyJournalViewType.add)
            pullToRefresh();
            // getStudentCheckoffsList();
          }),
        ),
      ),
    );
  }

  Box<UserLoginResponseHive>? box = Boxes.getUserInfo();

  Padding listModule() {
    return Padding(
      // padding: EdgeInsets.only(top: 1.0),
      padding: EdgeInsets.only(top: 80.0),
      child: Visibility(
        visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
        child: common_loader(),
        replacement: Visibility(
          visible: dataNotfound,
          child: isSearchClicked
              ? Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      //height: 100,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: globalHeight * 0.1),
                        child: NoDataFoundWidget(
                          title: "No data found",
                          // title: "Checkoffs not available",
                          imagePath: "assets/no_data_found.png",
                        ),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      //height: 100,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: globalHeight * 0.1),
                        child: NoDataFoundWidget(
                          // title: "No data found",
                          title: "Checkoffs not available",
                          imagePath: "assets/no_data_found.png",
                        ),
                      ),
                    ),
                  ),
                ),
          replacement: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: SlidableAutoCloseBehavior(
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
                  child: SlidableAutoCloseBehavior(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2.0),
                      child: CupertinoScrollbar(
                        controller: _scrollController,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: checkoffsListData.length,
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Box<UserLoginResponseHive>? box =
                                  Boxes.getUserInfo();
                              // log("***************** ${checkoffsListData[index].status}");
                              evaluationDate = checkoffsListData[index]
                                          .studentEvaluationDate !=
                                      ""
                                  ? dateConvert(checkoffsListData[index]
                                      .studentEvaluationDate)
                                  : '';

                              int userId = int.parse(
                                  "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                              String userIdEncr = userId.toString();
                              String userIdEncoded =
                                  base64Encode(utf8.encode(userIdEncr));

                              int rotationId = widget.route ==
                                      DailyJournalRoute.direct
                                  ? int.parse(
                                      "${checkoffsListData[index].rotationId}")
                                  : int.parse("${widget.rotation!.rotationId}");
                              String rotationIdEncr = rotationId.toString();
                              String rotationIdEncoded =
                                  base64Encode(utf8.encode(rotationIdEncr));

                              int evaluationId = int.parse(
                                  "${checkoffsListData[index].checkoffId}");
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
                                      'checkoff' +
                                      '&RotationId=' +
                                      '${rotationIdEncoded}' +
                                      '&RedirectId=' +
                                      '${evaluationIdEncoded}' +
                                      '&IsMobile=1';
                              // log("uuuuuuuuuuuu ${webUrl}");
                              return CommonListContainerWidget(
                                mainTitle:
                                    "Checkoff date : ${dateConvert("${checkoffsListData[index].checkoffDateTime}")}",
                                statusString:
                                    checkoffsListData[index].checkoffType ==
                                            "advance"
                                        ? null
                                        : checkoffsListData[index].status == "0"
                                            ? "Pending"
                                            : checkoffsListData[index].status ==
                                                        "1" ||
                                                    checkoffsListData[index]
                                                            .status ==
                                                        "2"
                                                ? "Completed"
                                                : null,
                                subTitle1: "Rotation name : ",
                                title1: checkoffsListData[index].rotationName,
                                subTitle3: "Topic : ",
                                title3: checkoffsListData[index].topicTitle,
                                // subTitle3: "Topic status: ", title3: checkoffsListData[index].status,
                                subTitle20: "Student sign date : ",
                                title20: checkoffsListData[index]
                                            .studentEvaluationDate !=
                                        ""
                                    ? dateConvert(checkoffsListData[index]
                                        .studentEvaluationDate)
                                    : "-",
                                subTitle21:
                                    checkoffsListData[index].checkoffType ==
                                                    "advance" &&
                                                checkoffsListData[index]
                                                    .preceptorDetails!
                                                    .preceptorName
                                                    .isEmpty ||
                                            checkoffsListData[index]
                                                .preceptorDetails!
                                                .preceptorName
                                                .isEmpty
                                        ? null
                                        : "Preceptor : ",
                                title21: checkoffsListData[index]
                                            .checkoffType ==
                                        "advance"
                                    ? null
                                    : checkoffsListData[index]
                                                .preceptorDetails!
                                                .preceptorName
                                                .isEmpty ||
                                            checkoffsListData[index]
                                                .preceptorDetails!
                                                .preceptorName
                                                .isEmpty
                                        ? null
                                        : "${checkoffsListData[index].preceptorDetails!.preceptorName} (${"${checkoffsListData[index].preceptorDetails!.preceptorMobile}".replaceRange(0, 8, "XXX-XXX-")})",
                                subTitle7: checkoffsListData[index].clinicianComment == ''
                                    ? ''
                                    : "Clinician Comment : ",
                                title7: checkoffsListData[index].clinicianComment == ''
                                    ? ''
                                    : checkoffsListData[index].clinicianComment,
                                subTitle12: checkoffsListData[index].studentComment == ''
                                    ? ''
                                    : "Student Comment : ",
                                title12: checkoffsListData[index].studentComment == ''
                                    ? ''
                                    : checkoffsListData[index].studentComment,
                                score: checkoffsListData[index].checkoffType ==
                                            "advance" ||
                                        checkoffsListData[index].status == "0"
                                    ? null
                                    : checkoffsListData[index]
                                        .studentCheckoffScore
                                        .toString(),

                                // buttonTitle: checkoffsListData[index]
                                //             .checkoffType ==
                                //         "advance"
                                //     ? "Procedure Count"
                                //     : checkoffsListData[index].status == "1" ||
                                //             checkoffsListData[index].status ==
                                //                 "2"
                                //         ? "Procedure Count"
                                //         : null,
                                // navigateButton: () {
                                //   Navigator.of(context).push(
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           CreateProcedureCountListScreen(
                                //         rotationId:
                                //             checkoffsListData[index].rotationId,
                                //         isFromCheckoff: isFromCheckoff,
                                //         checkOffId:
                                //             checkoffsListData[index].checkoffId,
                                //       ),
                                //     ),
                                //   );
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => WebRedirectionScreen(url: 'https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A=',)),
                                // );
                                // },
                                buttonTitle1: "Procedure Count",
                                navigateButton1: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateProcedureCountListScreen(
                                        rotationId:
                                            checkoffsListData[index].rotationId,
                                        isFromCheckoff: isFromCheckoff,
                                        checkOffId:
                                            checkoffsListData[index].checkoffId,
                                      ),
                                    ),
                                  );
                                },
                                verticalDivider: VerticalDivider(
                                  thickness: 1,
                                  color: Color(0x3001A750),
                                ),
                                btnSvgImage2: store.state.userLoginResponse.data
                                                .loggedUserSchoolType !=
                                            "Advanced" &&
                                        checkoffsListData[index].status == "0"
                                    ? "assets/images/notify.svg"
                                    // : null,
                                    : checkoffsListData[index].status == "1"
                                        ? "assets/images/send-square.svg"
                                        : "assets/images/eye.svg",
                                buttonTitle2: store.state.userLoginResponse.data
                                                .loggedUserSchoolType !=
                                            "Advanced" &&
                                        checkoffsListData[index].status == "0"
                                    ? "Notify Again"
                                    // : null,
                                    : checkoffsListData[index].status == "1"
                                        ? "Signoff"
                                        : "View",

                                navigateButton2: () async {
                                  // switch (checkoffsListData[index].status) {
                                  // case "0":
                                  store.state.userLoginResponse.data
                                                  .loggedUserSchoolType !=
                                              "Advanced" &&
                                          checkoffsListData[index].status == "0"
                                      ? await common_notify_popup_widget(
                                          context,
                                          "Resend SMS",
                                          "Copy URL",
                                          "Send URL to Email",
                                          () {
                                            Navigator.pop(context);
                                            showModalBottomSheet<void>(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(30.0),
                                                ),
                                              ),
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return NotifyAgainBottomSheet(
                                                  userId: widget
                                                      .userLoginResponse
                                                      .data
                                                      .loggedUserId,
                                                  accessToken: widget
                                                      .userLoginResponse
                                                      .data
                                                      .accessToken,
                                                  listId:
                                                      checkoffsListData[index]
                                                          .checkoffId,
                                                  type: "checkoff",
                                                  pullToRefresh: pullToRefresh,
                                                  phoneNumber:
                                                      checkoffsListData[index]
                                                          .preceptorDetails!
                                                          .preceptorMobile,
                                                );
                                              },
                                            );
                                          },
                                          () async {
                                            final DataService dataService =
                                                locator();
                                            CommonCopyUrlAndSendEmailRequest
                                                request =
                                                CommonCopyUrlAndSendEmailRequest(
                                              userId: widget.userLoginResponse
                                                  .data.loggedUserId,
                                              accessToken: widget
                                                  .userLoginResponse
                                                  .data
                                                  .accessToken,
                                              evaluationId:
                                                  checkoffsListData[index]
                                                      .checkoffId,
                                              rotationId:
                                                  checkoffsListData[index]
                                                      .rotationId,
                                              preceptorId:
                                                  checkoffsListData[index]
                                                      .preceptorDetails!
                                                      .preceptorId,
                                              schoolTopicId:
                                                  checkoffsListData[index]
                                                      .topicId,
                                              // loggedUserEmailId: widget.userLoginResponse.data.loggedUserEmail,
                                              isSendEmail: "false",
                                              evaluationType: "checkoff",
                                              preceptorNum:
                                                  checkoffsListData[index]
                                                      .preceptorDetails!
                                                      .preceptorMobile,
                                            );
                                            final DataResponseModel
                                                dataResponseModel =
                                                await dataService
                                                    .copyAndEmailSendEval(
                                                        request);
                                            CopyUrlResponseModel
                                                copyUrlResponseModel =
                                                CopyUrlResponseModel.fromJson(
                                                    dataResponseModel.data);

                                            // log("${dataResponseModel.success}");
                                            // setState(() {
                                            if (dataResponseModel.success) {
                                              // notify.success();
                                              Navigator.pop(context);
                                              copyUrlData =
                                                  copyUrlResponseModel.data;
                                              Future.delayed(
                                                  Duration(seconds: 1),
                                                  () async {
                                                Clipboard.setData(ClipboardData(
                                                        text:
                                                            "${copyUrlData.copyUrl}"))
                                                    .whenComplete(() {});
                                                // await pullToRefresh();
                                                if (mounted) {
                                                  AppHelper.buildErrorSnackbar(
                                                      context, "Link copied");
                                                }
                                              });
                                            }
                                            //  setState(() {isDataLoaded = false;
                                            // });
                                          },
                                          () {
                                            Navigator.pop(context);
                                            showModalBottomSheet<void>(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(30.0),
                                                ),
                                              ),
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return EmailSendBottomSheet(
                                                  userId: box
                                                      .get(
                                                          Hardcoded.hiveBoxKey)!
                                                      .loggedUserId,
                                                  accessToken: box
                                                      .get(
                                                          Hardcoded.hiveBoxKey)!
                                                      .accessToken,
                                                  evaluationId:
                                                      checkoffsListData[index]
                                                          .checkoffId,
                                                  rotationId:
                                                      checkoffsListData[index]
                                                          .rotationId,
                                                  preceptorId:
                                                      checkoffsListData[index]
                                                          .preceptorDetails!
                                                          .preceptorId,
                                                  schoolTopicId:
                                                      checkoffsListData[index]
                                                          .topicId,
                                                  loggedUserEmailId: store
                                                      .state
                                                      .studentDetailsResponse
                                                      .data
                                                      .loggedUserEmail,
                                                  // loggedUserEmailId: widget.userLoginResponse.data.loggedUserEmail,
                                                  isSendEmail: "true",
                                                  evaluationType: "checkoff",
                                                  preceptorNum:
                                                      checkoffsListData[index]
                                                          .preceptorDetails!
                                                          .preceptorMobile,
                                                  // pullToRefresh: pullToRefresh,
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : checkoffsListData[index].status == "1"
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    // WebRedirectionScreen(url: webUrl, navigationRequestCallback: (NavigationRequest request) {if (request.url.contains('${cancel}')) {Navigator.pop(context);return NavigationDecision.prevent;} else if (request.url.contains('${save}')) {Navigator.pop(context);common_alert_pop(context, 'Evaluation Successfully\nSigned Off', 'assets/images/success_Icon.svg', () {Navigator.pop(context);});getdailyWeeklyList();return NavigationDecision.prevent;}return NavigationDecision.navigate;},)
                                                    WebRedirectionWithLoadingScreen(
                                                  url: webUrl,
                                                  screenTitle:
                                                      "Checkoff Signoff",
                                                  onSuccess: () async {
                                                    setState(() {
                                                      getStudentCheckoffsList();
                                                      pullToRefresh()
                                                          .then((value) {
                                                        common_alert_pop(
                                                            context,
                                                            'Checkoff Successfully\nSigned Off',
                                                            'assets/images/success_Icon.svg',
                                                            () {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      });
                                                    });
                                                  },
                                                  onFail: () async {
                                                    setState(() {
                                                      getStudentCheckoffsList();
                                                      pullToRefresh();
                                                    });
                                                  },
                                                  onError: () {
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
                                                  // },
                                                ),
                                              ),
                                            )
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    // WebRedirectionScreen(url: webUrl, navigationRequestCallback: (NavigationRequest request) {if (request.url.contains('${cancel}')) {Navigator.pop(context);return NavigationDecision.prevent;} else if (request.url.contains('${save}')) {Navigator.pop(context);common_alert_pop(context, 'Evaluation Successfully\nSigned Off', 'assets/images/success_Icon.svg', () {Navigator.pop(context);});getdailyWeeklyList();return NavigationDecision.prevent;}return NavigationDecision.navigate;},)
                                                    WebRedirectionWithLoadingScreen(
                                                  url: webUrl,
                                                  screenTitle: "Checkoff View",
                                                  onSuccess: () async {
                                                    setState(() {
                                                      getStudentCheckoffsList();
                                                      pullToRefresh();
                                                    });
                                                  },
                                                  onFail: () async {
                                                    setState(() {
                                                      getStudentCheckoffsList();
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
                                                ),
                                              ),
                                            );
                                  // }
                                  // : null;
                                  ////
                                  // ? await showModalBottomSheet<void>(
                                  //          shape: RoundedRectangleBorder(
                                  //            borderRadius: BorderRadius.vertical(
                                  //              top: Radius.circular(30.0),
                                  //            ),
                                  //          ),
                                  //          context: context,
                                  //          isScrollControlled: true,
                                  //          builder: (BuildContext context) {
                                  //            return NotifyAgainBottomSheet(
                                  //              userId: widget.userLoginResponse.data
                                  //                  .loggedUserId,
                                  //              accessToken: widget.userLoginResponse
                                  //                  .data.accessToken,
                                  //              listId: checkoffsListData[index]
                                  //                  .checkoffId,
                                  //              type: "checkoff",
                                  //              pullToRefresh: pullToRefresh,
                                  //              phoneNumber: checkoffsListData[index]
                                  //                  .preceptorDetails!
                                  //                  .preceptorMobile,
                                  //            );
                                  //          },
                                  //        )
                                  //  : null;
                                },
                                divider:
                                    checkoffsListData[index].checkoffType ==
                                            "advance"
                                        ? Divider(
                                            thickness: 1,
                                          )
                                        : null,
                                subTitle17: "Student : ",
                                title17: checkoffsListData[index]
                                            .checkoffType ==
                                        "advance"
                                    ? checkoffsListData[index]
                                                .studentCheckoffScore !=
                                            '0'
                                        ? '${checkoffsListData[index].studentCheckoffScore}%'
                                        : '-'
                                    : '',
                                subTitle18: "Lab : ",
                                title18:
                                    checkoffsListData[index].checkoffType ==
                                            "advance"
                                        ? checkoffsListData[index].selectedLab
                                        : '',
                                subTitle22: "Preceptor : ",
                                title22: checkoffsListData[index]
                                            .checkoffType ==
                                        "advance"
                                    ? checkoffsListData[index]
                                                .selectedPreceptor !=
                                            '0'
                                        ? '${checkoffsListData[index].selectedPreceptor}%'
                                        : '-'
                                    : '',
                                subTitle23: "Clinical : ",
                                title23: checkoffsListData[index]
                                            .checkoffType ==
                                        "advance"
                                    ? checkoffsListData[index].selectedClinical
                                    : '',
                              );
                            }),
                      ),
                    ),
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
