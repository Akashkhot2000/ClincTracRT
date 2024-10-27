import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/model/user_daily_journal_list_model.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_details_response.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/save_journal_request_model.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/update_journal_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class EditDailyJournalScreen extends StatefulWidget {
  final JournalListData journalListData;
  final String journalId;
  final String journalDecCount;

  // final DailyJournalViewType Viewtype;
  // final UserLoginResponse user;
  // final RotationListStudentJournal rotationList;
  // final HospitalUnitListResponseDart hospitalUnitList;
  // final RotationForEvalListModel rotationForEvalListModel;

  const EditDailyJournalScreen({
    required this.journalListData,
    required this.journalId,
    required this.journalDecCount,
    // required this.Viewtype,
    // required this.rotationList,
    // required this.user,
    // required this.hospitalUnitList,
    // required this.rotationForEvalListModel,
  });

  @override
  State<EditDailyJournalScreen> createState() => _EditDailyJournalScreenState();
}

class _EditDailyJournalScreenState extends State<EditDailyJournalScreen> {
  List<String> rotations = [];
  String rotationId = '';
  DateTime journalDate = DateTime.now();
  String hospitalUnitId = '';

  String hospitalSiteId = '';

  // String studentJournalEntry = '';
  TextEditingController rotationTextController = TextEditingController();
  TextEditingController journalDateController = TextEditingController();
  TextEditingController hospitalSiteController = TextEditingController();
  TextEditingController hospitalSiteUnitController = TextEditingController();
  TextEditingController studentJournalEntry = TextEditingController();
  TextEditingController clinicianResponseText = TextEditingController();
  TextEditingController schoolResponseText = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool clinicianResponse = false;

