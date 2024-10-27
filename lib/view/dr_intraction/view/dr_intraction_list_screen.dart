// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_add_button.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_green_rotation.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/dr_interaction_container.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/dr_interaction/get_dr_rotations_action.dart';
import 'package:clinicaltrac/redux/action/get_dailyjournal_rotation_list.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/dr_intraction/vm_conector/add_view_dr_interaction_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DrInteractionListScreen extends StatefulWidget {
  const DrInteractionListScreen(
      {super.key,
      required this.drInteractionList,
      required this.active_status,
      required this.rotationListStudentJournal,
      required this.showAdd,
      required this.rotation,
      this.isFromDashboard});

  final StudentDrInteractionData drInteractionList;

  final RotationListStudentJournal rotationListStudentJournal;

  final Active_status active_status;

  final bool showAdd;

  final Rotation rotation;
  final bool? isFromDashboard;

  @override
  State<DrInteractionListScreen> createState() =>
      _DrInteractionListScreenState();
}

class _DrInteractionListScreenState extends State<DrInteractionListScreen> {
  bool isExpanded = true;

  bool isSearchClicked = false;

  // StudentDrInteractionData localDrInteractionList = StudentDrInteractionData(data: , pager: Pager());
  List<UniDrInteractionList> localDrInteractionList = [];
  TextEditingController searchEditingController = TextEditingController();
  List<RotationJournalData> rotationEvalList = <RotationJournalData>[];
  RotationJournalData selectedRotationValue = new RotationJournalData();

  ScrollController scrollController = ScrollController();

  List<String> rotationNameList = [];

  int pageno = 1;

  String selectedRotation = '';
  String selectedRotationId = '';
  String interactionDecCount = '';
  bool isDataLoading = true;
  bool datanotFound = true;
  RoundedLoadingButtonController delete = RoundedLoadingButtonController();

  @override
  void dispose() {
    scrollController.removeListener(pagination);
    super.dispose();
  }

  @override
  void initState() {
    scrollController.addListener(pagination);
    store.dispatch(getStudentJournalRotationlistAction());
    addNewInteractionAsPerPageChange();
    super.initState();
    rotationEvalList = widget.rotationListStudentJournal.data!;
  }

  @override
  void didUpdateWidget(DrInteractionListScreen oldWidget) {
    addNewInteractionAsPerPageChange();
    super.didUpdateWidget(oldWidget);
  }

  getCourseList() {
    rotationNameList = [];
    for (var value in widget.rotationListStudentJournal.data) {
      setState(() {
        rotationNameList.add(value.title!);
      });
    }
  }

