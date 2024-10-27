import 'dart:convert';
import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_add_button.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_green_rotation.dart';
import 'package:clinicaltrac/common/common_label_widget.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_notify_again_widget.dart';
import 'package:clinicaltrac/common/common_notify_popup_widget.dart';
import 'package:clinicaltrac/common/common_send_email_widget.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_copy_url_response_model.dart';
import 'package:clinicaltrac/model/common_copy_url_send_email_req_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/formative/models/formative_response.dart';
import 'package:clinicaltrac/view/formative/view/signOffScreen.dart';
import 'package:clinicaltrac/view/formative/vm_connector/add_formative_vm_connector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/web_redirect_loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class FormativeScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;
  DailyJournalRoute route;

  FormativeScreen(
      {super.key, required this.userLoginResponse, required this.rotation,required this.route});

  @override
  State<FormativeScreen> createState() => _FormativeScreenState();
}

class _FormativeScreenState extends State<FormativeScreen> {
  bool isSearchClicked = false;
  int pageNo = 1;
  int lastpage = 1;
  bool isDataLoaded = false;
  bool dataNotfound = false;
  String? evaluationDate;
  TextEditingController searchQuery = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<FormativeData> formativeList = [];
  CopyUrlData copyUrlData = CopyUrlData();
  TextEditingController phoneNmber = MaskedTextController(mask: '000-000-0000');
  RoundedLoadingButtonController notify = RoundedLoadingButtonController();
  final _formKey = GlobalKey<FormState>();