  bool schoolResponse = false;

  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();
  bool isDataLoading = true;
  List<Datum> hospitalSiteUnitList = <Datum>[];
  Datum selectedhospitalSiteUnitValue = Datum();

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return '${formattedDate} ';
  }

  @override
  void initState() {
    // setValue();
    setState(() {
      rotationTextController.text = widget.journalListData.rotationName!;
      rotationId = widget.journalListData.rotationId!;
      journalDateController.text =
          dateConvert("${widget.journalListData.journalDate!}");
      hospitalSiteController.text = widget.journalListData.hospitalName!;
      hospitalSiteId = widget.journalListData.hospitalSiteId!;
      hospitalSiteUnitController.text =
          widget.journalListData.hospitalSiteunitName!;
      hospitalUnitId = widget.journalListData.hospitalSiteUnitId!;
      studentJournalEntry.text = widget.journalListData.studentResponseForEdit!;
      schoolResponseText.text = widget.journalListData.schoolResponseForEdit!;
    });
    super.initState();
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MM-dd-yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  final journalDateFocusNode = FocusNode();
  final hospitalSiteFocusNode = FocusNode();
  final hospitalSiteIdFocusNode = FocusNode();
  final studentJournalEntryFocusNode = FocusNode();
  final clinicianResponseFocusNode = FocusNode();
  final schoolResponseFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // hospitalSiteUnitList = widget.hospitalUnitList.data;
    return Scaffold(
      appBar: CommonAppBar(
        titles: Text("Edit Daily Journal",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                )),
        searchEnabeled: false,
      ),
      backgroundColor: Color(Hardcoded.white),
      bottomNavigationBar: BottomAppBar(
        height: globalHeight * 0.085,
        // color: Colors.amber,
        elevation: 0,
        child: CommonRoundedLoadingButton(
          controller: save,
          width: globalWidth * 0.9,
          textcolor: Color(Hardcoded.white),
          onTap: () async {
            UserDatRepo userDatRepo = UserDatRepo();
            Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
            DateTime journalDate1 = DateFormat("MM-dd-yyyy")
                .parse(widget.journalListData.journalDate!);
            String journalDate3 = DateFormat("yyyy-MM-dd").format(journalDate1);
            if (validateDailyjournal()) {
              UpdateJournalRequest updateJournalRequest = UpdateJournalRequest(
                journalId: widget.journalId.toString(),
                userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                userType: AppConsts.userType,
                rotationId: rotationId.isEmpty
                    ? widget.journalListData.rotationId!.toString()
                    : rotationId,
                journalDate: journalDate3.toString(),
                hospitalSiteId: hospitalSiteId.toString(),
                hospitalSiteUnitId: hospitalUnitId.toString(),
                studentJournalEntry: studentJournalEntry.text,
                clinicianJournalEntry: clinicianResponseText.text,
                accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
              );
              return userDatRepo.updateUserDailyJournal(updateJournalRequest,
                  () {
                Future.delayed(const Duration(seconds: 1), () {}).then((value) {
                  Navigator.pop(context);
                  common_alert_pop(
                      context,
                      'Successfully Updated\nDaily Journal.',
                      'assets/images/success_Icon.svg', () {
                    Navigator.pop(context);
                  });
                  // Future.delayed(const Duration(seconds: 1), () {
                  //   Navigator.pop(context);
                  // });
                });
              }, () {
                save.error();
                Future.delayed(Duration(seconds: 2), () {
                  save.reset();
                });
              }, context);
              //   dataResponseModel =
              //       await dataService.updateStudentJournal(updateJournalRequest);
              //   if (dataResponseModel.success) {
              //     Future.delayed(const Duration(seconds: 1), () {}).then((value) {
              //       Navigator.pop(context);
              //       common_alert_pop(
              //           context,
              //           'Successfully updated\nDaily Journal.',
              //           'assets/images/success_Icon.svg', () {
              //         Navigator.pop(context);
              //       });
              //       Future.delayed(const Duration(seconds: 1), () {
              //         Navigator.pop(context);
              //       });
              //     });
              //   }
              // } else {
              //   save.error();
              //   Future.delayed(Duration(seconds: 2), () {
              //     save.reset();
              //   });
              // }
            } else {
              save.error();
              Future.delayed(Duration(seconds: 2), () {
                save.reset();
              });
            }
            ;
          },
          title: 'Save',
          color: Color(Hardcoded.primaryGreen),
        ),
      ),
      body: NoInternet(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                Column(
                  children: [
                    Material(
                      color: Colors.white,
                      child: CommonTextfield(
                        inputText: "Rotation",
                        autoFocus: false,
                        // hintText: rotationTextController.text.isNotEmpty ? rotationTextController.text : "",
                        textEditingController: rotationTextController,
                        // maxLines: 7,
                        enabled: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    ///interaction date
                    GestureDetector(
                      child: Material(
                        color: Colors.white,
                        child: IOSKeyboardAction(
                          label: 'DONE',
                          focusNode: journalDateFocusNode,
                          focusActionType: FocusActionType.done,
                          onTap: () {},
                          child: CommonTextfield(
                            inputText: "Journal Date",
                            iscalenderField: true,
                            autoFocus: false,
                            // focusNode: interactionDateFocusNode,
                            // hintText: "${dateConvert("${journalDateController.text}")}",
                            textEditingController: journalDateController,
                            enabled: false,
                            readOnly: true,
                            onTap: () {},
                            sufix: GestureDetector(
                              onTap: () {
                                // interactionDatePickerOnTap();
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(Hardcoded.primaryGreen),
                                child: SvgPicture.asset(
                                  'assets/images/calendar.svg',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.white,
                      child: CommonTextfield(
                        inputText: "Hospital Site",
                        autoFocus: false,
                        // hintText: hospitalSiteController.text.isNotEmpty ? hospitalSiteController.text : "",
                        textEditingController: hospitalSiteController,
                        // maxLines: 7,
                        enabled: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.white,
                      child: CommonTextfield(
                        inputText: "Hospital Site Unit",
                        autoFocus: false,
                        // hintText: hospitalSiteUnitController.text.isNotEmpty ? hospitalSiteUnitController.text : "",
                        textEditingController: hospitalSiteUnitController,
                        // maxLines: 7,
                        enabled: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.white,
                      child: CommonTextfield(
                        inputText: "Student Journal Entry",
                        autoFocus: false,
                        keyboardType: TextInputType.multiline,
                        // hintText: studentJournalEntry.text.isNotEmpty ? studentJournalEntry.text : "",
                        textEditingController: studentJournalEntry,
                        maxLines: 7,
                        // maxlength: 5,
                        // minLines: 5,
                        readOnly: true,
                        // enabled: false,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      color: Colors.white,
                      child: IOSKeyboardAction(
                        label: 'DONE',
                        focusNode: clinicianResponseFocusNode,
                        focusActionType: FocusActionType.done,
                        onTap: () {},
                        child: CommonTextfield(
                          inputText: "Clinician Response",
                          autoFocus: false,
                          focusNode: clinicianResponseFocusNode,
                          hintText: "Enter Clinician Response",
                          textEditingController: clinicianResponseText,
                          maxLines: 7,
                          enabled: true,
                          // readOnly: false,
                          buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) {
                            return Visibility(
                              visible: clinicianResponseText.text.length <=
                                  int.parse("${widget.journalDecCount}"),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${clinicianResponseText.text.length} characters (Minimum ${widget.journalDecCount} characters)",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10,
                                        color: Color(Hardcoded.greyText),
                                      ),
                                ),
                              ),
                              replacement: SizedBox(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    schoolResponseText.text.isNotEmpty
                        ? Material(
                            color: Colors.white,
                            child: CommonTextfield(
                              inputText: "School Response",
                              autoFocus: false,
                              keyboardType: TextInputType.multiline,
                              textEditingController: schoolResponseText,
                              maxLines: 7,
                              // maxlength: 5,
                              // minLines: 5,
                              readOnly: true,
                              // enabled: false,
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: schoolResponseText.text.isNotEmpty ? 20 : 0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateDailyjournal() {
    if (rotationTextController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select rotation");
      return false;
    }
    if (journalDateController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select journal date");
      return false;
    }
    if (hospitalSiteUnitController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select hospital site unit");
      return false;
    }
    if (clinicianResponseText.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter clinician response");
      return false;
    }
    int decCount = int.parse("${widget.journalDecCount.toString()}");
    if (clinicianResponseText.text.length < decCount) {
      AppHelper.buildErrorSnackbar(context,
          "Student journal entry must contain ${widget.journalDecCount} characters");
      return false;
    }
    return true;
  }
}

class responseText extends StatelessWidget {
  const responseText(
      {super.key,
      required this.Response,
      required this.ResponseText,
      required this.Title});

  final bool Response;
  final TextEditingController ResponseText;
  final String Title;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Response,
      replacement: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(Hardcoded.textFieldBg),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Color(Hardcoded.greyText),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Waiting for $Title",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(Hardcoded.hintColor)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Title,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(Hardcoded.hintColor)),
          ),
          CommonTextfield(
            autoFocus: false,
            hintText: "",
            enabled: false,
            textEditingController: ResponseText,
            maxLines: 8,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
