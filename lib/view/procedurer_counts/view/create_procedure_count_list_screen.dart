import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/procedure_count_request_model.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/student_procedure_list/student_procedure_list_request.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/student_procedure_list/student_procedure_list_responce.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/create_procedure_count_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_detail_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_steps_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class CreateProcedureCountListScreen extends StatefulWidget {
  CreateProcedureCountListScreen(
      {Key? key,
      this.allRotation,
      this.rotationId,
      this.isFromCheckoff,
      this.checkOffId})
      : super(key: key);
  final AllRotation? allRotation;
  String? rotationId;
  bool? isFromCheckoff;
  String? checkOffId;

  @override
  State<CreateProcedureCountListScreen> createState() =>
      _CreateProcedureCountListScreenState();
}

class _CreateProcedureCountListScreenState
    extends State<CreateProcedureCountListScreen> {
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
    getStudentProcedureListData();
  }

  List<StudentProcedureListData> studentProcedureListData = [];

  void getStudentProcedureListData() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      StudentProceduerRequest request = StudentProceduerRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        // RotationId: widget.allRotation.rotationId,
        procedureCategoryId: procedureCountData[_selectedIndex].pcId,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        SearchText: searchTextController.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getStudentProcedureList(request);
      StudentProcedureListModel studentProcedureListModel =
          StudentProcedureListModel.fromJson(dataResponseModel.data);
      log("Total Count ${studentProcedureListModel.pager.totalRecords}");
      lastpage =
          (int.parse(studentProcedureListModel.pager.totalRecords!) / 5).ceil();
      if (studentProcedureListModel.pager.totalRecords == '0') {
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
          studentProcedureListData.addAll(studentProcedureListModel.data);
        } else {
          studentProcedureListData = studentProcedureListModel.data;
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
      getStudentProcedureListData();
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
  }

  List<Color> initialColor = [
    Color(Hardcoded.blue),
    Color(Hardcoded.orange),
    Color(Hardcoded.purple),
    Color(Hardcoded.pink)
  ];
  int _selectedIndex = 0;
  final searchFocusNode = FocusNode();
  String proTopicId = '';

  @override
  Widget build(BuildContext context) {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
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
                        getStudentProcedureListData();
                      },
                    ),
                  ),
                ),
              )
            : Text(
                "Procedure Count",
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
            if (isSearchClicked == false) getStudentProcedureListData();
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: globalHeight * 0.08,
        elevation: 0,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProcedureCountDetailScreen(
                      procedureCountTopicId: proTopicId,
                      allRotation: widget.allRotation,
                      rotationId: widget.rotationId,
                      isFromCheckoff: widget.isFromCheckoff,
                      checkOffId: widget.checkOffId,
                      // procedureCountDetail: [],
                    )));
          },
          child: Padding(
            padding: EdgeInsets.only(
                top: 10,
                left: globalWidth * 0.05,
                right: globalWidth * 0.05,
                bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xFF01A750),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/images/clock.svg"),
                  SizedBox(
                    width: globalWidth * 0.01,
                  ),
                  Text(
                    "View History",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF01A750)),
                  ),
                  SizedBox(
                    width: globalWidth * 0.01,
                  ),
                  SvgPicture.asset(
                    "assets/images/right_arrow.svg",
                    color: Color(0xFF01A750),
                    height: globalHeight * 0.018,
                  ),
                ],
              ),
            ),
          ),
        ),
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
                    getStudentProcedureListData();
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
                            title: "Procedure Counts not available",
                            // title: "No data found",
                            imagePath: "assets/no_data_found.png",
                          )),
                    ),
              child: Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 1,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                      getStudentProcedureListData();
                    });
                  },
                  itemBuilder: (context, index) {
                    proTopicId = studentProcedureListData[index].pcTopicId;
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
                              itemCount: studentProcedureListData.length,
                              shrinkWrap: true,
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                // List<Color> initialColor = [
                                //   Color(Hardcoded.blue),
                                //   Color(Hardcoded.orange),
                                //   Color(Hardcoded.purple),
                                //   Color(Hardcoded.pink)
                                // ];
                                // List<Color> finalColorList = [];
                                //
                                // for (var i = 0; i < 500; i++) {
                                //   finalColorList.add(
                                //     initialColor[i % initialColor.length],
                                //   );
                                // }
                                return Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            right: 20,
                                            left: 15,
                                            bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: globalHeight * 0.05,
                                              width: box
                                                          .get(Hardcoded
                                                              .hiveBoxKey)!
                                                          .loggedUserSchoolType ==
                                                      "Military"
                                                  ? globalWidth * 0.18
                                                  : globalWidth * 0.15,
                                              padding: EdgeInsets.all(8),
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
                                                  "${studentProcedureListData[index].proceCountCode}",
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
                                            SizedBox(
                                              width: globalWidth * 0.03,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${studentProcedureListData[index].title}",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: "Poppins",
                                                        ),
                                                  ),
                                                  box
                                                              .get(Hardcoded
                                                                  .hiveBoxKey)!
                                                              .loggedUserSchoolType ==
                                                          "Advanced"
                                                      ? SizedBox()
                                                      : GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProcedureCountStepsScreen(
                                                                  procedureCountsCode:
                                                                      studentProcedureListData[
                                                                              index]
                                                                          .proceCountCode,
                                                                  procedureCountTopicId:
                                                                      studentProcedureListData[
                                                                              index]
                                                                          .pcTopicId,
                                                                  procedureCountName:
                                                                      studentProcedureListData[
                                                                              index]
                                                                          .title,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            height:
                                                                globalHeight *
                                                                    0.03,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 4,
                                                                    right: 20,
                                                                    bottom: 4),
                                                            color:
                                                                Colors.white12,
                                                            child: Text(
                                                              "View PEF activity",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline,
                                                                      color: Color(
                                                                          0xFF01A750)),
                                                            ),
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: globalWidth * 0.02,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateProcedureCountScreen(
                                                      studentProcedureListData:
                                                          studentProcedureListData
                                                              .elementAt(index),
                                                      procedureCount:
                                                          ProcedureCountStatus
                                                              .add,
                                                      rotationId:
                                                          widget.rotationId!,
                                                      isFromCheckoff:
                                                          widget.isFromCheckoff,
                                                      checkOffId:
                                                          widget.checkOffId,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: globalHeight * 0.04,
                                                padding: EdgeInsets.only(
                                                    top: 8,
                                                    left: 10,
                                                    right: 14,
                                                    bottom: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color:
                                                            Color(0xFF01A750))),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                          "assets/images/add1.svg"),
                                                      Text(
                                                        "Create",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!
                                                            .copyWith(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Poppins",
                                                                color: Color(
                                                                    0xFF01A750)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        thickness: 2,
                                        color: Color(0xFFDBDBDB),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
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
    );
  }
}