  Future<void> getFormativeList() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      if(mounted) { setState(() {
        isDataLoaded = true;
      });}
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest formativeRequest = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RecordsPerPage: '10',
          SearchText: searchQuery.text,
          RotationId: widget.rotation.rotationId!);
      final DataResponseModel dataResponseModel =
          await dataService.getFormative(formativeRequest);
      FormativeResponse formativeResponse =
          FormativeResponse.fromJson(dataResponseModel.data);

      lastpage = (int.parse(formativeResponse.pager.totalRecords!) / 10).ceil();
      if (formativeResponse.pager.totalRecords == '0') {
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
          formativeList.addAll(formativeResponse.data);
        } else {
          formativeList = formativeResponse.data;
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
      getFormativeList();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    getFormativeList();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getFormativeList();
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
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    return SafeArea(
        child: Scaffold(
      appBar: CommonAppBar(
        title: "Formative Evaluation",
        // merge: true,
        // titles: isSearchClicked
        //     ? Padding(
        //         padding: EdgeInsets.only(
        //           top: 5,
        //         ),
        //         child: CommonSearchTextfield(
        //           hintText: 'Search',
        //           textEditingController: searchQuery,
        //           onChanged: (value) {
        //             pageNo = 1;
        //             getFormativeList();
        //           },
        //         ),
        //       )
        //     : Text("Formative Evaluation",
        //         textAlign: TextAlign.center,
        //         style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //               fontWeight: FontWeight.w600,
        //               fontSize: 22,
        //             )),
        // searchEnabeled: true,
        // image: !isSearchClicked ?  SvgPicture.asset(
        //   'assets/images/search.svg',
        // ) : SvgPicture.asset(
        //   'assets/images/closeicon.svg',
        // ),
        // onSearchTap: () {
        //   setState(() {
        //     isSearchClicked = !isSearchClicked;
        //     searchQuery.text = '';
        //     if (isSearchClicked == false) {}
        //     getFormativeList();
        //   });
        // },
      ),
      backgroundColor: Color(Hardcoded.white),
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
                visible: isDataLoaded && pageNo == 1,
                child: common_loader(),
                replacement: Visibility(
                  visible: !dataNotfound,
                  replacement: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: globalHeight * 0.1),
                          child: NoDataFoundWidget(
                            title: "Formative Evaluations not available",
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
                      child: Padding(
                        padding: const EdgeInsets.only(top:5.0,left:2,right: 2.0),
                        child: CupertinoScrollbar(
                          controller: _scrollController,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: formativeList.length,
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              Box<UserLoginResponseHive>? box =
                              Boxes.getUserInfo();
                              // log("***************** ${checkoffsListData[index].status}");
                              evaluationDate = formativeList[index]
                                  .evaluationDate !=
                                  ""
                                  ? dateConvert(formativeList[index]
                                  .evaluationDate)
                                  : '';

                              int userId = int.parse(
                                  "${box.get(Hardcoded.hiveBoxKey)!.loggedUserId}");
                              String userIdEncr = userId.toString();
                              String userIdEncoded =
                              base64Encode(utf8.encode(userIdEncr));

                              int rotationId = widget.route ==
                                  DailyJournalRoute.direct
                                  ? int.parse(
                                  "${formativeList[index].rotationId}")
                                  : int.parse("${widget.rotation!.rotationId}");
                              String rotationIdEncr = rotationId.toString();
                              String rotationIdEncoded =
                              base64Encode(utf8.encode(rotationIdEncr));

                              int evaluationId = int.parse(
                                  "${formativeList[index].id}");
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
                                  'formative' +
                                  '&RotationId=' +
                                  '${rotationIdEncoded}' +
                                  '&RedirectId=' +
                                  '${evaluationIdEncoded}' +
                                  '&IsMobile=1';
                              // log("uuuuuuuuuuuu ${webUrl}");
                              return CommonListContainerWidget(
                                mainTitle:
                                    "Evaluation date : ${dateConvert("${formativeList[index].evaluationDate}")}",
                                statusString: formativeList[index].status == "0"
                                    ? "Pending"
                                    : formativeList[index].status == "2"
                                        ? "Completed"
                                        : null,
                                subTitle1: "Student sign date : ",
                                title1:
                                    formativeList[index].dateOfStudentSignature ==
                                            null
                                        ? "-"
                                        : DateFormat("MMM dd, yyyy").format(
                                            formativeList[index]
                                                .dateOfStudentSignature!),
                                subTitle6: "Instructor/preceptor sign date : ",
                                title6: formativeList[index]
                                            .dateOfInstructorSignature ==
                                        null
                                    ? "-"
                                    : DateFormat("MMM dd, yyyy").format(
                                        formativeList[index]
                                            .dateOfInstructorSignature!),
                                subTitle19: formativeList[index]
                                                .preceptorDetails!
                                                .preceptorName ==
                                            '' ||
                                        formativeList[index]
                                                .preceptorDetails!
                                                .preceptorMobile ==
                                            ''
                                    ? ''
                                    : "Preceptor : ",
                                title19: formativeList[index]
                                                .preceptorDetails!
                                                .preceptorName ==
                                            '' ||
                                        formativeList[index]
                                                .preceptorDetails!
                                                .preceptorMobile ==
                                            ''
                                    ? ''
                                    : "${formativeList[index].preceptorDetails!.preceptorName} (${"${formativeList[index].preceptorDetails!.preceptorMobile}".replaceRange(0, 8, "XXX-XXX-")})",
                                buttonTitle: formativeList[index].status == "0"
                                    ? "Notify Again"
                                    // : null,
                                : formativeList[index].status == "1"
                                    ? "Signoff Evaluation"
                                    : "View Evaluation",
                                btnSvgImage: formativeList[index].status == "0"
                                    ? "assets/images/notify.svg"
                                    // : null,
                                : formativeList[index].status == "1"
                                    ? "assets/images/send-square.svg"
                                    : "assets/images/eye.svg",
                                navigateButton: () async {
                                  switch (formativeList[index].status) {
                                    case "0":
                                      phoneNmber.text = formativeList[index]
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
                                              listId: formativeList[index].id,
                                              type: "formative",
                                              pullToRefresh: pullToRefresh,
                                              phoneNumber: formativeList[index]
                                                  .preceptorDetails!
                                                  .preceptorMobile,
                                            );
                                          },
                                        );
                                      }, () async {
                                        final DataService dataService = locator();
                                        CommonCopyUrlAndSendEmailRequest request =
                                            CommonCopyUrlAndSendEmailRequest(
                                          userId: widget.userLoginResponse.data
                                              .loggedUserId,
                                          accessToken: widget
                                              .userLoginResponse.data.accessToken,
                                          evaluationId: formativeList[index].id,
                                          rotationId: widget.rotation.rotationId,
                                          preceptorId: formativeList[index]
                                              .preceptorDetails!
                                              .preceptorId,
                                          schoolTopicId: '',
                                          // loggedUserEmailId: widget.userLoginResponse.data.loggedUserEmail,
                                          isSendEmail: "false",
                                          evaluationType: "formative",
                                          preceptorNum: formativeList[index]
                                              .preceptorDetails!
                                              .preceptorMobile,
                                        );
                                        final DataResponseModel
                                            dataResponseModel = await dataService
                                                .copyAndEmailSendEval(request);
                                        CopyUrlResponseModel
                                            copyUrlResponseModel =
                                            CopyUrlResponseModel.fromJson(
                                                dataResponseModel.data);
                                        if (dataResponseModel.success) {
                                          // notify.success();
                                          Navigator.pop(context);
                                          copyUrlData = copyUrlResponseModel.data;
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
                                              evaluationId:
                                                  formativeList[index].id,
                                              rotationId:
                                                  widget.rotation.rotationId,
                                              preceptorId: formativeList[index]
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
                                              evaluationType: "formative",
                                              preceptorNum: formativeList[index]
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
                                            screenTitle: "Formative Signoff",
                                            onSuccess: () async {
                                              setState(() {
                                                getFormativeList();
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
                                                getFormativeList();
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
                                              screenTitle: "Formative View",
                                              onSuccess: () async {
                                                setState(() {
                                                  getFormativeList();
                                                  pullToRefresh();
                                                });
                                              },
                                              onFail: () async{
                                                setState(() {
                                                  getFormativeList();
                                                  pullToRefresh();
                                                });
                                              },
                                              onError: () async {
                                                setState(() {
                                                  // getdailyWeeklyList();
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
                                  }
                                },
                              );
                              // FormativeCard(
                              //   date: formativeList[index]
                              //       .evaluationDate
                              //       .day
                              //       .toString(),
                              //   month: Hardcoded.getMonthString(
                              //       formativeList[index]
                              //           .evaluationDate
                              //           .month),
                              //   StudentName: formativeList[index].firstName +
                              //       ' ' +
                              //       formativeList[index].lastName,
                              //   schoolDate: formativeList[index]
                              //               .dateOfInstructorSignature ==
                              //           null
                              //       ? '-'
                              //       : DateFormat("MMM dd, yyyy").format(
                              //           formativeList[index]
                              //               .dateOfInstructorSignature!),
                              //   studentDate: formativeList[index]
                              //               .dateOfStudentSignature ==
                              //           null
                              //       ? '-'
                              //       : DateFormat("MMM dd, yyyy").format(
                              //           formativeList[index]
                              //               .dateOfStudentSignature!),
                              //   Index: index,
                              //   isDraggable: false,
                              //   isDelete: false,
                              //   JournalId: '');
                            },
                          ),
                        ),
                      ),
                    ),
                    // ),
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
              final phoneNmber = await Navigator.pushNamed(
                  context, Routes.addformativeScreen,
                  arguments:
                      AddFormativeRoutingData(rotation: widget.rotation));
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
    ));
  }
}
