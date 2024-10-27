import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_label_widget.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/eaxpansion_component.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/checkoffs_action/get_rotation_for_eval_action.dart';
import 'package:clinicaltrac/view/check_offs/model/rotation_for_evaluation_model.dart';
import 'package:clinicaltrac/view/formative/models/add_Formative_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddFormativeScreen extends StatefulWidget {
  final UserLoginResponse userLoginResponse;
  final Rotation rotation;
  final RotationListStudentJournal rotationListStudentJournal;
  final RotationForEvalListModel rotationForEvalListModel;

  AddFormativeScreen(
      {required this.rotation,
      required this.userLoginResponse,
      required this.rotationListStudentJournal,
      required this.rotationForEvalListModel});

  @override
  State<AddFormativeScreen> createState() => _AddFormativeScreenState();
}

class _AddFormativeScreenState extends State<AddFormativeScreen> {
  List<String> items = [];
  String selectedRotation = '';
  String selectedRotationId = '';
  List<String> rotationList = [];
  TextEditingController checkoffDate = TextEditingController();
  TextEditingController phoneNmber = MaskedTextController(mask: '000-000-0000');
  TextEditingController EvaulationDateText = TextEditingController();
  RoundedLoadingButtonController create = RoundedLoadingButtonController();
  DateTime EvaluationDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  List<RotationForEvalListData> rotationEvalList = <RotationForEvalListData>[];
  RotationForEvalListData selectedRotationValue = new RotationForEvalListData();

  @override
  void initState() {
    // setValue();
    setState(() {
      store.dispatch(GetRotationForEvalListAction(isAdvanceCheckoff: "false"));
      selectedRotation =
          "${widget.rotation.rotationTitle} (${widget.rotation.hospitalTitle})";
      rotationEvalList = widget.rotationForEvalListModel.data!;
    });
    super.initState();
  }

