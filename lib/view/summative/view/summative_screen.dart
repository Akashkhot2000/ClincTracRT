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
import 'package:clinicaltrac/model/common_copy_url_response_model.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/summative/models/summative_response.dart';
import 'package:clinicaltrac/view/summative/vm_connector/add_summative_vm_connector.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class SummativeScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;
  final DailyJournalRoute route;

  SummativeScreen(
      {super.key, required this.userLoginResponse, required this.rotation,required this.route});

  @override
  State<SummativeScreen> createState() => _SummativeScreenState();
}

class _SummativeScreenState extends State<SummativeScreen> {
  bool isSearchClicked = false;
  int pageNo = 1;
  int lastpage = 1;
  bool isDataLoaded = false;
  bool dataNotfound = false;
  String? evaluationDate;
  String newNumber = '';
  TextEditingController searchQuery = TextEditingController();
  ScrollController _scrollController = ScrollController();
  TextEditingController phoneNmber = MaskedTextController(mask: '000-000-0000');
  List<SummativeData> summativeList = [];
  CopyUrlData copyUrlData = CopyUrlData();

  Future<void> getSummativeList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      if(mounted) { setState(() {
        isDataLoaded = true;
      });}
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest Request = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '10',
          SearchText: searchQuery.text,
          RotationId: widget.rotation.rotationId);
      final DataResponseModel dataResponseModel =
          await dataService.getSummative(Request);
      SummativeResponse summativeResponse =
          SummativeResponse.fromJson(dataResponseModel.data);
      // log("Total -------- ${summativeResponse.pager.totalRecords}");
      lastpage = (int.parse(summativeResponse.pager.totalRecords!) / 10).ceil();
      if (summativeResponse.pager.totalRecords == '0') {
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
          summativeList.addAll(summativeResponse.data);
        } else {
          summativeList = summativeResponse.data;
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
      getSummativeList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    getSummativeList();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getSummativeList();
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

  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(
          // title: "Summative Evaluation",
          titles:
              // isSearchClicked ? Padding(padding: EdgeInsets.only(top: 5,),
              //         child: CommonSearchTextfield(
              //           hintText: 'Search',
              //           textEditingController: searchQuery,
              //           onChanged: (value) {pageNo = 1;getSummativeList();},),):
              Text("Summative Evaluation",
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
          // onSearchTap: () {
          //   setState(() {
          //     isSearchClicked = !isSearchClicked;
          //     searchQuery.text = '';
          //     if (isSearchClicked == false) {}
          //     getSummativeList();
          //   });
          // },
        ),
        backgroundColor: Color(Hardcoded.white),
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
                            padding:
                                EdgeInsets.only(bottom: globalHeight * 0.1),
                            child: NoDataFoundWidget(
                              title: "Summative Evaluations not available",
                              imagePath: "assets/no_data_found.png",
                            )),
                      ),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () => pullToRefresh(),
                      color: Color(0xFFBBBBC6),
                      // child: SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(),
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
                        child:Padding(
                          padding: const EdgeInsets.only(top:5.0,left:2,right: 2.0),
                          child: CupertinoScrollbar(
                            controller: _scrollController,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: summativeList.length,
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                Box<UserLoginResponseHive>? box =
                                Boxes.getUserInfo();
                                // log("***************** ${checkoffsListData[index].status}");
                                evaluationDate = summativeList[index]
                                    .evaluationDate !=
                                    ""
                                    ? dateConvert(summativeList[index].evaluationDate)
                                    : '';

                                int userId = int.parse(
                                    "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                                String userIdEncr = userId.toString();
                                String userIdEncoded =
                                base64Encode(utf8.encode(userIdEncr));

                                int rotationId = widget.route ==
                                    DailyJournalRoute.direct
                                    ? int.parse(
                                    "${summativeList[index].rotationId}")
                                    : int.parse("${widget.rotation!.rotationId}");
                                String rotationIdEncr = rotationId.toString();
                                String rotationIdEncoded =
                                base64Encode(utf8.encode(rotationIdEncr));

                                int evaluationId = int.parse(
                                    "${summativeList[index].evaluationId}");
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
                                    'summative' +
                                    '&RotationId=' +
                                    '${rotationIdEncoded}' +
                                    '&RedirectId=' +
                                    '${evaluationIdEncoded}' +
                                    '&IsMobile=1';
                                // log("uuuuuuuuuuuu ${webUrl}");
                                return CommonListContainerWidget(
                                  mainTitle:
                                      "Evaluation date : ${dateConvert("${summativeList[index].evaluationDate!}")}",
                                  statusString: summativeList[index].status == "0"
                                      ? "Pending"
                                      : summativeList[index].status == "1" ||
                                              summativeList[index].status == "2"
                                          ? "Completed"
                                          : null,
                                  subTitle1: "Student sign date : ",
                                  title1: summativeList[index]
                                              .dateOfStudentSignature ==
                                          null
                                      ? "-"
                                      : DateFormat("MMM dd, yyyy").format(
                                          summativeList[index]
                                              .dateOfStudentSignature!),
                                  // subTitle6: "Instructor/preceptor sign date : ",
                                  // title6: summativeList[index]
                                  //             .dateOfStudentSignature ==
                                  //         null
                                  //     ? "-"
                                  //     : DateFormat("MMM dd, yyyy").format(
                                  //         summativeList[index]
                                  //             .dateOfStudentSignature!),
                                  subTitle19: "Preceptor : ",
                                  title19: summativeList[index]
                                                  .preceptorDetails!
                                                  .preceptorName ==
                                              '' ||
                                          summativeList[index]
                                                  .preceptorDetails!
                                                  .preceptorMobile ==
                                              ''
                                      ? ''
                                      : "${summativeList[index].preceptorDetails!.preceptorName} (${"${summativeList[index].preceptorDetails!.preceptorMobile}".replaceRange(0, 8, "XXX-XXX-")})",
                                  divider: summativeList[index]
                                                  .dateOfStudentSignature !=
                                              "0" &&
                                          summativeList[index].status != "0"
                                      ? Divider(
                                          thickness: 1,
                                        )
                                      : null,
                                  subTitle7: summativeList[index].status == "0"
                                      ? null
                                      : summativeList[index].EvalTotal == ''
                                          ? ''
                                          : "Eval total/avg : ",
                                  title7: summativeList[index].status == "0"
                                      ? null
                                      : summativeList[index].EvalTotal == ''
                                          ? ""
                                          : summativeList[index].EvalTotal,
                                  subTitle12:
                                      summativeList[index].OverallRating == ''
                                          ? ''
                                          : "Overall rating : ",
                                  title12:
                                      summativeList[index].OverallRating == ''
                                          ? ""
                                          : summativeList[index].OverallRating,
                                  buttonTitle: summativeList[index].status == "0"
                                      ? "Notify Again"
                                      // : null,
                                  : summativeList[index].status == "1"
                                      ? "Signoff Evaluation"
                                      : "View Evaluation",
                                  btnSvgImage: summativeList[index].status == "0"
                                      ? "assets/images/notify.svg"
                                      // : null,
                                  : summativeList[index].status == "1"
                                      ? "assets/images/send-square.svg"
                                      : "assets/images/eye.svg",
                                  navigateButton: () async {
                                    switch (summativeList[index].status) {
                                      case "0":
                                        phoneNmber.text = summativeList[index]
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
                                                userId: widget.userLoginResponse
                                                    .data.loggedUserId,
                                                accessToken: widget
                                                    .userLoginResponse
                                                    .data
                                                    .accessToken,
                                                listId: summativeList[index]
                                                    .evaluationId,
                                                type: "summative",
                                                pullToRefresh: pullToRefresh,
                                                phoneNumber: summativeList[index]
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
                                                summativeList[index].evaluationId,
                                            rotationId:
                                                widget.rotation.rotationId,
                                            preceptorId: summativeList[index]
                                                .preceptorDetails!
                                                .preceptorId,
                                            schoolTopicId: '',
                                            // loggedUserEmailId: widget.userLoginResponse.data.loggedUserEmail,
                                            isSendEmail: "false",
                                            evaluationType: "summative",
                                            preceptorNum: summativeList[index]
                                                .preceptorDetails!
                                                .preceptorMobile,
                                          );
                                          final DataResponseModel
                                              dataResponseModel =
                                              await dataService
                                                  .copyAndEmailSendEval(request);
                                          CopyUrlResponseModel
                                              copyUrlResponseModel =
                                              CopyUrlResponseModel.fromJson(
                                                  dataResponseModel.data);
                                          if (dataResponseModel.success) {
                                            // notify.success();
                                            Navigator.pop(context);
                                            copyUrlData =
                                                copyUrlResponseModel.data;
                                            Future.delayed(Duration(seconds: 1),
                                                () async {
                                              Clipboard.setData(ClipboardData(
                                                      text:
                                                          "${copyUrlData.copyUrl}"))
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
                                                evaluationId: summativeList[index]
                                                    .evaluationId,
                                                rotationId:
                                                    widget.rotation.rotationId,
                                                preceptorId: summativeList[index]
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
                                                evaluationType: "summative",
                                                preceptorNum: summativeList[index]
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
                                                  screenTitle: "Summative Signoff",
                                                  onSuccess: () async {
                                                    setState(() {
                                                      getSummativeList();
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
                                                      getSummativeList();
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
                                                screenTitle: "Summative View",
                                                onSuccess: () async {
                                                  setState(() {
                                                    getSummativeList();
                                                    pullToRefresh();
                                                  });
                                                },
                                                onFail: () async{
                                                  setState(() {
                                                    getSummativeList();
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
                                      //       userId: widget.userLoginResponse
                                      //           .data.loggedUserId,
                                      //       accessToken: widget
                                      //           .userLoginResponse
                                      //           .data
                                      //           .accessToken,
                                      //       listId: summativeList[index]
                                      //           .evaluationId,
                                      //       type: "summative",
                                      //       pullToRefresh: pullToRefresh,
                                      //       phoneNumber: summativeList[index]
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
                              },
                            ),
                          ),
                        ),
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: !widget.rotation.isHospitalSiteActive
            ? null
            : commonAddButton(onTap: () async {
                final phoneNumber = await Navigator.pushNamed(
                    context, Routes.addSummativeScreen,
                    arguments:
                        AddSummativeRoutingData(rotation: widget.rotation));
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
                 // getSummativeList();
              }),
      ),
    );
  }
}
