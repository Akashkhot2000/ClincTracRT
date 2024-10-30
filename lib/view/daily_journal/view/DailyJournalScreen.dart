import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/daily_journal/model/student_daily_journal_list_response.dart';
import 'package:clinicaltrac/view/daily_journal_details/vm_connector.dart/dailyJournal_detail_vm_connector.dart';
import 'package:clinicaltrac/view/daily_journal_details/vm_connector.dart/daily_journal_details_vm_connector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class DailyJournalScreen extends StatefulWidget {
  UserLoginResponse userLoginResponse;
  RotationListStudentJournal rotationListStudentJournal;
  Rotation? rotation;
  DailyJournalRoute route;

  DailyJournalScreen(
      {required this.userLoginResponse,
      required this.rotationListStudentJournal,
      this.rotation,
      required this.route});

  @override
  State<DailyJournalScreen> createState() => _DailyJournalScreenState();
}

class _DailyJournalScreenState extends State<DailyJournalScreen> {
  ///controllers

  TextEditingController searchQuery = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  List<RotationJournalData> rotationEvalList = <RotationJournalData>[];
  RotationJournalData selectedRotationValue = new RotationJournalData();
  bool isSearchClicked = false;
  List<String> items = [];
  String? selectedRotation;
  String? selectedRotationId;
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

  int pageNo = 1;
  int lastPage = 1;
  List<JournalListData> Journallist = [];
  String journalDecCount = '';
  bool isDataLoading = true;
  bool datanotFound = true;

  //final ScrollController _scrollController = ScrollController();

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