  Future<void> addNewInteractionAsPerPageChange() async {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getDrInterations(
            box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
            box.get(Hardcoded.hiveBoxKey)!.accessToken,
            pageno.toString(),
            searchEditingController.text,
            widget.rotation.rotationId.isEmpty
                ? selectedRotationId
                : widget.rotation.rotationId);

    StudentDrInteractionData studentDrInteractionData =
        StudentDrInteractionData.fromJson(dataResponseModel.data);
    if (studentDrInteractionData.pager.totalRecords == '0') {
      if (dataResponseModel.data.isNotEmpty) {
        if (mounted) {
          setState(() {
            datanotFound = true;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          datanotFound = false;
        });
      }
    }
    if (mounted) {
      setState(() {
        interactionDecCount =
            studentDrInteractionData.data.interactionDescriptionCount;
        if (pageno == 1)
          localDrInteractionList =
              studentDrInteractionData.data.interactionList;
        else {
          for (int i = 0;
              i < studentDrInteractionData.data.interactionList.length;
              i++) {
            localDrInteractionList
                .add(studentDrInteractionData.data.interactionList[i]);
          }
        }
        isDataLoading = false;
      });
    }
  }

  void pagination() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      pageno += 1;
      addNewInteractionAsPerPageChange();
    }
  }

  Future<void> pullToRefresh() async {
    isDataLoading = true;
    pageno = 1;
    addNewInteractionAsPerPageChange();
    searchEditingController.text = '';
    isSearchClicked = false;
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

  final searchFocusNode = FocusNode();

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  List<Color> initialColor = [
    Color(Hardcoded.orange),
    Color(Hardcoded.blue),
    Color(Hardcoded.pink)
  ];

  @override
  Widget build(BuildContext context) {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    rotationEvalList = widget.rotationListStudentJournal.data!;
    getCourseList();
    return WillPopScope(
      onWillPop: () {
        widget.showAdd
            ? Navigator.pop(context)
            : Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                arguments: BodySwitcherData(
                    initialPage: Bottom_navigation_control.home));
        store.dispatch(getDrInteractions(
            searchText: '', rotationId: widget.rotation.rotationId, page: 1));
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Color(Hardcoded.white),
        floatingActionButton: commonAddButton(onTap: () async {
          await Navigator.pushNamed(context, Routes.addDrInteractionScreen,
              arguments: AddViewDrIntgeractionData(
                  rotationID: widget.rotation.rotationId,
                  interactionDecCount: interactionDecCount,
                  rotationTitle: widget.rotation.rotationTitle,
                  hospitalTitle: widget.rotation.hospitalTitle,
                  // "${widget.rotation.rotationTitle} ${widget.rotation.hospitalTitle != null && widget.rotation.hospitalTitle.isNotEmpty ? "(${widget.rotation.hospitalTitle})": widget.rotation.hospitalTitle}",
                  isFromDashboard: false,
                  drIntractionAction: DrIntractionAction.add,
                  drIntraction: localDrInteractionList.isNotEmpty
                      ? localDrInteractionList.first
                      : null));
          pullToRefresh();
          // common_alert_pop(context, 'Successfully created\ndr. interaction.', 'assets/images/success_Icon.svg',(){Navigator.pop(context);});
        }),
        appBar: CommonAppBar(
          onSearchTap: () {
            setState(() {
              if (isSearchClicked) {
                // log("1111111111");
                store.dispatch(
                  getDrInteractions(
                    searchText: '',
                    rotationId: widget.rotation.rotationId.isEmpty
                        ? selectedRotationId
                        : widget.rotation.rotationId,
                    // page: 1
                  ),
                );
              }
              pageno = 1;
              isSearchClicked = !isSearchClicked;
              searchEditingController.text = '';
              FocusScope.of(context).unfocus();
            });
          },
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
                        textEditingController: searchEditingController,
                        onChanged: (value) {
                          store.dispatch(getDrInteractions(
                              searchText: value,
                              rotationId: widget.rotation.rotationId.isEmpty
                                  ? selectedRotationId
                                  : widget.rotation.rotationId,
                              page: pageno));
                        },
                      ),
                    ),
                  ),
                )
              : Text("Dr. Interaction",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      )),
          searchEnabeled: true,
          image: !isSearchClicked
              ? SvgPicture.asset(
                  'assets/images/search.svg',
                )
              : SvgPicture.asset(
                  'assets/images/closeicon.svg',
                ),
          onTap: () {
            store.dispatch(getDrInteractions(
                searchText: '',
                rotationId: widget.rotation.rotationId,
                page: 1));

            widget.showAdd
                ? Navigator.pop(context)
                : Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                    arguments: BodySwitcherData(
                        initialPage: Bottom_navigation_control.home));
          },
        ),
        body: widget.showAdd
            ? Column(
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
                    child: drInteractionListView(),
                  ),
                ],
              )
            : Stack(
                children: [
                  drInteractionListView2(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: ExpansionWidget<RotationJournalData>(
                      hintText:
                          selectedRotationValue.title != "All" ? "All" : '',
                      textColor: Colors.black,
                      OnSelection: (value) {
                        setState(() {
                          RotationJournalData c = value as RotationJournalData;
                          selectedRotationValue = c;
                          // singleCourseTopicList.clear();
                          selectedRotationId =
                              selectedRotationValue.rotationId.toString();
                          selectedRotation =
                              selectedRotationValue.title.toString();
                          store.dispatch(getDrInteractions(
                              searchText: '',
                              rotationId:
                                  selectedRotationValue.rotationId.toString(),
                              page: pageno));

                          pageno = 1;
                          searchEditingController.text = '';
                          isSearchClicked = false;
                        });
                        // log("id---------${selectedRotationValue.rotationId}");
                      },
                      items: List.of(
                        rotationEvalList.map(
                          (item) {
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
                                        ? Text(
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
                                                  color: Color(
                                                    Hardcoded.greyText,
                                                  ),
                                                ),
                                          )
                                        : Container(),
                                  ],
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

  drInteractionListView2() {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    return Padding(
      padding: EdgeInsets.only(top: globalHeight * 0.09),
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Visibility(
          visible: isSearchClicked == false && isDataLoading && pageno == 1,
          child: common_loader(),
          replacement: Visibility(
            visible: localDrInteractionList.isEmpty,
            child: isSearchClicked
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: globalHeight * 0.01,
                            bottom: globalHeight * 0.1),
                        child: NoDataFoundWidget(
                          title: "No data found",
                          imagePath: "assets/no_data_found.png",
                        )),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: globalHeight * 0.01, bottom: globalHeight * 0.1),
                      child: NoDataFoundWidget(
                        title: "Dr. Interactions not available",
                        imagePath: "assets/no_data_found.png",
                      ),
                    ),
                  ),
            replacement: Padding(
              padding: EdgeInsets.only(top: 10.0),
              // child: SlidableAutoCloseBehavior(
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
                    padding: const EdgeInsets.only(left: 2, right: 2.0),
                    child: CupertinoScrollbar(
                      controller: scrollController,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: localDrInteractionList.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return DrInteractionContainer(
                              // onTap: () {
                              //   setState(() {});
                              //   Navigator.pushNamed(
                              //     context,
                              //     Routes.addDrInteractionScreen,
                              //     arguments: AddViewDrIntgeractionData(
                              //         rotationId: widget.drIntraction.rotationId,
                              //         rotationTitle:
                              //             widget.drIntraction.rotationName,
                              //         drIntractionAction: DrIntractionAction.edit,
                              //         drIntraction: widget.drIntraction,
                              //         isFromDashboard: widget.isFromDashboard),
                              //   );
                              //   addNewInteractionAsPerPageChange();
                              // },
                              color: initialColor
                                  .elementAt(index % initialColor.length),
                              drIntraction:
                                  localDrInteractionList.elementAt(index),
                              isFromDashboard: !widget.showAdd,
                              interactionDecCount: interactionDecCount,
                              // pullToRefresh: addNewInteractionAsPerPageChange,
                              pullToRefresh: pullToRefresh,
                              onTapDelete: () {
                                common_popup_widget(
                                    context,
                                    'Do you want to delete Dr. Interaction?',
                                    'assets/images/deleteicon.svg', () async {
                                  // Navigator.pop(context);
                                  final DataService dataService = locator();
                                  final DataResponseModel dataResponseModel =
                                      await dataService.deleteData(
                                    localDrInteractionList
                                        .elementAt(index)
                                        .interactionId,
                                    box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                                    box.get(Hardcoded.hiveBoxKey)!.accessToken,
                                    "interaction | attendance | incident | volunteerEval",
                                    "interaction",
                                  );
                                  // log("${dataResponseModel.success}");
                                  if (dataResponseModel.success) {
                                    delete.success();
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      Navigator.pop(context);
                                      AppHelper.buildErrorSnackbar(context,
                                          "Dr. Interaction deleted successfully");
                                      store.dispatch(getDrInteractions(
                                          searchText: '',
                                          rotationId:
                                              widget.rotation.rotationId.isEmpty
                                                  ? selectedRotationId
                                                  : widget.rotation.rotationId,
                                          page: 1));
                                    });
                                  } else {
                                    delete.error();
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      delete.reset();
                                    });
                                  }
                                });
                              });
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
      ),
    );
  }

  drInteractionListView() {
    return Padding(
      padding: EdgeInsets.only(top: globalHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Visibility(
          visible: isSearchClicked == false && isDataLoading && pageno == 1,
          child: common_loader(),
          replacement: Visibility(
            visible: localDrInteractionList.isEmpty,
            child: isSearchClicked
                ? Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: globalHeight * 0.01,
                            bottom: globalHeight * 0.1),
                        child: NoDataFoundWidget(
                          title: "No data found",
                          imagePath: "assets/no_data_found.png",
                        )),
                  )
                : Center(
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: globalHeight * 0.01,
                            bottom: globalHeight * 0.1),
                        child: NoDataFoundWidget(
                          title: "Dr. Interactions not available",
                          imagePath: "assets/no_data_found.png",
                        )),
                  ),
            replacement: Padding(
              padding: EdgeInsets.only(top: 10.0),
              // child: SlidableAutoCloseBehavior(
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
                    padding: const EdgeInsets.only(left: 2, right: 2.0),
                    child: CupertinoScrollbar(
                      controller: scrollController,
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: localDrInteractionList.length,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            List<Color> initialColor = [
                              Color(Hardcoded.orange),
                              Color(Hardcoded.blue),
                              Color(Hardcoded.pink)
                            ];

                            List<Color> finalColorList = [];

                            for (var i = 0;
                                i < localDrInteractionList.length;
                                i++) {
                              finalColorList
                                  .add(initialColor[i % initialColor.length]);
                            }
                            return DrInteractionContainer(
                                color: finalColorList.elementAt(index),
                                drIntraction:
                                    localDrInteractionList.elementAt(index),
                                isFromDashboard: !widget.showAdd,
                                interactionDecCount: interactionDecCount,
                                // pullToRefresh: addNewInteractionAsPerPageChange,
                                pullToRefresh: pullToRefresh,
                                onTapDelete: () {
                                  common_popup_widget(
                                      context,
                                      'Do you want to delete Dr. Interaction?',
                                      'assets/images/deleteicon.svg', () async {
                                    // Navigator.pop(context);
                                    Box<UserLoginResponseHive>? box =
                                        Boxes.getUserInfo();
                                    final DataService dataService = locator();
                                    final DataResponseModel dataResponseModel =
                                        await dataService.deleteData(
                                      localDrInteractionList
                                          .elementAt(index)
                                          .interactionId,
                                      box
                                          .get(Hardcoded.hiveBoxKey)!
                                          .loggedUserId,
                                      box
                                          .get(Hardcoded.hiveBoxKey)!
                                          .accessToken,
                                      "interaction | attendance | incident | volunteerEval",
                                      "interaction",
                                    );
                                    // log("${dataResponseModel.success}");
                                    if (dataResponseModel.success) {
                                      delete.success();
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        Navigator.pop(context);
                                        AppHelper.buildErrorSnackbar(context,
                                            "Dr. Interaction deleted successfully");
                                        store.dispatch(getDrInteractions(
                                            searchText: '',
                                            rotationId: widget
                                                    .rotation.rotationId.isEmpty
                                                ? selectedRotationId
                                                : widget.rotation.rotationId,
                                            page: 1));
                                      });
                                    } else {
                                      delete.error();
                                      Future.delayed(const Duration(seconds: 3),
                                          () {
                                        delete.reset();
                                      });
                                    }
                                  });
                                });
                          }),
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
