import 'dart:convert';
import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_add_button.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_green_rotation.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_notify_again_widget.dart';
import 'package:clinicaltrac/common/common_notify_popup_widget.dart';
import 'package:clinicaltrac/common/common_send_email_widget.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_copy_url_response_model.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/daily_weekly/models/daily_weekly_response.dart';
import 'package:clinicaltrac/view/daily_weekly/view/add_dailyweekly_screen.dart';
import 'package:clinicaltrac/view/daily_weekly/vm_connector/add_dailyweekly_vm_connector.dart';
import 'package:clinicaltrac/view/daily_weekly/vm_connector/daily_weekly_vm_connector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:clinicaltrac/view/web_redirection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class dailyWeeklyScreen extends StatefulWidget {
  UserLoginResponse userLoginResponse;
  Rotation? rotation;
  RotationListStudentJournal rotationListStudentJournal;
  DailyJournalRoute route;

  dailyWeeklyScreen(
      {super.key,
      required this.userLoginResponse,
      this.rotation,
      required this.rotationListStudentJournal,
      required this.route});

  @override
  State<dailyWeeklyScreen> createState() => _dailyWeeklyScreenState();
}

class _dailyWeeklyScreenState extends State<dailyWeeklyScreen> {
  bool isSearchClicked = false;
  String? selectedRotation;
  String? selectedRotationId;
  List<String> items = [];
  int pageNo = 1;
  int lastPage = 1;
  bool isDataLoaded = true;
  bool dataNotfound = true;
  TextEditingController searchQuery = TextEditingController();
  TextEditingController phoneNmber = MaskedTextController(mask: '000-000-0000');

  // ScrollController _scrollController = ScrollController();
  List<DailyWeeklyData> dailyWeeklyList = [];
  CopyUrlData copyUrlData = CopyUrlData();
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

