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
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_copy_url_response_model.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/common_type_list_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/model/pef_list_model.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/model/pef_type_list_model.dart';
import 'package:clinicaltrac/view/check_offs/vm_connector/add_checkoffs_connector.dart';
import 'package:clinicaltrac/view/floor_therapy/model/floor_list_model.dart';
import 'package:clinicaltrac/view/floor_therapy/vm_connector/add_floorTherapy_vm_connector.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class FloorTherapyListScreen extends StatefulWidget {
  FloorTherapyListScreen({
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
  State<FloorTherapyListScreen> createState() => _FloorTherapyListScreenState();
}

class _FloorTherapyListScreenState extends State<FloorTherapyListScreen> {
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<FloorTherapyListData> floorTherapyData = [];
  CopyUrlData copyUrlData = CopyUrlData();
  bool isDataLoaded = true;
  bool isSearchClicked = false;
  String? evaluationDate;
  TextEditingController textController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController phoneNmber = MaskedTextController(mask: '000-000-0000');
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  List<CommonTypeListModel> commonTypeList = [
    CommonTypeListModel(
      type: "all",
      typeName: "All",
    ),
    CommonTypeListModel(
      type: "floor",
      typeName: "Floor Therapy",
    ),
    CommonTypeListModel(
      type: "icu",
      typeName: "ICU/ABG Rotation",
      // typeName: "ICU Evaluation",
    ),
  ];

  Future<void> getfloorTherapyData() async {
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
        type: commonTypeList[_selectedIndex].type,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        SearchText: searchTextController.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getFloorList(request);
      FloorTherapyListModel floorTherapyListModel =
          FloorTherapyListModel.fromJson(dataResponseModel.data);
      // log("Total Count ${commonTypeList[_selectedIndex].typeName}");
      // log("Acc--------- ${ box.get(Hardcoded.hiveBoxKey)!.accessToken} user----${ box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
      // log("Data--------- ${dataResponseModel.data}");
      lastpage =
          (int.parse(floorTherapyListModel.pager.totalRecords!) / 10).ceil();
      if (floorTherapyListModel.pager.totalRecords == '0') {
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
          floorTherapyData.addAll(floorTherapyListModel.data);
        } else {
          floorTherapyData = floorTherapyListModel.data;
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
      getfloorTherapyData();
    }
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    searchTextController.text = '';
    getfloorTherapyData();
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

    getfloorTherapyData();
  }

  List<Color> initialColor = [
    Color(Hardcoded.blue),
    Color(Hardcoded.orange),
    Color(Hardcoded.purple),
    Color(Hardcoded.pink)
  ];

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return '${formattedDate} ';
  }

  int _selectedIndex = 0;
  final searchFocusNode = FocusNode();
  String floorIcuType = '';

  @override
  Widget build(BuildContext context) {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    return Scaffold(
      appBar: CommonAppBar(
        titles: Text(
          "Floor Therapy & ICU Evaluation",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 21,
              ),
        ),
      ),
      floatingActionButton: !widget.rotation.isHospitalSiteActive
          ? null
          : _selectedIndex == 1
              ? commonAddButton(onTap: () async {
                  final phoneNumber = await Navigator.pushNamed(
                      context, Routes.addFloorTherapyScreen,
                      arguments: AddFloorTherapyRoutingData(
                          rotation: widget.rotation));
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
              : null,
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
                itemCount: commonTypeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      pageNo = 1;
                      getfloorTherapyData();
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
                          left: globalWidth * 0.1,
                          right: globalWidth * 0.08,
                          // left: globalWidth * 0.06, right: globalWidth * 0.06,
                        ),
                        child: Container(
                          height: globalHeight * 0.06,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                        title: "Floor Therapy & ICU Evaluations not available",
                        // title: "No data found",
                        imagePath: "assets/no_data_found.png",
                      )),
                ),
                child: Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 1,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                        getfloorTherapyData();
                      });
                    },
                    itemBuilder: (context, index) {
                      floorIcuType = floorTherapyData[index].type;
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
                            padding: const EdgeInsets.only(left: 2, right: 2.0),
                            child: CupertinoScrollbar(
                              controller: _scrollController,
                              child: ListView.builder(
                                itemCount: floorTherapyData.length,
                                shrinkWrap: true,
                                controller: _scrollController,
                                itemBuilder:
                                    (BuildContext context, int index1) {
                                  Box<UserLoginResponseHive>? box =
                                      Boxes.getUserInfo();
                                  // log("***************** ${checkoffsListData[index].status}");
                                  evaluationDate =
                                      floorTherapyData[index1].evaluationDate !=
                                              ""
                                          ? dateConvert(floorTherapyData[index1]
                                              .evaluationDate)
                                          : '';
                                  int userId = int.parse(
                                      "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                                  String userIdEncr = userId.toString();
                                  String userIdEncoded =
                                      base64Encode(utf8.encode(userIdEncr));

                                  int rotationId = int.parse(
                                      "${floorTherapyData[index1].rotationId}");
                                  String rotationIdEncr = rotationId.toString();
                                  String rotationIdEncoded =
                                      base64Encode(utf8.encode(rotationIdEncr));

                                  int evaluationId = int.parse(
                                      "${floorTherapyData[index1].evaluationId}");
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
                                          'floorTherapy' +
                                          '&RotationId=' +
                                          '${rotationIdEncoded}' +
                                          '&RedirectId=' +
                                          '${evaluationIdEncoded}' +
                                          '&IsMobile=1';
                                  // log("uuuuuuuuuuuu ${webUrl}");
                                  return CommonListContainerWidget(
                                    mainTitle:
                                        "Evaluation Date : ${dateConvert("${floorTherapyData[index1].evaluationDate!}")}",
                                    statusString:
                                        floorTherapyData[index1].status == "0"
                                            ? "Pending"
                                            : floorTherapyData[index1].status ==
                                                        "1" ||
                                                    floorTherapyData[index1]
                                                            .status ==
                                                        "2"
                                                ? "Completed"
                                                : null,
                                    subTitle1: "Type : ",
                                    title1: floorTherapyData[index1].type,
                                    subTitle20: "Student sign date : ",
                                    title20: floorTherapyData[index1]
                                                .dateOfStudentSignature ==
                                            null
                                        ? "-"
                                        : "${DateFormat("MMM dd, yyyy").format(floorTherapyData[index1].dateOfStudentSignature!)}",
                                    subTitle21: floorTherapyData[index1]
                                                .preceptorDetails!
                                                .preceptorName
                                                .isEmpty ||
                                            floorTherapyData[index1]
                                                .preceptorDetails!
                                                .preceptorName
                                                .isEmpty
                                        ? null
                                        : "Preceptor : ",
                                    title21: floorTherapyData[index1]
                                                .preceptorDetails!
                                                .preceptorName
                                                .isEmpty ||
                                            floorTherapyData[index1]
                                                .preceptorDetails!
                                                .preceptorName
                                                .isEmpty
                                        ? null
                                        : "${floorTherapyData[index1].preceptorDetails!.preceptorName} (${"${floorTherapyData[index1].preceptorDetails!.preceptorMobile}".replaceRange(0, 8, "XXX-XXX-")})",
                                    score: floorTherapyData[index1]
                                                .score
                                                .isEmpty ||
                                            floorTherapyData[index1].status ==
                                                "0"
                                        ? null
                                        : floorTherapyData[index1].score,
                                    buttonTitle: floorTherapyData[index1]
                                                .status ==
                                            "0"
                                        ? "Notify Again"
                                        : floorTherapyData[index1].status == "1"
                                            ? "Signoff Evaluation"
                                            : floorTherapyData[index1].status ==
                                                    "2"
                                                ? "View Evaluation"
                                        : null,
                                    btnSvgImage: floorTherapyData[index1]
                                                .status ==
                                            "0"
                                        ? "assets/images/notify.svg"
                                        : floorTherapyData[index1].status == "1"
                                            ? "assets/images/send-square.svg"
                                            : floorTherapyData[index1].status ==
                                                    "2"
                                                ? "assets/images/eye.svg"
                                        : null,
                                    navigateButton: () async {
                                      switch (floorTherapyData[index1].status) {
                                        case "0":
                                          phoneNmber.text =
                                              floorTherapyData[index1]
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
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(30.0),
                                                ),
                                              ),
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (BuildContext context) {
                                                return NotifyAgainBottomSheet(
                                                  accessToken: box
                                                      .get(
                                                          Hardcoded.hiveBoxKey)!
                                                      .accessToken,
                                                  userId: box
                                                      .get(
                                                          Hardcoded.hiveBoxKey)!
                                                      .loggedUserId,
                                                  listId:
                                                      floorTherapyData[index1]
                                                          .evaluationId,
                                                  type: "floorTherapy",
                                                  pullToRefresh: pullToRefresh,
                                                  phoneNumber:
                                                      floorTherapyData[index1]
                                                          .preceptorDetails!
                                                          .preceptorMobile,
                                                );
                                              },
                                            );
                                          }, () async {
                                            final DataService dataService =
                                                locator();
                                            CommonCopyUrlAndSendEmailRequest
                                                request =
                                                CommonCopyUrlAndSendEmailRequest(
                                              accessToken: box
                                                  .get(Hardcoded.hiveBoxKey)!
                                                  .accessToken,
                                              userId: box
                                                  .get(Hardcoded.hiveBoxKey)!
                                                  .loggedUserId,
                                              evaluationId:
                                                  floorTherapyData[index]
                                                      .evaluationId,
                                              rotationId:
                                                  widget.rotation.rotationId,
                                              preceptorId:
                                                  floorTherapyData[index]
                                                      .preceptorDetails!
                                                      .preceptorId,
                                              schoolTopicId: '',
                                              // loggedUserEmailId: widget.userLoginResponse.data.loggedUserEmail,
                                              isSendEmail: "false",
                                              evaluationType: "floorTherapy",
                                              preceptorNum:
                                                  floorTherapyData[index]
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
                                          }, () {
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
                                                      floorTherapyData[index]
                                                          .evaluationId,
                                                  rotationId: widget
                                                      .rotation.rotationId,
                                                  preceptorId:
                                                      floorTherapyData[index]
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
                                                  evaluationType:
                                                      "floorTherapy",
                                                  preceptorNum:
                                                      floorTherapyData[index]
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
                                          //       userId: widget.userLoginResponse.data
                                          //           .loggedUserId,
                                          //       accessToken: widget.userLoginResponse
                                          //           .data.accessToken,
                                          //       listId: floorTherapyData[index1]
                                          //           .evaluationId,
                                          //       type: "floorTherapy",
                                          //       pullToRefresh: pullToRefresh,
                                          //       phoneNumber: floorTherapyData[index1]
                                          //           .preceptorDetails!
                                          //           .preceptorMobile,
                                          //     );
                                          //   },
                                          // );
                                          break;
                                        case "1":
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  WebRedirectionWithLoadingScreen(
                                                url: webUrl,
                                                // url: "https://formsmarts.com/html-form-example",
                                                screenTitle: floorTherapyData[
                                                                index1]
                                                            .type ==
                                                        "Floor Therapy"
                                                    ? "Floor Therapy Signoff"
                                                    : "ICU/ABG Rotation Signoff",
                                                onSuccess: () async {
                                                  setState(() {
                                                    getfloorTherapyData();
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
                                                    getfloorTherapyData();
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
                                        case "2":
                                          Navigator.push(
                                            context,
                                            // MaterialPageRoute(builder: (context) => WebRedirectionScreen(url: 'https://rt.clinicaltrac.net/redirect/SkJZTnRvN3A=')),
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    // WebRedirectionScreen(url: webUrl, navigationRequestCallback: (NavigationRequest request) {if (request.url.contains('${cancel}')) {Navigator.pop(context);return NavigationDecision.prevent;}return NavigationDecision.navigate;},)
                                                    WebRedirectionWithLoadingScreen(
                                                      url: webUrl,
                                                      screenTitle: floorTherapyData[
                                                                      index1]
                                                                  .type ==
                                                              "Floor Therapy"
                                                          ? "Floor Therapy View"
                                                          : "ICU/ABG Rotation View",
                                                      onSuccess: () async {
                                                        setState(() {
                                                          getfloorTherapyData();
                                                          pullToRefresh();
                                                        });
                                                      },
                                                      onFail: () async {
                                                        setState(() {
                                                          getfloorTherapyData();
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
