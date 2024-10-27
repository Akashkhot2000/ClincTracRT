import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_label_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/formative/models/formative_details_model.dart';
import 'package:clinicaltrac/view/formative/view/detailedViewFormative.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignOffEvualtionScreen extends StatefulWidget {
  final String evaId;
  final String type;
  final UserLoginResponse userLoginResponse;
  SignOffEvualtionScreen({required this.evaId, required this.type, required this.userLoginResponse});

  @override
  State<SignOffEvualtionScreen> createState() => _SignOffEvualtionScreenState();
}

class _SignOffEvualtionScreenState extends State<SignOffEvualtionScreen> {
  FormativeEvaluationdetails formativeEvaluationdetails = FormativeEvaluationdetails();
  bool Loading = true;
  String precp = '-';
  String dateOfprecp = '-';
  String studSign = '-';
  String studDate = '-';
  String comments = '-';
  String evDate = '-';
  String rotationname = '-';
  String site = '-';
  bool cli = false;
  DateTime signOffDate = DateTime.now();
  TextEditingController signOffDateController = TextEditingController();
  TextEditingController commentsController = TextEditingController();
  RoundedLoadingButtonController signOff = RoundedLoadingButtonController();
  RoundedLoadingButtonController SignOff = RoundedLoadingButtonController();
  @override
  void initState() {
    fetchDetails();
    super.initState();
  }

  void fetchDetails() async {
    setState(() {
      Loading = true;
    });
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel = await dataService.getFormativeEvaluationdetails(
         box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          box.get(Hardcoded.hiveBoxKey)!.accessToken, widget.evaId);
    if (dataResponseModel.success) {
      // log(dataResponseModel.data.toString());
      formativeEvaluationdetails = FormativeEvaluationdetails.fromJson(dataResponseModel.data);
      setState(() {
        if (formativeEvaluationdetails.data!.preceptorDetails.preceptorName.isNotEmpty) {
          precp = formativeEvaluationdetails.data!.preceptorDetails.preceptorName;
        } else {
          precp = formativeEvaluationdetails.data!.clinicianName;
          cli = true;
        }
        if (formativeEvaluationdetails.data!.dateOfInstructorSignature.isNotEmpty)
          dateOfprecp = DateFormat('MMM dd, yyyy').format(DateTime.parse(formativeEvaluationdetails.data!.dateOfInstructorSignature));
        studSign = formativeEvaluationdetails.data!.studentName;
        if (formativeEvaluationdetails.data!.dateOfStudentSignature.isNotEmpty)
          studDate = DateFormat('MMM dd, yyyy').format(DateTime.parse(formativeEvaluationdetails.data!.dateOfStudentSignature));
        comments = formativeEvaluationdetails.data!.studentComment;
        evDate = DateFormat('MMM dd, yyyy').format(formativeEvaluationdetails.data!.evaluationDate);
        rotationname = formativeEvaluationdetails.data!.rotationName;
        site = formativeEvaluationdetails.data!.clinicianName;
      });
    } else {
      //AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
    }
    setState(() {
      Loading = false;
    });
  }