  Future<void> getJournalList() async {
    if (pageNo == 1 || pageNo <= lastPage) {
      setState(() {
        isDataLoading = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();

      CommonRequest dailyJournalListRequest = CommonRequest(
          accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
          userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          pageNo: pageNo.toString(),
          RotationId: selectedRotationId!,
          title: searchQuery.text,
          fromDate: fromDate.text.isEmpty
              ? ""
              : DateFormat('yyyy-MM-dd').format(from),
          todate:
              toDate.text.isEmpty ? "" : DateFormat('yyyy-MM-dd').format(to));

      final DataService dataService = locator();
      DataResponseModel dataResponseModel =
          await dataService.getDailyJournalList(dailyJournalListRequest);
      StudentRotationListResponse journalListResponse =
          StudentRotationListResponse.fromJson(dataResponseModel.data);
      lastPage =
          (int.parse(journalListResponse.pageInfo!.totalRecords!) / 5).ceil();
      // log(journalListResponse.pageInfo!.totalRecords!.toString());
      if (journalListResponse.pageInfo!.totalRecords == '0') {
        setState(() {
          datanotFound = true;
        });
      } else {
        setState(() {
          datanotFound = false;
        });
      }
      setState(() {
        journalDecCount = journalListResponse.data.journalDescriptionCount;
        if (pageNo == 1)
          Journallist = journalListResponse.data.journalListData;
        else {
          for (int i = 0;
              i < journalListResponse.data.journalListData.length;
              i++) {
            Journallist.add(journalListResponse.data.journalListData[i]);
          }
        }
        isDataLoading = false;
      });
    }
    // log("PageNo: = " + pageNo.toString());
    // log("dataloading: = " + isDataLoading.toString());
    // log("data not found: = " + datanotFound.toString());
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;

      getJournalList();
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
      selectedRotation = items[0];
    } else {
      if (widget.route == DailyJournalRoute.direct)
        setValue();
      else {
        selectedRotation = widget.rotation!.rotationTitle;
        selectedRotationId = widget.rotation!.rotationId;
      }
    }
    getJournalList();

    super.initState();
    _scrollController.addListener(_scrollListener);
    rotationEvalList = widget.rotationListStudentJournal.data!;
  }

  Future<void> pullToRefresh() async {
    pageNo = 1;
    getJournalList();
    searchQuery.text = '';
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();
  final fromDateFocusNode = FocusNode();
  final toDateFocusNode = FocusNode();

  DateTime convertDateToUTC(String dateUtc) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
    var formattedTime = dateTime.toLocal();
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    rotationEvalList = widget.rotationListStudentJournal.data!;
    return WillPopScope(
      onWillPop: () {
        widget.route == DailyJournalRoute.rotation
            ?  Navigator.pop(context):Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
            arguments: BodySwitcherData(
                initialPage: Bottom_navigation_control.home));
        return Future.value(true);
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
                            getJournalList();
                          },
                        ),
                      ),
                    ),
                  )
                : Text("Daily Journal",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        )),
            searchEnabeled: true,
            onTap: (){
              widget.route == DailyJournalRoute.rotation
                  ?  Navigator.pop(context):  Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
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
                if (isSearchClicked == false) getJournalList();
              });
            },
          ),
          backgroundColor: Color(Hardcoded.white),
          body: items.length != 1
              ? widget.route == DailyJournalRoute.direct
                  ? Stack(
                      children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: ExpansionWidget<RotationJournalData>(
                          hintText:
                              selectedRotationValue.title != "All" ? "All" : '',
                          // enabled: selectAllCourseTopic.toString().isEmpty
                          //     ? true
                          //     : false,
                          textColor: selectedRotation.toString().isNotEmpty
                              ? Colors.black
                              : Color(Hardcoded.greyText),
                          OnSelection: (value) {
                            setState(() {
                              RotationJournalData c =
                                  value as RotationJournalData;
                              selectedRotationValue = c;
                              // singleCourseTopicList.clear();
                              selectedRotation = selectedRotationValue.title;
                              selectedRotationId =
                                  selectedRotationValue.rotationId;
                              pageNo = 1;
                              searchQuery.text = '';
                              isSearchClicked = false;
                              getJournalList();
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
                                        subTitle[0] != "All" && title[0] != "All"
                                            ? Text(subTitle[0],
                                                // widget.hintText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14,
                                                        color: Color(
                                                            Hardcoded.greyText)))
                                            : Container(),
                                      ])),
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
                        //       getJournalList();
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
                      dateModule(context),
                    ].reversed.map((e) => e).toList())
                  : Column(children: [
                      common_green_rotation_card(
                        date: '${widget.rotation?.startDate.day}',
                        month:
                            "${Hardcoded.getMonthString(widget.rotation?.startDate.month)}",
                        text1: "${widget.rotation?.rotationTitle}",
                        text2: "${widget.rotation?.hospitalTitle}",
                        text3: "${widget.rotation?.courseTitle}",
                        Index: 0,
                      ),
                      dateModule(context),
                      Expanded(
                        child: listModule(),
                      ),
                    ])
              : Center(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: globalHeight * 0.1),
                      child: NoDataFoundWidget(
                        title: "Daily Journals not available",
                        imagePath: "assets/no_data_found.png",
                      )),
                ),
          // floatingActionButton: NoInternet(
          //   child: Visibility(
          //     visible: widget.route == DailyJournalRoute.rotation,
          //     child: FloatingActionButton(
          //         backgroundColor: Color(Hardcoded.orange),
          //         child: Icon(
          //           Icons.add,
          //           size: 35,
          //         ),
          //         onPressed: () async {
          //           await Navigator.pushNamed(
          //               context, Routes.dailyJournalDetailsScreen,
          //               arguments: DailyJournalData(
          //                   JournalId: widget.rotation?.rotationTitle,
          //                   viewType: DailyJournalViewType.add));
          //           getJournalList();
          //         }),
          //   ),
          // ),
          floatingActionButton: Visibility(
            visible: widget.route == DailyJournalRoute.rotation,
            child: commonAddButton(onTap: () async {
              await Navigator.pushNamed(context, Routes.dailyJournalDetailsScreen,
                  arguments: DailyJournalData(
                      JournalId: widget.rotation?.rotationTitle,
                      rotationId: widget.rotation!.rotationId,
                      hospitalTitle: widget.rotation!.hospitalTitle,
                      hospitalId: '',
                      viewType: DailyJournalViewType.add,
                      journalDecCount: journalDecCount));
              getJournalList();
              // common_alert_pop(context, 'Successfully created\ndaily journal', 'assets/images/success_Icon.svg',(){Navigator.pop(context);});
            }),
            replacement: commonAddButton(onTap: () async {
              await Navigator.pushNamed(context, Routes.dailyJournalDetailsScreen,
                  arguments: DailyJournalData(
                      JournalId: '',
                      rotationId: '',
                      hospitalTitle: '',
                      hospitalId: '',
                      viewType: DailyJournalViewType.addDash,
                      journalDecCount: journalDecCount));
              getJournalList();
              // common_alert_pop(context, 'Successfully created\ndaily journal', 'assets/images/success_Icon.svg',(){Navigator.pop(context);});
            }),
          )),
    );
  }

  Padding listModule() {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.route == DailyJournalRoute.direct ? 150.0 : 0),
      child: Visibility(
        visible: isSearchClicked == false && isDataLoading && pageNo == 1,
        child: common_loader(),
        replacement: Visibility(
          visible: datanotFound,
          child: isSearchClicked
              ? Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Container(
                      // width: double.infinity,
                      //height: 100,
                      child: Padding(
                          padding: EdgeInsets.only(
                              bottom: widget.route == DailyJournalRoute.direct
                                  ? 0
                                  : globalHeight * 0.02),
                          child: NoDataFoundWidget(
                            title: "No data found",
                            imagePath: "assets/no_data_found.png",
                          )),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Container(
                      // width: double.infinity,
                      //height: 100,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: widget.route != DailyJournalRoute.direct
                                  ? globalHeight * 0.01
                                  : 0,
                              bottom: widget.route == DailyJournalRoute.direct
                                  ? globalHeight * 0.1
                                  : globalHeight * 0.15),
                          child: NoDataFoundWidget(
                            title: "Daily Journals not available",
                            imagePath: "assets/no_data_found.png",
                          )),
                    ),
                  ),
                ),
          replacement: Padding(
            padding: EdgeInsets.only(top: 10.0),
            // child: SlidableAutoCloseBehavior(
            child: RefreshIndicator(
              onRefresh: () => pullToRefresh(),
              color: Color(0xFFBBBBC6),
              child:
                  // SingleChildScrollView(physics: AlwaysScrollableScrollPhysics(), child:
                  Container(
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
    padding: const EdgeInsets.only(left:2,right: 2.0),
    child:CupertinoScrollbar(
                    controller: _scrollController,
    child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Journallist.length,
                    controller: _scrollController,
                    //scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return CommonListContainerWidget(
                        mainTitle: Journallist[index].rotationName,
                        subTitle1: "Journal date : ",
                        title1: DateFormat("MMM dd, yyyy")
                            .format(Journallist[index].journalDate),
                        subTitle3: "Hospital site : ",
                        title3: Journallist[index].hospitalName,
                        subTitle17: "Clinician response : ",
                        title17: Journallist[index].clinicianResponse == true
                            ? "Yes"
                            : "No",
                        subTitle18: "School response : ",
                        title18: Journallist[index].schoolResponse == true
                            ? "Yes"
                            : "No",
                        btnSvgImage: (!Journallist[index].clinicianResponse &&
                                !Journallist[index].schoolResponse)
                            ? "assets/images/Edit.svg"
                            : "assets/images/eye.svg",
                        buttonTitle: (!Journallist[index].clinicianResponse &&
                                !Journallist[index].schoolResponse)
                            ? "Edit"
                            : "View",
                        navigateButton: (!Journallist[index].clinicianResponse &&
                                !Journallist[index].schoolResponse)
                            ? () async {
                                await Navigator.pushNamed(
                                  context,
                                  Routes.dailyJournalDetailsScreen,
                                  arguments: DailyJournalData(
                                      JournalId: Journallist[index].journalId,
                                      rotationId: Journallist[index].rotationId,
                                      hospitalTitle:
                                          Journallist[index].hospitalName,
                                      hospitalId:
                                          Journallist[index].hospitalSiteId,
                                      viewType: DailyJournalViewType.edit,
                                      journalDecCount: journalDecCount),
                                );
                                setState(() {
                                  pullToRefresh();
                                });
                              }
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.dailyJournalDetailDataScreen,
                                  arguments: DailyJournalDetailData(
                                    JournalId: Journallist[index].journalId,
                                    // viewType: DailyJournalViewType.view,
                                  ),
                                );
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

  Padding dateModule(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.route == DailyJournalRoute.direct ? 90 : 20,
          left: 15,
          right: 15),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              child: Material(
                color: Colors.white,
                // child: IOSKeyboardAction(
                //   label: 'DONE',
                //   focusNode: fromDateFocusNode,
                //   focusActionType: FocusActionType.done,
                //   onTap: () {},
                child: CommonTextfield(
                  autoFocus: false,
                  // focusNode: fromDateFocusNode,
                  hintText: 'From date',
                  textEditingController: fromDate,
                  validation: (value) {
                    fromDate.text = value!;
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  readOnly: true,
                  onTap: () async {
                    var results = await showCalendarDatePicker2Dialog(
                      context: context,
                      value: [from],
                      config: CalendarDatePicker2WithActionButtonsConfig(
                          lastDate: DateTime.now(),
                          selectedDayHighlightColor:
                              Color(Hardcoded.primaryGreen)),
                      dialogSize: const Size(325, 400),
                      borderRadius: BorderRadius.circular(15),
                    );
                    if (results!.first!.compareTo(to) < 0 ||
                        results.first!.compareTo(to) == 0) {
                      setState(() {
                        from = results.first!;
                        fromDate.text = DateFormat('MM-dd-yyyy').format(from);
                        if (toDate.text.isNotEmpty) {
                          getJournalList();
                        }
                      });
                    } else {
                      AppHelper.buildErrorSnackbar(
                          context, "From date can not be greater than To date");
                    }
                  },
                  sufix: GestureDetector(
                    onTap: () async {
                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        value: [from],
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            lastDate: DateTime.now(),
                            selectedDayHighlightColor:
                                Color(Hardcoded.primaryGreen)),
                        dialogSize: const Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                      );
                      if (results!.first!.compareTo(to) < 0 ||
                          results.first!.compareTo(to) == 0) {
                        setState(() {
                          from = results.first!;
                          fromDate.text = DateFormat('MM-dd-yyyy').format(from);
                          if (toDate.text.isNotEmpty) {
                            getJournalList();
                          }
                        });
                      } else {
                        if (fromDate.text.isEmpty) {
                          AppHelper.buildErrorSnackbar(
                              context, "Select first from date");
                        }
                        AppHelper.buildErrorSnackbar(context,
                            "From date can not be greater than To date");
                      }
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
            // ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Material(
              color: Colors.white,
              // child: IOSKeyboardAction(
              //   label: 'DONE',
              //   focusNode: toDateFocusNode,
              //   focusActionType: FocusActionType.done,
              //   onTap: () {},
              child: CommonTextfield(
                autoFocus: false,
                // focusNode: toDateFocusNode,
                hintText: 'To date',
                textEditingController: toDate,
                readOnly: true,
                onTap: () async {
                  if (fromDate.text.isEmpty) {
                    AppHelper.buildErrorSnackbar(
                        context, "Select first from date");
                  } else {
                    var results = await showCalendarDatePicker2Dialog(
                      context: context,
                      value: [to],
                      config: CalendarDatePicker2WithActionButtonsConfig(
                          lastDate: DateTime.now(),
                          selectedDayHighlightColor:
                              Color(Hardcoded.primaryGreen)),
                      dialogSize: const Size(325, 400),
                      borderRadius: BorderRadius.circular(15),
                    );
                    if (results!.first!.compareTo(from) > 0 ||
                        results.first!.compareTo(from) == 0) {
                      setState(() {
                        to = results.first!;
                        toDate.text = DateFormat('MM-dd-yyyy').format(to);
                        if (fromDate.text.isNotEmpty) {
                          getJournalList();
                        }
                      });
                    } else {
                      AppHelper.buildErrorSnackbar(
                          context, "To date can not be smaller than from date");
                    }
                  }
                },
                sufix: GestureDetector(
                  onTap: () async {
                    if (fromDate.text.isEmpty) {
                      AppHelper.buildErrorSnackbar(
                          context, "Please select from date first");
                    } else {
                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        value: [to],
                        config: CalendarDatePicker2WithActionButtonsConfig(
                            lastDate: DateTime.now(),
                            selectedDayHighlightColor:
                                Color(Hardcoded.primaryGreen)),
                        dialogSize: const Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                      );
                      if (results!.first!.compareTo(from) > 0 ||
                              results.first!.compareTo(from) == 0
                          // && results.first!.compareTo(to) != DateTime.now()
                          ) {
                        setState(() {
                          to = results.first!;
                          toDate.text = DateFormat('MM-dd-yyyy').format(to);
                          if (fromDate.text.isNotEmpty) {
                            getJournalList();
                          }
                        });
                      } else {
                        AppHelper.buildErrorSnackbar(context,
                            "To date can not be smaller than from date");
                      }
                    }
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
          // ),
        ],
      ),
    );
  }
}