  Future<void> getdailyWeeklyList() async {
    if (pageNo == 1 || pageNo <= lastPage) {
      if (mounted) {
        setState(() {
          isDataLoaded = true;
        });
      }
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      CommonRequest dailyWeeklyRequest = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          // RecordsPerPage: '10',
          SearchText: searchQuery.text,
          RotationId: selectedRotationId!);
      // RotationId: widget.route == DailyJournalRoute.direct ? selectedRotationId : widget.rotation!.rotationId);
      final DataService dataService = locator();
      DataResponseModel dataResponseModel =
          await dataService.getDailyWeekly(dailyWeeklyRequest);
      DailyWeeklyResponse dailyWeeklyResponse =
          DailyWeeklyResponse.fromJson(dataResponseModel.data);
// log("${dataResponseModel.data}");
      lastPage =
          (int.parse(dailyWeeklyResponse.pager!.totalRecords!) / 10).ceil();
      if (dailyWeeklyResponse.pager!.totalRecords == '0') {
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
      setState(() {
        if (pageNo != 1) {
          dailyWeeklyList.addAll(dailyWeeklyResponse.data);
        } else {
          dailyWeeklyList = dailyWeeklyResponse.data;
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
    if (widget.rotationListStudentJournal.data.isEmpty) {
      selectedRotation = items[0];
    } else {
      if (widget.route == DailyJournalRoute.direct)
        setValue();
      else {
        selectedRotation = widget.rotation!.rotationTitle.isNotEmpty &&
                widget.rotation!.hospitalTitle.isNotEmpty
            ? "${widget.rotation!.rotationTitle} (${widget.rotation!.hospitalTitle})"
            : selectedRotation;
        // selectedRotation = widget.rotation!.rotationTitle;
        selectedRotationId = widget.rotation!.rotationId;
        rotationEvalList = widget.rotationListStudentJournal.data!;
      }
    }
    // setValue();
    getdailyWeeklyList();

    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> pullToRefresh() async {
    // isDataLoaded = true;
    pageNo = 1;
    getdailyWeeklyList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  @override
  Widget build(BuildContext context) {
    rotationEvalList = widget.rotationListStudentJournal.data!;
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          title: "Daily/Weekly Evaluation",
        ),
        backgroundColor: Color(Hardcoded.white),
        floatingActionButton: widget.route == DailyJournalRoute.direct
            ? commonAddButton(onTap: () async {
                final phoneNumber = await Navigator.pushNamed(
                    context, Routes.addDailyWeeklyScreen,
                    arguments: AddDailyWeeklyRoutingData(
                        rotation: '',
                        rotationId: '',
                        viewType: DailyJournalViewType.addDash));
                if (phoneNumber.toString() != '' &&
                    phoneNumber.toString().isNotEmpty &&
                    phoneNumber != null)
                  common_alert_pop(
                      context,
                      'Successfully created\nEvaluation and SMS has been sent.',
                      'assets/images/success_Icon.svg', () {
                    Navigator.pop(context);
                  });
                pullToRefresh();
              })
            : !widget.rotation!.isHospitalSiteActive
                ? null
                : commonAddButton(onTap: () async {
                    final phoneNumber = await Navigator.pushNamed(
                        context, Routes.addDailyWeeklyScreen,
                        arguments: AddDailyWeeklyRoutingData(
                            rotation:
                                "${widget.rotation!.rotationTitle} (${widget.rotation!.hospitalTitle})",
                            rotationId: widget.rotation!.rotationId,
                            viewType: DailyJournalViewType.add));
                    if (phoneNumber.toString() != '' &&
                        phoneNumber.toString().isNotEmpty &&
                        phoneNumber != null)
                      common_alert_pop(
                          context,
                          'Successfully created\nEvaluation and SMS has been sent.',
                          'assets/images/success_Icon.svg', () {
                        Navigator.pop(context);
                      });
                    getdailyWeeklyList();
                  }),
        body: widget.route == DailyJournalRoute.direct
            ? Stack(children: [
                listModule(),
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
                        getdailyWeeklyList();
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
                                                  color: Color(
                                                      Hardcoded.greyText)))
                                      : Container(),
                                ])),
                      );
                    })),
                  ),
                ),
              ])
            : Column(
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
                    child: listModule(),
                  )
                ],
              ),
      ),
    );
  }

  Padding listModule() {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.route == DailyJournalRoute.direct ? 70.0 : 0),
      child: Visibility(
        visible: isDataLoaded && pageNo == 1,
        child: common_loader(),
        replacement: Visibility(
          visible: dataNotfound,
          child: Padding(
            padding: EdgeInsets.only(bottom: globalHeight * 0.03),
            child: Align(
              alignment: Alignment.center,
              child: Center(
                child: NoDataFoundWidget(
                  title: "Daily/Weekly Evaluations not available",
                  imagePath: "assets/no_data_found.png",
                ),
              ),
            ),
          ),
          replacement: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: RefreshIndicator(
              onRefresh: () => pullToRefresh(),
              color: Color(0xFFBBBBC6),
              // child: SingleChildScrollView(
              //   physics: AlwaysScrollableScrollPhysics(),
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
                  padding: const EdgeInsets.only(left: 2, right: 2.0),
                  child: CupertinoScrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dailyWeeklyList.length,
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
                        int userId = int.parse(
                            "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                        String userIdEncr = userId.toString();
                        String userIdEncoded =
                            base64Encode(utf8.encode(userIdEncr));

                        int rotationId = widget.route ==
                                DailyJournalRoute.direct
                            ? int.parse("${dailyWeeklyList[index].rotationId}")
                            : int.parse("${widget.rotation!.rotationId}");
                        String rotationIdEncr = rotationId.toString();
                        String rotationIdEncoded =
                            base64Encode(utf8.encode(rotationIdEncr));

                        int evaluationId =
                            int.parse("${dailyWeeklyList[index].evaluationId}");
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
                                'daily/weekly' +
                                '&RotationId=' +
                                '${rotationIdEncoded}' +
                                '&RedirectId=' +
                                '${evaluationIdEncoded}' +
                                '&IsMobile=1';
                        // log("uuuuuuuuuuu--- ${webUrl}");

                        return CommonListContainerWidget(
                          mainTitle:
                              "Evaluation date : ${DateFormat("MMM dd, yyyy").format(dailyWeeklyList[index].evaluationDate!)}",
                          statusString: dailyWeeklyList[index].status == "0"
                              ? "Pending"
                              : dailyWeeklyList[index].status == "1" ||
                                      dailyWeeklyList[index].status == "2"
                                  ? "Completed"
                                  : null,
                          subTitle1: "Student sign date : ",
                          title1:
                              dailyWeeklyList[index].dateOfStudentSignature ==
                                      null
                                  ? "-"
                                  : DateFormat("MMM dd, yyyy").format(
                                      dailyWeeklyList[index]
                                          .dateOfStudentSignature!),
                          subTitle6: "Instructor/preceptor sign date : ",
                          title6: dailyWeeklyList[index]
                                      .dateOfInstructorSignature ==
                                  null
                              ? "-"
                              : DateFormat("MMM dd, yyyy").format(
                                  dailyWeeklyList[index]
                                      .dateOfInstructorSignature!),
                          subTitle19: "Preceptor : ",
                          title19: dailyWeeklyList[index]
                                          .preceptorDetails!
                                          .preceptorName ==
                                      '' ||
                                  dailyWeeklyList[index]
                                          .preceptorDetails!
                                          .preceptorMobile ==
                                      ''
                              ? ''
                              : "${dailyWeeklyList[index].preceptorDetails!.preceptorName} (${"${dailyWeeklyList[index].preceptorDetails!.preceptorMobile}".replaceRange(0, 8, "XXX-XXX-")})",
                          divider: dailyWeeklyList[index].status != "0"
                              ? Divider(
                                  thickness: 1,
                                )
                              : null,
                          subTitle7: dailyWeeklyList[index].avgAtten == ''
                              ? ''
                              : "Avg Atten : ",
                          title7: dailyWeeklyList[index].avgAtten == ''
                              ? ""
                              : dailyWeeklyList[index].avgAtten,
                          subTitle8: dailyWeeklyList[index].avgProfess == ''
                              ? ''
                              : "Avg Profess : ",
                          title8: dailyWeeklyList[index].avgProfess == ''
                              ? ""
                              : dailyWeeklyList[index].avgProfess,
                          subTitle9: dailyWeeklyList[index].avgPsych == ''
                              ? ''
                              : "Avg Psych : ",
                          title9: dailyWeeklyList[index].avgPsych == ''
                              ? ""
                              : dailyWeeklyList[index].avgPsych,
                          subTitle10: dailyWeeklyList[index].avgPsych == ''
                              ? ''
                              : "Total Average : ",
                          title10: dailyWeeklyList[index].avgTotal == ''
                              ? ""
                              : dailyWeeklyList[index].avgTotal,
                          subTitle12:
                              dailyWeeklyList[index].avgStudentPrep == ''
                                  ? ''
                                  : "Avg Student prep : ",
                          title12: dailyWeeklyList[index].avgStudentPrep == ''
                              ? ""
                              : dailyWeeklyList[index].avgStudentPrep,
                          subTitle13: dailyWeeklyList[index].avgKnow == ''
                              ? ''
                              : "Avg Know : ",
                          title13: dailyWeeklyList[index].avgKnow == ''
                              ? ""
                              : dailyWeeklyList[index].avgKnow,
                          subTitle14: dailyWeeklyList[index].avgOrg == ''
                              ? ''
                              : "Avg Org : ",
                          title14: dailyWeeklyList[index].avgOrg == ''
                              ? ""
                              : dailyWeeklyList[index].avgOrg,
                          buttonTitle: dailyWeeklyList[index].status == "0"
                              ? "Notify Again"
                              // : null,
                              : dailyWeeklyList[index].status == "1"
                                  ? "Signoff Evaluation"
                                  : "View Evaluation",
                          btnSvgImage: dailyWeeklyList[index].status == "0"
                              ? "assets/images/notify.svg"
                              // : null,
                              : dailyWeeklyList[index].status == "1"
                                  ? "assets/images/send-square.svg"
                                  : "assets/images/eye.svg",
                          navigateButton: () async {
                            switch (dailyWeeklyList[index].status) {
                              case "0":
                                phoneNmber.text = dailyWeeklyList[index]
                                    .preceptorDetails!
                                    .preceptorMobile;
                                await common_notify_popup_widget(
                                    context,
                                    "Resend SMS",
                                    "Copy URL",
                                    "Send URL to Email", () {
                                  Navigator.pop(context);
                                  showModalBottomSheet<void>(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30.0),
                                      ),
                                    ),
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return NotifyAgainBottomSheet(
                                        userId: box
                                            .get(Hardcoded.hiveBoxKey)!
                                            .loggedUserId,
                                        accessToken: box
                                            .get(Hardcoded.hiveBoxKey)!
                                            .accessToken,
                                        listId:
                                            dailyWeeklyList[index].evaluationId,
                                        type: "dailyEval",
                                        pullToRefresh: pullToRefresh,
                                        phoneNumber: dailyWeeklyList[index]
                                            .preceptorDetails!
                                            .preceptorMobile,
                                      );
                                    },
                                  );
                                }, () async {
                                  final DataService dataService = locator();
                                  CommonCopyUrlAndSendEmailRequest request =
                                      CommonCopyUrlAndSendEmailRequest(
                                    userId: box
                                        .get(Hardcoded.hiveBoxKey)!
                                        .loggedUserId,
                                    accessToken: box
                                        .get(Hardcoded.hiveBoxKey)!
                                        .accessToken,
                                    evaluationId:
                                        dailyWeeklyList[index].evaluationId,
                                    rotationId:
                                        widget.route == DailyJournalRoute.direct
                                            ? dailyWeeklyList[index].rotationId
                                            : widget.rotation!.rotationId,
                                    preceptorId: dailyWeeklyList[index]
                                        .preceptorDetails!
                                        .preceptorId,
                                    schoolTopicId: '',
                                    // loggedUserEmailId: widget.userLoginResponse.data.loggedUserEmail,
                                    isSendEmail: "false",
                                    evaluationType: "dailyEval",
                                    preceptorNum: dailyWeeklyList[index]
                                        .preceptorDetails!
                                        .preceptorMobile,
                                  );
                                  final DataResponseModel dataResponseModel =
                                      await dataService
                                          .copyAndEmailSendEval(request);
                                  CopyUrlResponseModel copyUrlResponseModel =
                                      CopyUrlResponseModel.fromJson(
                                          dataResponseModel.data);

                                  // log("${dataResponseModel.success}");
                                  // setState(() {
                                  if (dataResponseModel.success) {
                                    // notify.success();
                                    Navigator.pop(context);
                                    copyUrlData = copyUrlResponseModel.data;
                                    Future.delayed(Duration(seconds: 1),
                                        () async {
                                      Clipboard.setData(ClipboardData(
                                              text: "${copyUrlData.copyUrl}"))
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
                                }, () {
                                  Navigator.pop(context);
                                  showModalBottomSheet<void>(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30.0),
                                      ),
                                    ),
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return EmailSendBottomSheet(
                                        userId: box
                                            .get(Hardcoded.hiveBoxKey)!
                                            .loggedUserId,
                                        accessToken: box
                                            .get(Hardcoded.hiveBoxKey)!
                                            .accessToken,
                                        evaluationId:
                                            dailyWeeklyList[index].evaluationId,
                                        rotationId: widget.route ==
                                                DailyJournalRoute.direct
                                            ? dailyWeeklyList[index].rotationId
                                            : widget.rotation!.rotationId,
                                        preceptorId: dailyWeeklyList[index]
                                            .preceptorDetails!
                                            .preceptorId,
                                        schoolTopicId: '',
                                        loggedUserEmailId: store
                                            .state
                                            .studentDetailsResponse
                                            .data
                                            .loggedUserEmail,
                                        // loggedUserEmailId: widget.userLoginResponse.data.loggedUserEmail,
                                        isSendEmail: "true",
                                        evaluationType: "dailyEval",
                                        preceptorNum: dailyWeeklyList[index]
                                            .preceptorDetails!
                                            .preceptorMobile,
                                        // pullToRefresh: pullToRefresh,
                                      );
                                    },
                                  );
                                });
                                // await showModalBottomSheet<void>(
                                //   shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.vertical(
                                //       top: Radius.circular(30.0),
                                //     ),
                                //   ),
                                //   context: context,
                                //   isScrollControlled: true,
                                //   builder: (BuildContext context) {
                                //     return NotifyAgainBottomSheet(
                                //       userId: widget.userLoginResponse
                                //           .data.loggedUserId,
                                //       accessToken: widget
                                //           .userLoginResponse
                                //           .data
                                //           .accessToken,
                                //       listId: dailyWeeklyList[index]
                                //           .evaluationId,
                                //       type: "dailyEval",
                                //       pullToRefresh: pullToRefresh,
                                //       phoneNumber: dailyWeeklyList[index]
                                //           .preceptorDetails!
                                //           .preceptorMobile,
                                //     );
                                //   },
                                // );
                                break;
                              case "1":
                                Navigator.push(
                                  context,
                                  // MaterialPageRoute(builder: (context) => WebRedirectionScreen(url: 'https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A=')),
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        // WebRedirectionScreen(url: webUrl, navigationRequestCallback: (NavigationRequest request) {if (request.url.contains('${cancel}')) {Navigator.pop(context);return NavigationDecision.prevent;} else if (request.url.contains('${save}')) {Navigator.pop(context);common_alert_pop(context, 'Evaluation Successfully\nSigned Off', 'assets/images/success_Icon.svg', () {Navigator.pop(context);});getdailyWeeklyList();return NavigationDecision.prevent;}return NavigationDecision.navigate;},)
                                        // WebRedirectionWithLoadingScreen(
                                        WebRedirectionWithLoadingScreen(
                                      url: webUrl,
                                      // url: "https://formsmarts.com/html-form-example",
                                      screenTitle: "Daily/Weekly Signoff",
                                      onSuccess: () async {
                                        setState(() {
                                          getdailyWeeklyList();
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

                                        // Navigator.pushNamed(context,
                                        //     Routes.dailyWeeklyScreen,
                                        //     arguments:
                                        //         await DailyWeeklyRoutingData(
                                        //             rotation:
                                        //                 widget.rotation,
                                        //             route:
                                        //                 DailyJournalRoute
                                        //                     .rotation));
                                      },
                                      onFail: () async {
                                        setState(() {
                                          getdailyWeeklyList();
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
                                break;
                              case "2":
                                Navigator.push(
                                  context,
                                  // MaterialPageRoute(builder: (context) => WebRedirectionScreen(url: 'https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A=')),
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          // WebRedirectionScreen(url: webUrl, navigationRequestCallback: (NavigationRequest request) {if (request.url.contains('${cancel}')) {Navigator.pop(context);return NavigationDecision.prevent;}return NavigationDecision.navigate;},)
                                          WebRedirectionWithLoadingScreen(
                                            url: webUrl,
                                            screenTitle: "Daily/Weekly View",
                                            onSuccess: () async {
                                              setState(() {
                                                getdailyWeeklyList();
                                                pullToRefresh();
                                              });
                                            },
                                            onFail: () async {
                                              setState(() {
                                                getdailyWeeklyList();
                                                pullToRefresh();
                                              });
                                            },
                                            onError: () async {
                                              setState(() {
                                                // getdailyWeeklyList();
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
                                          )),
                                );
                                //    getdailyWeeklyList();
                                // pageNo=1;
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
    );
  }
}