  final commentFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
          title: widget.type == 'signOff' ? 'Signoff Formative Evaluation' : 'View Formative Evaluation',
          merge: true,
        ),
        body: Visibility(
          visible: !Loading,
          replacement: common_loader(),
          child: Container(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25, bottom: 20),
                  color: Color(0XFFF6F9F9),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/evaluation2.svg',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Evaluation Date : ${evDate}",
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    // color: Color(0XFF5F6377),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            RichText(
                              text: TextSpan(
                                text: 'Rotation : ',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Color(0XFF868998),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: rotationname,
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          // color: Color(0XFF5F6377),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // RichText(
                            //   text: TextSpan(
                            //     text: 'Hospital site : ',
                            //     style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            //           color: Color(0XFF868998),
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 14,
                            //         ),
                            //     children: <TextSpan>[
                            //       TextSpan(
                            //         text: site,
                            //         style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            //               // color: Color(0XFF5F6377),
                            //               fontWeight: FontWeight.w500,
                            //               fontSize: 14,
                            //             ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Color(0XffE8E8E8),
                  height: 0,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    children: [
                      common_text_module(title: !cli ? "Preceptor" : 'Clinician', content: precp.isEmpty ? '-' : precp),
                      common_text_module(
                          title: !cli ? "Date of Preceptor Sign" : "Date of Clinician Sign", content: dateOfprecp.isEmpty ? '-' : dateOfprecp),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    children: [
                      common_text_module(title: "Student Signature", content: studSign.isEmpty ? '-' : studSign),
                      common_text_module(title: "Student Signoff Date", content: studDate.isEmpty ? '-' : studDate),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    children: [
                      common_text_module(
                        title: "Student Comments",
                        content: comments.isEmpty ? '-' : comments,
                        maxlines: comments.isEmpty ? 1 : comments.length,
                      ),
                      //common_text_module(title: "Student Sign off date", content: studDate.isEmpty ? '-' : studDate),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Divider(
                  color: Color(0XffE8E8E8),
                  thickness: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 25, right: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.detailedFormativeScreen,
                          arguments: DetailedViewFormativeRoutingData(evulation: formativeEvaluationdetails, type: 'evaluation'));
                    },
                    child: Material(
                      elevation: 5,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Row(children: [
                          SvgPicture.asset(
                            'assets/images/formative2.svg',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Formative Evalutaion During\nClinical Rotations.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    // color: Color(0XFF5F6377),

                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/arrow_frwd.svg',
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.detailedFormativeScreen,
                          arguments: DetailedViewFormativeRoutingData(evulation: formativeEvaluationdetails, type: 'effectiveness'));
                    },
                    child: Material(
                      elevation: 5,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Row(children: [
                          SvgPicture.asset(
                            'assets/images/effective.svg',
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Student Effectiveness During\nClinical Rotations.",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    // color: Color(0XFF5F6377),

                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/images/arrow_frwd.svg',
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                if (widget.type == 'signOff')
                  CommonRoundedLoadingButton(
                      controller: signOff,
                      title: "Proceed to Signoff",
                      textcolor: Color(Hardcoded.white),
                      color: Color(Hardcoded.primaryGreen),
                      width: MediaQuery.of(context).size.width - 40,
                      onTap: () async {
                        String isSuccess = "";
                        await showModalBottomSheet<void>(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30.0),
                            ),
                          ),
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30),
                                      )
                                  ),
                                  height: globalHeight * 0.73,
                                  child:
                                  // SingleChildScrollView(child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     Expanded(flex:2,
                                  child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(width:  globalWidth * 0.01,),
                                          Center(child: SvgPicture.asset('assets/images/signOff_icon.svg')),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/close_modal.svg',
                                            ),
                                          ),
                                        ],
                                      ),),
                                      SizedBox(height:  globalHeight * 0.01,),
                                      Center(
                                        child: Text(
                                          "Signoff Evaluation",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      CommonTextfield(
                                        inputText: "Student Signature",
                                          autoFocus: false,
                                          // focusNode: fromDateFocusNode,
                                          hintText: "${formativeEvaluationdetails.data!.studentName}",
                                          textEditingController: TextEditingController(),
                                          readOnly: false,
                                          enabled: false,
                                          keyboardType: TextInputType.number,
                                          validation: (text) {
                                            if (text == null || text.isEmpty) {
                                              return '*Required';
                                            }
                                            return null;
                                          }),
                                      SizedBox(
                                        height: globalHeight * 0.01,
                                      ),
                                      CommonTextfield(
                                        inputText: "Signoff Date",
                                        autoFocus: false,
                                        // focusNode: fromDateFocusNode,
                                        hintText: 'MM-DD-YYYY',
                                        textEditingController: signOffDateController,
                                        readOnly: true,
                                        onTap: () async {
                                          var results = await showCalendarDatePicker2Dialog(
                                            context: context,
                                            value: [signOffDate],
                                            config: CalendarDatePicker2WithActionButtonsConfig(
                                                lastDate: DateTime.now(), selectedDayHighlightColor: Color(Hardcoded.primaryGreen)),
                                            dialogSize: const Size(325, 400),
                                            borderRadius: BorderRadius.circular(15),
                                          );

                                          setState(() {
                                            signOffDate = results!.first!;
                                            signOffDateController.text = DateFormat('MM-dd-yyyy').format(signOffDate);
                                          });
                                        },
                                        validation: (text) {},
                                        sufix: GestureDetector(
                                          onTap: () async {
                                            var results = await showCalendarDatePicker2Dialog(
                                              context: context,
                                              value: [signOffDate],
                                              config: CalendarDatePicker2WithActionButtonsConfig(
                                                  lastDate: DateTime.now(), selectedDayHighlightColor: Color(Hardcoded.primaryGreen)),
                                              dialogSize: const Size(325, 400),
                                              borderRadius: BorderRadius.circular(15),
                                            );

                                            setState(() {
                                              signOffDate = results!.first!;
                                              signOffDateController.text = DateFormat('MM-dd-yyyy').format(signOffDate);
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: CircleAvatar(
                                              backgroundColor: Color(Hardcoded.primaryGreen),
                                              child: SvgPicture.asset(
                                                'assets/images/calendar.svg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:  globalHeight * 0.01,
                                      ),
                                  IOSKeyboardAction(
                                    label: 'DONE',
                                    focusNode: commentFocusNode,
                                    focusActionType: FocusActionType.done,
                                    onTap: () {},
                                    child:CommonTextfield(
                                        inputText: "Comment",
                                          autoFocus: false,
                                          focusNode: commentFocusNode,
                                          hintText: "Enter comment",
                                          textEditingController: commentsController,
                                          maxLines: 4,
                                          validation: (text) {
                                            if (text == null || text.isEmpty) {
                                              return '*Required';
                                            }
                                            return null;
                                          }),),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CommonRoundedLoadingButton(
                                          controller: SignOff,
                                          title: "Signoff",
                                          textcolor: Color(Hardcoded.white),
                                          color: Color(Hardcoded.primaryGreen),
                                          width: MediaQuery.of(context).size.width - 40,
                                          onTap: () async {
                                            if (signOffDateController.text.isEmpty) {
                                              SignOff.error();
                                              Future.delayed(const Duration(seconds: 2), () {
                                                SignOff.reset();
                                                if (signOffDateController.text.isEmpty) {
                                                  Navigator.pop(context);
                                                  AppHelper.buildErrorSnackbar(context, "Please add signoff date");
                                                  return false;
                                                }
                                                //AppHelper.buildErrorSnackbar(context, "Please select Sign off date.");
                                              });
                                            } else {
                                              Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
                                              final DataService dataService = locator();

                                              final DataResponseModel dataResponseModel = await dataService.SignOffEvaluation(
                                                   box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                                                   box.get(Hardcoded.hiveBoxKey)!.accessToken,
                                                  formativeEvaluationdetails.data!.evaluationId,
                                                  signOffDate.toString(),
                                                  commentsController.text);
                                              if (dataResponseModel.success) {
                                                SignOff.success();
                                                Future.delayed(const Duration(seconds: 3), () {
                                                  isSuccess = signOffDateController.text;
                                                  Navigator.pop(context);
                                                });
                                              } else {
                                                SignOff.error();
                                                Future.delayed(const Duration(seconds: 3), () {
                                                  SignOff.reset();
                                                });
                                              }
                                            }
                                          }),
                                    ],
                                  )),
                            // ),
                            );
                          },
                        );
                        signOff.reset();
                        if (isSuccess != "") {
                          Navigator.pop(context, isSuccess);
                        }
                      }),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class common_text_module extends StatelessWidget {
  common_text_module({this.title, this.content, this.maxlines = 1});
  String? title;
  String? content;
  int? maxlines;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Color(0XFF868998),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            content!,
            maxLines: maxlines,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  // color: Color(0XFF5F6377),

                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}

class SignOffEvaluationRoutingData {
  /// Constructor for [AllTaskConnectorData] which is passed as argument for [BodySwitcherConnector]
  SignOffEvaluationRoutingData({this.evaId, this.type, this.userLoginResponse});

  /// to load a particular page at initial time
  final String? evaId;
  final String? type;
  final UserLoginResponse? userLoginResponse;

  /// Static method to obtain the [MaterialPageRoute] for [BodySwitcherConnector] using [BodySwitcherData]
  static MaterialPageRoute<dynamic> resolveRoute(
    SignOffEvaluationRoutingData data,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (BuildContext context) => SignOffEvualtionScreen(
        evaId: data.evaId!,
        type: data.type!,
        userLoginResponse: data.userLoginResponse!,
      ),
    );
  }
}
