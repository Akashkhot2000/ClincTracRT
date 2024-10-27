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
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_copy_url_response_model.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/Midterm_evaluation/Vm_conector/add_midterm_vm_connector.dart';
import 'package:clinicaltrac/view/Midterm_evaluation/midterm_eval_container.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/midterm_evaluation/model/midterm_eval_list_model.dart';
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
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MidtermEvaluationListScreen extends StatefulWidget {
  MidtermEvaluationListScreen({
    Key? key,
    required this.userLoginResponse,
    required this.rotation,
    required this.route,
  }) : super(key: key);
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;
  DailyJournalRoute route;

  @override
  State<MidtermEvaluationListScreen> createState() =>
      _MidtermEvaluationListScreenState();
}

class _MidtermEvaluationListScreenState
    extends State<MidtermEvaluationListScreen> {
  bool isSearchClicked = false;
  int pageNo = 1;
  int lastpage = 1;
  bool isDataLoaded = false;
  bool dataNotfound = false;
  String? evaluationDate;
  TextEditingController searchQuery = TextEditingController();
  ScrollController scrollController = ScrollController();
  List<MidtermEval> midtermEvalList = [];
  CopyUrlData copyUrlData = CopyUrlData();
  TextEditingController phoneNumber =
      MaskedTextController(mask: '000-000-0000');
  RoundedLoadingButtonController notify = RoundedLoadingButtonController();

  @override
  void initState() {
    getMidtermEvalList();

    scrollController.addListener(pagination);
    super.initState();
  }

  void pagination() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      pageNo += 1;
      getMidtermEvalList();
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(pagination);
    super.dispose();
  }

  String getMonthString(int monthInInt) {
    switch (monthInInt) {
      case 1:
        return 'Jan';

      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return '';
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  bool panelClosed = true;

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getMidtermEvalList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  Future<void> getMidtermEvalList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      if(mounted) {setState(() {
        isDataLoaded = true;
      });}
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest midtermRequest = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '10',
          SearchText: searchQuery.text,
          RotationId: widget.rotation.rotationId);
      final DataResponseModel dataResponseModel =
          await dataService.getMidtermEvaluationList(midtermRequest);

      // log(dataResponseModel.data.toString() + "SiteEval Data");
      MidtermEvalList localmidtermEvalList =
          MidtermEvalList.fromJson(dataResponseModel.data);

      lastpage =
          (int.parse(localmidtermEvalList.pager.totalRecords.toString()) / 10)
              .ceil();
      if (localmidtermEvalList.pager.totalRecords == '0') {
        if(mounted) { setState(() {
          dataNotfound = true;
        });}
      } else {
        if(mounted) { setState(() {
          dataNotfound = false;
        });
      }}
      setState(() {
        if (pageNo != 1) {
          midtermEvalList.addAll(localmidtermEvalList.data);
        } else {
          midtermEvalList = localmidtermEvalList.data;
        }
        isDataLoaded = false;
      });
    }
  }

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return '${formattedDate} ';
    // ' ${formattedTime}';
  }

  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    return Scaffold(
      backgroundColor: Color(Hardcoded.white),
      appBar: CommonAppBar(
        // onSearchTap: () {
        //   setState(() {
        //     if (isSearchClicked) {
        //       log("1111111111");
        //     }
        //
        //     isSearchClicked = !isSearchClicked;
        //     searchQuery.text = '';
        //   });
        // },
        titles:
            // isSearchClicked ? Padding(padding: EdgeInsets.only(top: 5,),
            //        child: Material(
            //          color: Colors.white,
            //          child: IOSKeyboardAction(
            //            label: 'DONE',
            //            focusNode: searchFocusNode,
            //            focusActionType: FocusActionType.done,
            //            onTap: () {},
            //            child: CommonSearchTextfield(
            //              focusNode: searchFocusNode,
            //              hintText: 'Search',
            //              textEditingController: searchQuery,
            //              onChanged: (value) {},),),),) :
            Text("Midterm Evaluation",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    )),
        // searchEnabeled: true,
        // image: !isSearchClicked
        //     ? SvgPicture.asset(
        //         'assets/images/search.svg',
        //       )
        //     : SvgPicture.asset(
        //         'assets/images/closeicon.svg',
        //       ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Column(
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
          Expanded(
            child: Visibility(
              visible: isDataLoaded && pageNo == 1,
              child: common_loader(),
              replacement: Visibility(
                visible: !dataNotfound,
                replacement: Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                        padding: EdgeInsets.only(
                          bottom: globalHeight * 0.1,
                        ),
                        child: NoDataFoundWidget(
                          title: "Midterm Evaluations not available",
                          imagePath: "assets/no_data_found.png",
                        )),
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
                      padding: const EdgeInsets.only(top:5.0,left:2,right: 2.0),
                      child:CupertinoScrollbar(
                    controller: scrollController,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: midtermEvalList.length,
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            List<Color> initialColor = [
                              Color(Hardcoded.orange),
                              Color(Hardcoded.blue),
                              Color(Hardcoded.pink)
                            ];
                            List<Color> finalColorList = [];

                            for (var i = 0; i < midtermEvalList.length; i++) {
                              finalColorList.add(
                                initialColor[i % initialColor.length],
                              );
                            }
                            Box<UserLoginResponseHive>? box =
                            Boxes.getUserInfo();
                            // log("***************** ${checkoffsListData[index].status}");
                            evaluationDate = midtermEvalList[index]
                                .evaluationDate !=
                                ""
                                ? dateConvert(midtermEvalList[index].evaluationDate)
                                : '';

                            int userId = int.parse(
                                "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                            String userIdEncr = userId.toString();
                            String userIdEncoded =
                            base64Encode(utf8.encode(userIdEncr));

                            int rotationId = widget.route ==
                                DailyJournalRoute.direct
                                ? int.parse(
                                "${midtermEvalList[index].rotationId}")
                                : int.parse("${widget.rotation!.rotationId}");
                            String rotationIdEncr = rotationId.toString();
                            String rotationIdEncoded =
                            base64Encode(utf8.encode(rotationIdEncr));

                            int evaluationId = int.parse(
                                "${midtermEvalList[index].evaluationId}");
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
                                'midterm' +
                                '&RotationId=' +
                                '${rotationIdEncoded}' +
                                '&RedirectId=' +
                                '${evaluationIdEncoded}' +
                                '&IsMobile=1';
                            // log("uuuuuuuuuuuu ${webUrl}");
                            return CommonListContainerWidget(
                              mainTitle:
                                  "Evaluation date : ${dateConvert("${midtermEvalList[index].evaluationDate}")}",
                              statusString: midtermEvalList[index].status == "0"
                                  ? "Pending"
                                  : midtermEvalList[index].status == "1" ||
                                          midtermEvalList[index].status == "2"
                                      ? "Completed"
                                      : null,
                              subTitle1: "Student sign date : ",
                              title1:
                                  midtermEvalList[index].dateOfStudentSignature ==
                                          null
                                      ? "-"
                                      : DateFormat("MMM dd, yyyy").format(
                                          midtermEvalList[index]
                                              .dateOfStudentSignature!),
                              subTitle6: "Instructor/preceptor sign date : ",
                              title6: midtermEvalList[index]
                                          .dateOfInstructorSignature ==
                                      null
                                  ? "-"
                                  : DateFormat("MMM dd, yyyy").format(
                                      midtermEvalList[index]
                                          .dateOfInstructorSignature!),
                              subTitle19: midtermEvalList[index]
                                              .preceptorDetails!
                                              .preceptorName ==
                                          '' ||
                                      midtermEvalList[index]
                                              .preceptorDetails!
                                              .preceptorMobile ==
                                          ''
                                  ? ''
                                  : "Preceptor : ",
                              title19: midtermEvalList[index]
                                              .preceptorDetails!
                                              .preceptorName ==
                                          '' ||
                                      midtermEvalList[index]
                                              .preceptorDetails!
                                              .preceptorMobile ==
                                          ''
                                  ? ''
                                  : "${midtermEvalList[index].preceptorDetails!.preceptorName} (${"${midtermEvalList[index].preceptorDetails!.preceptorMobile}".replaceRange(0, 8, "XXX-XXX-")})",
                              buttonTitle: midtermEvalList[index].status == "0"
                                  ? "Notify Again"
                                  // : null,
                              : midtermEvalList[index].status == "1"
                              ? "Signoff Evaluation"
                              : "View Evaluation",
                              btnSvgImage: midtermEvalList[index].status == "0"
                                  ? "assets/images/notify.svg"
                                  // : null,
                              : midtermEvalList[index].status == "1"
                              ? "assets/images/send-square.svg"
                              : "assets/images/eye.svg",
                              navigateButton: () async {
                                switch (midtermEvalList[index].status) {
                                  case "0":
                                    phoneNumber.text = midtermEvalList[index]
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
                                            listId: midtermEvalList[index]
                                                .evaluationId,
                                            type: "midterm",
                                            pullToRefresh: pullToRefresh,
                                            phoneNumber: midtermEvalList[index]
                                                .preceptorDetails!
                                                .preceptorMobile,
                                          );
                                        },
                                      );
                                    }, () async {
                                      final DataService dataService = locator();
                                      CommonCopyUrlAndSendEmailRequest request =
                                          CommonCopyUrlAndSendEmailRequest(
                                        accessToken: box
                                            .get(Hardcoded.hiveBoxKey)!
                                            .accessToken,
                                        userId: box
                                            .get(Hardcoded.hiveBoxKey)!
                                            .loggedUserId,
                                        evaluationId:
                                            midtermEvalList[index].evaluationId,
                                        rotationId: widget.rotation.rotationId,
                                        preceptorId: midtermEvalList[index]
                                            .preceptorDetails!
                                            .preceptorId,
                                        schoolTopicId: '',
                                        // loggedUserEmailId: widget.userLoginResponse.data.loggedUserEmail,
                                        isSendEmail: "false",
                                        evaluationType: "midterm",
                                        preceptorNum: midtermEvalList[index]
                                            .preceptorDetails!
                                            .preceptorMobile,
                                      );
                                      final DataResponseModel dataResponseModel =
                                          await dataService
                                              .copyAndEmailSendEval(request);
                                      CopyUrlResponseModel copyUrlResponseModel =
                                          CopyUrlResponseModel.fromJson(
                                              dataResponseModel.data);
                                      if (dataResponseModel.success) {
                                        // notify.success();
                                        Navigator.pop(context);
                                        copyUrlData = copyUrlResponseModel.data;
                                        Future.delayed(Duration(seconds: 1),
                                            () async {
                                          Clipboard.setData(ClipboardData(
                                                  text: "${copyUrlData.copyUrl}"))
                                              .whenComplete(() {});
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
                                            evaluationId: midtermEvalList[index]
                                                .evaluationId,
                                            rotationId:
                                                widget.rotation.rotationId,
                                            preceptorId: midtermEvalList[index]
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
                                            evaluationType: "midterm",
                                            preceptorNum: midtermEvalList[index]
                                                .preceptorDetails!
                                                .preceptorMobile,
                                          );
                                        },
                                      );
                                    });
                                    break;
                                  case "1":
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WebRedirectionWithLoadingScreen(
                                              url: webUrl,
                                              // url: "https://formsmarts.com/html-form-example",
                                              screenTitle: "Midterm Signoff",
                                              onSuccess: () async {
                                                setState(() {
                                                  getMidtermEvalList();
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
                                                  getMidtermEvalList();
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
                                                        '${"OOP's"}\nSomething went wrong', 'assets/images/error_Icon.svg',
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
                                            screenTitle: "Midterm View",
                                            onSuccess: () async {
                                              setState(() {
                                                getMidtermEvalList();
                                                pullToRefresh();
                                              });
                                            },
                                            onFail: () async{
                                              setState(() {
                                                getMidtermEvalList();
                                                pullToRefresh();
                                              });
                                            },
                                            onError: () async {
                                              setState(() {
                                                pullToRefresh().then((value) {
                                                  common_alert_pop(
                                                      context,
                                                      '${"OOP's"}\nSomething went wrong', 'assets/images/error_Icon.svg',
                                                          () {
                                                        Navigator.pop(context);
                                                      });
                                                });
                                              });
                                            },
                                          )),
                                    );
                                    break;
                                  default:
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
                                  //       listId: midtermEvalList[index]
                                  //           .evaluationId,
                                  //       type: "midterm",
                                  //       pullToRefresh: pullToRefresh,
                                  //       phoneNumber: midtermEvalList[index]
                                  //           .preceptorDetails!
                                  //           .preceptorMobile,
                                  //     );
                                  //   },
                                  // );

                                  //   getMidtermEvalList();
                                  //   break;
                                  // case "1":
                                  //   final message = await Navigator.pushNamed(context, Routes.SignOffEvualtionScreen,
                                  //       arguments: SignOffEvaluationRoutingData(
                                  //           evaId: midtermEvalList[index].id, type: 'signOff', userLoginResponse: widget.userLoginResponse));
                                  //
                                  //   if (message != null && message.toString() != '' && message.toString().isNotEmpty)
                                  //     common_alert_pop(context, 'Evaluation Successfully\nSigned off', 'assets/images/success_Icon.svg');
                                  //   getMidtermEvalList();
                                  //   break;
                                  // case "2":
                                  //   Navigator.pushNamed(context, Routes.SignOffEvualtionScreen,
                                  //       arguments: SignOffEvaluationRoutingData(
                                  //           evaId: midtermEvalList[index].id, type: 'view', userLoginResponse: widget.userLoginResponse));
                                  //   break;
                                  // default:
                                }
                              },
                            );
                            // return MidtermEvalContainer(
                            //   color: finalColorList.elementAt(index),
                            //   midtermEval: midtermEvalList.elementAt(index),
                            // );
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
      floatingActionButton: !widget.rotation.isHospitalSiteActive
          ? null
          : commonAddButton(onTap: () async {
              final phoneNmber = await Navigator.pushNamed(
                  context, Routes.addMidtermScreen,
                  arguments: AddMidtermRoutingData(rotation: widget.rotation));
              if (phoneNmber.toString() != '' &&
                  phoneNmber.toString().isNotEmpty &&
                  phoneNmber != null)
                common_alert_pop(
                    context,
                    'Successfully created\nEvaluation and SMS has been sent.',
                    'assets/images/success_Icon.svg', () {
                  Navigator.pop(context);
                });
              pullToRefresh();
            }),

      //  RefreshIndicator(
      //   onRefresh: () {
      //     return pullToRefresh();
      //   },
      //   color: Color(0xFFBBBBC6),
      //   child: ListView(
      //     children: [
      //       common_green_rotation_card(
      //         date: '${widget.rotation.startDate.day}',
      //         month:
      //             "${Hardcoded.getMonthString(widget.rotation.startDate.month)}",
      //         text1: "${widget.rotation.rotationTitle}",
      //         text2: "${widget.rotation.hospitalTitle}",
      //         text3: "${widget.rotation.courseTitle}",
      //         Index: 0,
      //       ),
      //       const SizedBox(
      //         height: 12,
      //       ),
      //       Container(
      //         decoration: const BoxDecoration(
      //           boxShadow: <BoxShadow>[
      //             BoxShadow(
      //               color: Color.fromARGB(
      //                 24,
      //                 203,
      //                 204,
      //                 208,
      //               ),
      //               blurRadius: 35.0, // soften the shadow
      //               spreadRadius: 10.0, //extend the shadow
      //               offset: Offset(
      //                 15.0,
      //                 15.0,
      //               ),
      //             )
      //           ],
      //         ),
      //         child: midtermEvalList.isEmpty && isSearchClicked
      //             ? ListView(
      //                 shrinkWrap: true,
      //                 children: [
      //                   Padding(
      //                     padding: EdgeInsets.only(top: globalHeight * 0.2),
      //                     child: NoDataFoundWidget(
      //                       title: "No data found",
      //                       imagePath: "assets/no_data_found.png",
      //                     ),
      //                   ),
      //                 ],
      //               )
      //             : midtermEvalList.isEmpty
      //                 ? ListView(
      //                     shrinkWrap: true,
      //                     children: [
      //                       Padding(
      //                         padding: EdgeInsets.only(top: globalHeight * 0.2),
      //                         child: NoDataFoundWidget(
      //                           title: "Midterm Evaluations not available",
      //                           imagePath: "assets/no_data_found.png",
      //                         ),
      //                       ),
      //                     ],
      //                   )
      //                 : ListView.builder(
      //                     controller: scrollController,
      //                     itemCount: midtermEvalList.length,
      //                     shrinkWrap: true,
      //                     itemBuilder: (BuildContext context, int index) {
      //                       List<Color> initialColor = [
      //                         Color(Hardcoded.orange),
      //                         Color(Hardcoded.blue),
      //                         Color(Hardcoded.pink)
      //                       ];
      //                       List<Color> finalColorList = [];

      //                       for (var i = 0; i < midtermEvalList.length; i++) {
      //                         finalColorList.add(
      //                           initialColor[i % initialColor.length],
      //                         );
      //                       }
      //                       return MidtermEvalContainer(
      //                         color: finalColorList.elementAt(index),
      //                         midtermEval: midtermEvalList.elementAt(index),
      //                       );
      //                     },
      //                   ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