  final phoneNumberFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    rotationEvalList = widget.rotationForEvalListModel.data!;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, "");
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            title: 'Create Formative Evaluation',
            // merge: true,
          ),
          body: NoInternet(
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: globalHeight * 0.13,
                          ),
                          CommonTextfield(
                            inputText: "Evaluation Date",
                            autoFocus: false,
                            // focusNode: fromDateFocusNode,
                            hintText: 'Select evaluation date',
                            textEditingController: EvaulationDateText,
                            readOnly: true,
                            onTap: () async {
                              var results = await showCalendarDatePicker2Dialog(
                                context: context,
                                value: [EvaluationDate],
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                        lastDate: DateTime.now(),
                                        selectedDayHighlightColor:
                                            Color(Hardcoded.primaryGreen)),
                                dialogSize: const Size(325, 400),
                                borderRadius: BorderRadius.circular(15),
                              );

                              setState(() {
                                EvaluationDate = results!.first!;
                                EvaulationDateText.text =
                                    DateFormat('MM-dd-yyyy')
                                        .format(EvaluationDate);
                              });
                            },
                            sufix: GestureDetector(
                              onTap: () async {
                                var results =
                                    await showCalendarDatePicker2Dialog(
                                  context: context,
                                  value: [EvaluationDate],
                                  config:
                                      CalendarDatePicker2WithActionButtonsConfig(
                                          lastDate: DateTime.now(),
                                          selectedDayHighlightColor:
                                              Color(Hardcoded.primaryGreen)),
                                  dialogSize: const Size(325, 400),
                                  borderRadius: BorderRadius.circular(15),
                                );

                                setState(() {
                                  EvaluationDate = results!.first!;
                                  EvaulationDateText.text =
                                      DateFormat('MM-dd-yyyy')
                                          .format(EvaluationDate);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color(Hardcoded.primaryGreen),
                                  child: SvgPicture.asset(
                                    'assets/images/calendar.svg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: globalHeight * 0.013,
                          ),
                          Material(
                            color: Colors.white,
                            child: IOSKeyboardAction(
                              label: 'DONE',
                              focusNode: phoneNumberFocusNode,
                              focusActionType: FocusActionType.done,
                              onTap: () {},
                              child: CommonTextfield(
                                inputText: "Preceptor Phone Number",
                                autoFocus: false,
                                focusNode: phoneNumberFocusNode,
                                hintText: '123-456-7812',
                                textEditingController: phoneNmber,
                                readOnly: false,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ),
                          Spacer(),
                          CommonRoundedLoadingButton(
                              controller: create,
                              title: "Create Evaluation",
                              textcolor: Color(Hardcoded.white),
                              color: Color(Hardcoded.primaryGreen),
                              width: MediaQuery.of(context).size.width - 40,
                              onTap: () async {
                                if (EvaulationDateText.text.isNotEmpty &&
                                    phoneNmber.text.isNotEmpty &&
                                    phoneNmber.text.length == 12) {
                                  Box<UserLoginResponseHive>? box =
                                      Boxes.getUserInfo();
                                  AddFormativeRequest request =
                                      AddFormativeRequest(
                                    EvaluationDate: EvaluationDate.toString(),
                                    accessToken: box
                                        .get(Hardcoded.hiveBoxKey)!
                                        .accessToken,
                                    MobileNumber: phoneNmber.text,
                                    RotationId: selectedRotationId.isEmpty
                                        ? widget.rotation.rotationId
                                        : selectedRotationId,
                                    SignatureName: widget.userLoginResponse.data
                                            .loggedUserFirstName +
                                        " " +
                                        widget.userLoginResponse.data
                                            .loggedUserLastName,
                                    userId: box
                                        .get(Hardcoded.hiveBoxKey)!
                                        .loggedUserId,
                                  );
                                  final DataService dataService = locator();

                                  final DataResponseModel dataResponseModel =
                                      await dataService.addFormative(request);
                                  // log(dataResponseModel.toString());
                                  if (dataResponseModel.success) {
                                    create.success();
                                    Future.delayed(
                                            const Duration(seconds: 1), () {})
                                        .then((value) {
                                      // AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        Navigator.pop(context, phoneNmber.text);
                                      });
                                    });
                                  } else {
                                    create.error();
                                    Future.delayed(
                                            const Duration(seconds: 1), () {})
                                        .then((value) =>
                                            AppHelper.buildErrorSnackbar(
                                                context,
                                                dataResponseModel.errorResponse
                                                    .errorMessage));
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      create.reset();
                                    });
                                  }
                                } else {
                                  create.error();
                                  Future.delayed(Duration(seconds: 2), () {
                                    create.reset();
                                  });
                                  if (EvaulationDateText.text.isEmpty) {
                                    AppHelper.buildErrorSnackbar(context,
                                        "Please enter evaluation date");
                                    return false;
                                  }
                                  if (phoneNmber.text.isEmpty) {
                                    AppHelper.buildErrorSnackbar(context,
                                        "Please enter preceptor phone number");
                                    return false;
                                  }
                                  if (phoneNmber.text.length < 12) {
                                    AppHelper.buildErrorSnackbar(context,
                                        "Please enter valid preceptor phone number");
                                    return false;
                                  }
                                }
                              }),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ExpansionWidget<RotationForEvalListData>(
                              inputText: "Rotation",
                              hintText: selectedRotation.toString().isNotEmpty
                                  ? selectedRotation.toString()
                                  : "Select rotation",
                              textColor: selectedRotation.toString().isNotEmpty
                                  ? Colors.black
                                  : Color(Hardcoded.greyText),
                              OnSelection: (value) {
                                setState(() {
                                  // setValue();
                                  RotationForEvalListData c =
                                      value as RotationForEvalListData;
                                  selectedRotationValue = c;
                                  selectedRotation =
                                      selectedRotationValue.title!;
                                  selectedRotationId =
                                      selectedRotationValue.rotationId!;
                                });
                                // log("id---------${selectedRotationValue.rotationId}");
                              },
                              items: List.of(
                                rotationEvalList.map((item) {
                                  String text = item.title.toString();
                                  List<String> title = text.split("(");
                                  String subText = title[1];
                                  List<String> subTitle = subText.split(")");
                                  return DropdownItem<RotationForEvalListData>(
                                    value: item,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 8.0,
                                          left: globalWidth * 0.06,
                                          right: globalWidth * 0.06,
                                          bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          Text(
                                            subTitle[0],
                                            // widget.hintText,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color:
                                                      Color(Hardcoded.greyText),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
