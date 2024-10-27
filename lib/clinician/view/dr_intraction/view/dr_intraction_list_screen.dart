// ignore_for_file: non_constant_identifier_names

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/common_widgets/uni_dr_interaction_container.dart';
import 'package:clinicaltrac/clinician/model/universal_rotation_journal_list.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/clinician/view/dr_intraction/model/uni_rotation_list_model.dart';
import 'package:clinicaltrac/clinician/view/dr_intraction/vm_model/dr_interaction_vm_conector.dart';
import 'package:clinicaltrac/clinician/view/login_screen/login_bottom_widget.dart';
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
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/redux/action/dr_interaction/get_dr_rotations_action.dart';
import 'package:clinicaltrac/redux/action/get_dailyjournal_rotation_list.dart';
import 'package:clinicaltrac/clinician/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class DrInteractionNewListScreen extends StatefulWidget {
  UniDrInteractionListScreenVM drInteractionListScreenVM;
  DrInteractionNewListScreen(
      {super.key, required this.drInteractionListScreenVM});

  @override
  State<DrInteractionNewListScreen> createState() =>
      _DrInteractionNewListScreenState();
}

class _DrInteractionNewListScreenState
    extends State<DrInteractionNewListScreen> {
  bool isExpanded = true;

  bool isSearchClicked = false;

  List<ClinicianInteractionList> localDrInteractionList = [];
  TextEditingController searchEditingController = TextEditingController();
  List<UniRotationJournalData> rotationEvalList = <UniRotationJournalData>[];
  UniRotationJournalData selectedRotationValue = new UniRotationJournalData();

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
    // store.dispatch(getStudentJournalRotationlistAction());
    addNewInteractionAsPerPageChange();
    super.initState();
    getRotationList();
  }

  @override
  void didUpdateWidget(DrInteractionNewListScreen oldWidget) {
    addNewInteractionAsPerPageChange();
    super.didUpdateWidget(oldWidget);
  }

  getCourseList() {
    rotationNameList = [];
    for (var value in rotationEvalList) {
      setState(() {
        rotationNameList.add(value.title!);
      });
    }
  }

  void addNewInteractionAsPerPageChange() async {
    // StudentDrInteractionData drInteractionList = StudentDrInteractionData(data: [], pager: Pager());
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();
    final DataResponseModel dataResponseModel =
        await dataService.getDrInterationsList(
      box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      box.get(Hardcoded.hiveBoxKey)!.accessToken,
      pageno.toString(),
      searchEditingController.text,
      widget.drInteractionListScreenVM.rotation == null ||
              widget.drInteractionListScreenVM.rotation!.rotationId.isEmpty
          ? selectedRotationId
          : widget.drInteractionListScreenVM.rotation!.rotationId,
      box.get(Hardcoded.hiveBoxKey)!.loggedUserType == "Student" ? "0" : "1",
    );

    // if (dataResponseModel.success) {
    //   if (dataResponseModel.data.isNotEmpty) {
    //     if (dataResponseModel.data.isNotEmpty) {
    //       setState(() {
    //         pageno += 1;
    //       });
    //     }
    //     log(dataResponseModel.data.toString());

    ClinicianDrInteractionPayload studentDrInteractionData =
        ClinicianDrInteractionPayload.fromJson(dataResponseModel.data);
    if (studentDrInteractionData.pager != null &&
        studentDrInteractionData.pager!.totalRecords == '0') {
      if (dataResponseModel.data.isNotEmpty) {
        setState(() {
          datanotFound = true;
        });
      }
    } else {
      setState(() {
        datanotFound = false;
      });
    }
    // log(drInteractionList.data.length.toString() + "new data to be added");

    // localDrInteractionList.data.addAll(drInteractionList.data);

    // log(localDrInteractionList.data.length.toString() + "new data after adding");
    setState(() {
      interactionDecCount =
          studentDrInteractionData.data!.interactionDescriptionCount ?? "0";
      if (pageno == 1)
        localDrInteractionList =
            studentDrInteractionData.data!.interactionList ?? [];
      else {
        for (int i = 0;
            i < studentDrInteractionData.data!.interactionList!.length;
            i++) {
          localDrInteractionList
              .add(studentDrInteractionData.data!.interactionList![i]);
        }
      }
      isDataLoading = false;
    });
    //   } else {}
    // } else {}
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
    getCourseList();
    return WillPopScope(
      onWillPop: () {
        store.dispatch(getDrInteractions(
            searchText: '',
            rotationId: widget.drInteractionListScreenVM.rotation!.rotationId,
            page: 1));
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Color(Hardcoded.white),
        floatingActionButton: commonAddButton(onTap: () async {
          // await Navigator.pushNamed(context, Routes.addDrInteractionScreen,
          //     arguments: AddViewDrIntgeractionData(
          //         rotationID: widget.rotation!.rotationId,
          //         interactionDecCount: interactionDecCount,
          //         rotationTitle: widget.rotation!.rotationTitle!,
          //         isFromDashboard: false,
          //         drIntractionAction: DrIntractionAction.add,
          //         drIntraction: localDrInteractionList.isNotEmpty
          //             ? localDrInteractionList.first
          //             : null, hospitalTitle: widget.rotation!.hospitalTitle));
          pullToRefresh();
          // common_alert_pop(context, 'Successfully created\ndr. interaction.', 'assets/images/success_Icon.svg',(){Navigator.pop(context);});
        }),
        // floatingActionButton: Visibility(
        //   visible: widget.showAdd,
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.pushNamed(context, Routes.addDrInteractionScreen,
        //           arguments: AddViewDrIntgeractionData(
        //               rotationId: widget.rotation.rotationId,
        //               rotationTitle: widget.rotation.rotationTitle,
        //               isFromDashboard: false,
        //               drIntractionAction: DrIntractionAction.add,
        //               drIntraction: localDrInteractionList.data.isNotEmpty
        //                   ? localDrInteractionList.data.first
        //                   : null));
        //     },
        //     child: Container(
        //       decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: Color(Hardcoded.orange),
        //           boxShadow: [
        //             BoxShadow(
        //                 blurRadius: 10,
        //                 offset: const Offset(2, 2),
        //                 blurStyle: BlurStyle.normal,
        //                 color: Color(Hardcoded.orange))
        //           ]),
        //       child: Padding(
        //         padding: const EdgeInsets.all(12.0),
        //         child: Icon(
        //           Icons.add,
        //           size: 35,
        //           color: Color(Hardcoded.white),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        appBar: CommonAppBar(
          onSearchTap: () {
            setState(() {
              if (isSearchClicked) {
                // log("1111111111");
                store.dispatch(getDrInteractions(
                  searchText: '',
                  rotationId: widget.drInteractionListScreenVM.rotation!
                          .rotationId.isEmpty
                      ? selectedRotationId
                      : widget.drInteractionListScreenVM.rotation!.rotationId,
                  // page: 1
                ));
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
                              rotationId: widget.drInteractionListScreenVM
                                      .rotation!.rotationId.isEmpty
                                  ? selectedRotationId
                                  : widget.drInteractionListScreenVM.rotation!
                                      .rotationId,
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
                rotationId:
                    widget.drInteractionListScreenVM.rotation!.rotationId,
                page: 1));
            Navigator.pop(context);
          },
        ),
        body: widget.drInteractionListScreenVM.showAdd!
            ? Column(
                children: [
                  common_green_rotation_card(
                    date:
                        '${widget.drInteractionListScreenVM.rotation!.startDate.day}',
                    month:
                        "${Hardcoded.getMonthString(widget.drInteractionListScreenVM.rotation!.startDate.month)}",
                    text1:
                        "${widget.drInteractionListScreenVM.rotation!.rotationTitle}",
                    text2:
                        "${widget.drInteractionListScreenVM.rotation!.hospitalTitle}",
                    text3:
                        "${widget.drInteractionListScreenVM.rotation!.courseTitle}",
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
                    child: ExpansionWidget<UniRotationJournalData>(
                      hintText:
                          selectedRotationValue.title != "All" ? "All" : '',
                      // enabled: selectAllCourseTopic.toString().isEmpty
                      //     ? true
                      //     : false,
                      textColor: Colors.black,
                      OnSelection: (value) {
                        setState(() {
                          UniRotationJournalData c =
                              value as UniRotationJournalData;
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
                      items: List.of(rotationEvalList.map((item) {
                        String text = item.title.toString();
                        List<String> title = text.split("(");
                        String subText = title[0].toString() == "All"
                            ? title[0]
                            : title[1].toString();
                        List<String> subTitle = subText.split(")");
                        return DropdownItem<UniRotationJournalData>(
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
                    // child: CommonExpansion(
                    //   OnSelection: (String value) {
                    //     setState(() {
                    //       isSearchClicked = false;
                    //       selectedRotataion = value;
                    //       pageno = 1;
                    //     });
                    //     store.dispatch(getDrInteractions(
                    //         searchText: '',
                    //         rotationId: getRotationIdByName(value),
                    //         page: pageno));
                    //   },
                    //   bodyList: rotationNameList,
                    //   trailIcon: "",
                    //   hintText: widget.rotation.rotationTitle.isNotEmpty
                    //       ? widget.rotation.rotationTitle
                    //       : 'All',
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
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: localDrInteractionList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Text("sss"),
                        );
                        //                 return DrInteractionContainer(
                        //                     // onTap: () {
                        //                     //   setState(() {});
                        //                     //   Navigator.pushNamed(
                        //                     //     context,
                        //                     //     Routes.addDrInteractionScreen,
                        //                     //     arguments: AddViewDrIntgeractionData(
                        //                     //         rotationId: widget.drIntraction.rotationId,
                        //                     //         rotationTitle:
                        //                     //             widget.drIntraction.rotationName,
                        //                     //         drIntractionAction: DrIntractionAction.edit,
                        //                     //         drIntraction: widget.drIntraction,
                        //                     //         isFromDashboard: widget.isFromDashboard),
                        //                     //   );
                        //                     //   addNewInteractionAsPerPageChange();
                        //                     // },
                        //                     color: initialColor
                        //                         .elementAt(index % initialColor.length),
                        //                     drIntraction:
                        //                         localDrInteractionList.elementAt(index),
                        //                   isFromDashboard: !widget.showAdd!,
                        //                     interactionDecCount: interactionDecCount,
                        //                     // pullToRefresh: addNewInteractionAsPerPageChange,
                        //                     pullToRefresh: pullToRefresh,
                        //                     onTapDelete: () {
                        //                       common_popup_widget(
                        //                           context,
                        //                           'Do you want to delete Dr. Interaction?',
                        //                           'assets/images/deleteicon.svg', () async {
                        //                         // Navigator.pop(context);
                        //                         final DataService dataService = locator();
                        //                         final DataResponseModel dataResponseModel =
                        //                             await dataService.deleteData(
                        //                           localDrInteractionList
                        //                               .elementAt(index)
                        //                               .interactionId,
                        //                          box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
                        // box.get(Hardcoded.hiveBoxKey)!.accessToken,
                        //                           "interaction | attendance | incident | volunteerEval",
                        //                           "interaction",
                        //                         );
                        //                         // log("${dataResponseModel.success}");
                        //                         if (dataResponseModel.success) {
                        //                           delete.success();
                        //                           Future.delayed(const Duration(seconds: 3),
                        //                               () {
                        //                             Navigator.pop(context);
                        //                             AppHelper.buildErrorSnackbar(context,
                        //                                 "Dr. Interaction deleted successfully");
                        //                             store.dispatch(getDrInteractions(
                        //                                 searchText: '',
                        //                                 rotationId:
                        //                                     widget.rotation!.rotationId.isEmpty
                        //                                         ? selectedRotationId
                        //                                         : widget.rotation!.rotationId,
                        //                                 page: 1));
                        //                           });
                        //                         } else {
                        //                           delete.error();
                        //                           Future.delayed(const Duration(seconds: 3),
                        //                               () {
                        //                             delete.reset();
                        //                           });
                        //                         }
                        //                       });
                        //                     });
                      }),
                ),
                // ),
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
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: localDrInteractionList.length,
                      shrinkWrap: true,
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
                        // Container(child: Text("sss"),);
                        return UniDrInteractionContainer(
                            color: finalColorList.elementAt(index),
                            drIntraction:
                                localDrInteractionList.elementAt(index),
                            isFromDashboard:
                                !widget.drInteractionListScreenVM.showAdd!,
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
                                          .interactionId ??
                                      "",
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
                                        rotationId: widget
                                                .drInteractionListScreenVM
                                                .rotation!
                                                .rotationId
                                                .isEmpty
                                            ? selectedRotationId
                                            : widget.drInteractionListScreenVM
                                                .rotation!.rotationId,
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
        // ),
      ),
    );
  }

  Future<void> getRotationList() async {
    UserDatRepo userDatRepo = new UserDatRepo();
    SMRotationListStudentJournal smRotationListStudentJournal =
        await userDatRepo.getJournalRotationlistAction();
    setState(() {
      rotationEvalList = smRotationListStudentJournal.data;
    });
  }
}
