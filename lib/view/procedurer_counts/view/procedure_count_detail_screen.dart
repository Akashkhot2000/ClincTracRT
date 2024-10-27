import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_text_widget.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/expanded_container_widget.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_detail_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_detail_request.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_request_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/create_procedure_count_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class ProcedureCountDetailScreen extends StatefulWidget {
  ProcedureCountDetailScreen(
      {Key? key,
      required this.procedureCountTopicId,
      this.allRotation,
      this.rotationId,
      this.isFromCheckoff,
      this.checkOffId})
      : super(key: key);
  final procedureCountTopicId;
  final AllRotation? allRotation;
  String? rotationId;
  String? checkOffId;
  bool? isFromCheckoff;

  @override
  State<ProcedureCountDetailScreen> createState() =>
      _ProcedureCountDetailScreenState();
}

class _ProcedureCountDetailScreenState
    extends State<ProcedureCountDetailScreen> {
  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<ProcedureCountData> procedureCountData = [];
  bool isDataLoaded = true;
  bool isSearchClicked = false;

  TextEditingController textController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  void getProcedureCountList() async {
    // if (pageNo == 1 || pageNo <= lastpage) {
    setState(() {
      isDataLoaded = true;
    });
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    final DataService dataService = locator();

    ProceduerCountRequest request = ProceduerCountRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      RotationId: widget.rotationId!,
      pageNo: pageNo.toString(),
      RecordsPerPage: '10',
    );
    final DataResponseModel dataResponseModel =
        await dataService.getProcedureCountList(request);
    ProcedureCountModel procedureCountModel =
        ProcedureCountModel.fromJson(dataResponseModel.data);
    setState(() {
      procedureCountData.addAll(procedureCountModel.data);
      procedureCountData = procedureCountModel.data;
      isDataLoaded = false;
    });
    getStudentProcedureCountDetails();
  }

  List<ProcedureCountDetail> procedureCountDetails = [];

  void getStudentProcedureCountDetails() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      ProcedureCountDetailRequest request = ProcedureCountDetailRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        RotationId: widget.rotationId!,
        procedureCategoryId: procedureCountData[_selectedIndex].pcId,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        SearchText: searchTextController.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getProcedureCountDetails(request);
      ProcedureCountDetailsModel procedureCountDetailsModel =
          ProcedureCountDetailsModel.fromJson(dataResponseModel.data);
      lastpage = (int.parse(procedureCountDetailsModel.pager.totalRecords!) / 5)
          .ceil();
      if (procedureCountDetailsModel.pager.totalRecords == '0') {
        setState(() {
          datanotFound = true;
        });
      } else {
        setState(() {
          datanotFound = false;
        });
      }
      setState(() {
        if (pageNo != 1) {
          procedureCountDetails.addAll(procedureCountDetailsModel.data);
        } else {
          procedureCountDetails = procedureCountDetailsModel.data;
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
      getStudentProcedureCountDetails();
    }
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    searchTextController.text = '';
    getProcedureCountList();
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
    setState(() {
      getProcedureCountList();
    });
    procedureCountDetails.length;
  }

  int _expandedIndex = -1;

  void _handleTileTap(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = -1; // Collapse the currently expanded tile.
      } else {
        _expandedIndex = index;
      }
    });
  }

  int _selectedIndex = 0;
  final searchFocusNode = FocusNode();
  String proTopicId = '';
  List<Color> initialColor = [
    Color(Hardcoded.blue),
    Color(Hardcoded.orange),
    Color(Hardcoded.purple),
    Color(Hardcoded.pink)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        titles: isSearchClicked
            ? Padding(
                padding: const EdgeInsets.only(
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
                      textEditingController: searchTextController,
                      onChanged: (value) {
                        pageNo = 1;
                        getStudentProcedureCountDetails();
                      },
                    ),
                  ),
                ),
              )
            : Text(
                "View History",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
              ),
        searchEnabeled: true,
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
            searchTextController.text = '';
            FocusScope.of(context).unfocus();
            if (isSearchClicked == false) getStudentProcedureCountDetails();
          });
        },
      ),
      body: Column(
        children: [
          Container(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: procedureCountData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    pageNo = 1;
                    getStudentProcedureCountDetails();
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
                          left: 15,
                          right: procedureCountData[index].title.isNotEmpty
                              ? 15
                              : 0),
                      child: Container(
                        height: globalHeight * 0.06,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: globalHeight * 0.001),
                                child: Text(
                                  procedureCountData[index].title,
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
          SizedBox(height: 0),
          Visibility(
            visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
            child: Padding(
              padding: EdgeInsets.only(top: globalHeight * 0.3),
              child: common_loader(),
            ),
            replacement: Visibility(
                visible: !datanotFound,
                replacement: isSearchClicked
                    ? Center(
                        child: Padding(
                            padding: EdgeInsets.only(top: globalHeight * 0.3),
                            child: NoDataFoundWidget(
                              // title: "Procedure count details not available",
                              title: "No data found",
                              imagePath: "assets/no_data_found.png",
                            )),
                      )
                    : Center(
                        child: Padding(
                            padding: EdgeInsets.only(
                              top: globalHeight * 0.3,
                            ),
                            child: NoDataFoundWidget(
                              title: "Procedure Count History not available",
                              // title: "No data found",
                              imagePath: "assets/no_data_found.png",
                            )),
                      ),
                child:
                    // procedureCountDetails.isNotEmpty ?
                    Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 1,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                        getStudentProcedureCountDetails();
                      });
                    },
                    itemBuilder: (context, index) {
                      proTopicId =
                          procedureCountDetails[index].procedureCountTopicId;
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
                            child:CupertinoScrollbar(
                    controller: _scrollController,
                              child: ListView.builder(
                                itemCount: procedureCountDetails.length,
                                shrinkWrap: true,
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  final isExpanded = _expandedIndex == index;
                                  return Column(children: [
                                    Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(top: 0, bottom: 0),
                                        child: ExpansionTileContainer(
                                          leading: Container(
                                            height: globalHeight * 0.05,
                                            width: store
                                                        .state
                                                        .userLoginResponse
                                                        .data
                                                        .loggedUserSchoolType ==
                                                    "Military"
                                                ? globalWidth * 0.18
                                                : globalWidth * 0.15,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: initialColor
                                                  .elementAt(index %
                                                      initialColor.length)
                                                  .withOpacity(0.2),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "${procedureCountDetails[index].procedureCountsCode}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: "Poppins",
                                                        color: initialColor
                                                            .elementAt(index %
                                                                initialColor
                                                                    .length)),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            "${procedureCountDetails[index].procedureCountName}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins",
                                                ),
                                          ),
                                          textColor: Colors.black,
                                          iconColor: Colors.black,
                                          onExpansionChanged: (expanded) {
                                            if (expanded) {
                                              _handleTileTap(index);
                                            }
                                          },
                                          initiallyExpanded: isExpanded,
                                          children: [
                                            ListView.builder(
                                              itemCount:
                                                  procedureCountDetails[index]
                                                      .procedureCount
                                                      .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              // controller: _scrollController,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index1) {
                                                return CommonListContainerWidget(
                                                  mainTitle:
                                                      "Procedure date : ${DateFormat("MMM dd, yyyy").format(procedureCountDetails[index].procedureCount[index1].procedureDate!)}",
                                                  subTitle1: widget
                                                              .isFromCheckoff ==
                                                          true
                                                      ? procedureCountDetails[
                                                                      index]
                                                                  .procedureCount[
                                                                      index1]
                                                                  .evalutionDate ==
                                                              null
                                                          ? ""
                                                          : "Evaluation date : "
                                                      : null,
                                                  title1: widget
                                                              .isFromCheckoff ==
                                                          true
                                                      ? procedureCountDetails[
                                                                      index]
                                                                  .procedureCount[
                                                                      index1]
                                                                  .evalutionDate ==
                                                              null
                                                          ? ""
                                                          : DateFormat(
                                                                  "MMM dd, yyyy")
                                                              .format(procedureCountDetails[
                                                                      index]
                                                                  .procedureCount[
                                                                      index1]
                                                                  .evalutionDate!)
                                                      : null,
                                                  divider: Divider(
                                                    thickness: 1,
                                                  ),
                                                  subTitle7: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .procedurePointsAssist ==
                                                          ''
                                                      ? ''
                                                      : "Assisted : ",
                                                  title7: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .procedurePointsAssist ==
                                                          ''
                                                      ? ""
                                                      : procedureCountDetails[
                                                              index]
                                                          .procedureCount[
                                                              index1]
                                                          .procedurePointsAssist,
                                                  subTitle8: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .procedurePointsObserve ==
                                                          ''
                                                      ? ''
                                                      : "Performed : ",
                                                  title8: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .procedurePointsPerform ==
                                                          ''
                                                      ? ""
                                                      : procedureCountDetails[
                                                              index]
                                                          .procedureCount[
                                                              index1]
                                                          .procedurePointsPerform,
                                                  subTitle9: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .procedurePointsPerform ==
                                                          ''
                                                      ? ''
                                                      : "Procedure Total : ",
                                                  title9: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .total ==
                                                          ''
                                                      ? ""
                                                      : procedureCountDetails[
                                                              index]
                                                          .procedureCount[
                                                              index1]
                                                          .total,
                                                  subTitle12:
                                                      procedureCountDetails[
                                                                      index]
                                                                  .procedureCount[
                                                                      index1]
                                                                  .total ==
                                                              ''
                                                          ? ''
                                                          : "Observed : ",
                                                  title12: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .procedurePointsObserve ==
                                                          ''
                                                      ? ""
                                                      : procedureCountDetails[
                                                              index]
                                                          .procedureCount[
                                                              index1]
                                                          .procedurePointsObserve,
                                                  subTitle13: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .procedurePointsPerformTotal ==
                                                          ''
                                                      ? ''
                                                      : "Performed Total : ",
                                                  title13: procedureCountDetails[
                                                                  index]
                                                              .procedureCount[
                                                                  index1]
                                                              .procedurePointsPerformTotal ==
                                                          ''
                                                      ? ""
                                                      : procedureCountDetails[
                                                              index]
                                                          .procedureCount[
                                                              index1]
                                                          .procedurePointsPerformTotal,
                                                  buttonTitle:
                                                      "Edit Procedure Count",
                                                  btnSvgImage:
                                                      "assets/images/Edit.svg",
                                                  navigateButton: () async {
                                                    await Navigator.of(context)
                                                        .push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CreateProcedureCountScreen(
                                                          procedureCountData:
                                                              procedureCountDetails[
                                                                          index]
                                                                      .procedureCount[
                                                                  index1],
                                                          procedureCountDetail:
                                                              procedureCountDetails[
                                                                  index],
                                                          procedureCount:
                                                              ProcedureCountStatus
                                                                  .edit,
                                                          rotationId: widget
                                                              .rotationId!,
                                                        ),
                                                      ),
                                                    );
                                                    getProcedureCountList();
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    )
                                  ]);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                //   :Center(
                // child: Padding(
                //     padding: EdgeInsets.only(
                //         top: globalHeight * 0.01,
                //         bottom: globalHeight * 0.1),
                //     child: NoDataFoundWidget(
                //       title: "Procedure count details not available",
                //       // title: "No data found",
                //       imagePath: "assets/no_data_found.png",
                //     ),),
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
