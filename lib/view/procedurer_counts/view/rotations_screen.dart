import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/eaxpansion_component.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/course_list_model.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/action/rotations/set_course_list_action.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';

// import 'package:clinicaltrac/view/procedurer_counts/view/procedure_count_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/all_rotation_container.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/create_procedure_count_list_screen.dart';
import 'package:clinicaltrac/view/procedurer_counts/view/procedure_counts_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class ProcedureRotationsList extends StatefulWidget {
  ProcedureRotationsList({
    super.key,
    required this.allRotationListModel,
  });

  final AllRotationListModel allRotationListModel;

  @override
  State<ProcedureRotationsList> createState() => _ProcedureRotationsListState();
}

class _ProcedureRotationsListState extends State<ProcedureRotationsList> {
  // is search button of appbar is click
  bool isSearchClicked = false;

  TextEditingController searchTextController = TextEditingController();

  bool isResetCombo = false;

  int pageNo = 1;
  int lastpage = 1;
  bool datanotFound = false;
  List<AllRotation> allRotationList = [];
  bool isDataLoaded = true;

  void getAllRotationListData() async {
    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      final DataService dataService = locator();

      CommonRequest request = CommonRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        SearchText: searchTextController.text,
      );
      final DataResponseModel dataResponseModel =
          await dataService.getAllRotationList(request);
      AllRotationListModel allRotationListModel =
          AllRotationListModel.fromJson(dataResponseModel.data);
      lastpage =
          (int.parse(allRotationListModel.pager.totalRecords!) / 10).ceil();
      if (allRotationListModel.pager.totalRecords == '0') {
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
          allRotationList.addAll(allRotationListModel.data);
        } else {
          allRotationList = allRotationListModel.data;
        }
        isDataLoaded = false;
      });
    }
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;

      getAllRotationListData();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    store.dispatch(SetCourseListAction());
    getAllRotationListData();
    super.initState();
    // log("${widget.allRotationListModel.data}");
  }

  Future<void> pullToRefresh() async {
    store.dispatch(SetCourseListAction());
    isDataLoaded = true;
    pageNo = 1;
    getAllRotationListData();
    searchTextController.text = '';
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();
  List<Color> initialColor = [
    Color(Hardcoded.orange),
    Color(Hardcoded.blue),
    Color(Hardcoded.pink)
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(
          context,
          Routes.bodySwitcher,
          arguments:
              BodySwitcherData(initialPage: Bottom_navigation_control.home),
        );
        return Future.value();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
                          getAllRotationListData();
                        },
                      ),
                    ),
                  ),
                )
              : Text(
                  "Rotations",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                ),
          searchEnabeled: true,
          onTap: (){
            Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
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
              searchTextController.text = '';
              FocusScope.of(context).unfocus();
              if (isSearchClicked == false) getAllRotationListData();
            });
          },
        ),
        body: Visibility(
          visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
          child: Padding(
            padding: EdgeInsets.only(top: globalHeight * 0.03),
            child: common_loader(),
          ),
          replacement: Visibility(
            visible: !datanotFound,
            replacement: isSearchClicked
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: globalHeight * 0.0),
                      child: NoDataFoundWidget(
                        title: "No data found",
                        imagePath: "assets/no_data_found.png",
                      ),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: globalHeight * 0.0),
                      child: NoDataFoundWidget(
                        title: "Rotations not available",
                        imagePath: "assets/no_data_found.png",
                      ),
                    ),
                  ),
            child: GestureDetector(
              onTap: () {
                isResetCombo = false;
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
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
                            child: allRotationList.isEmpty
                                ? Center(
                                    child: NoDataFoundWidget(
                                      title: "Rotations not available",
                                      imagePath: "assets/no_data_found.png",
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 2, right: 2.0),
                                    child:CupertinoScrollbar(
                    controller: _scrollController,
                                      child: ListView.builder(
                                        itemCount: allRotationList.length,
                                        shrinkWrap: true,
                                        controller: _scrollController,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateProcedureCountListScreen(
                                                    allRotation: allRotationList
                                                        .elementAt(index),
                                                    rotationId: allRotationList
                                                        .elementAt(index)
                                                        .rotationId,
                                                  ),
                                                ),
                                              );
                                              // Navigator.of(context).push(
                                              //     MaterialPageRoute(
                                              //     builder: (context) =>
                                              //     ProcedureCountScreen(
                                              //   allRotation:
                                              //       allRotationList
                                              //           .elementAt(index),
                                              // ),
                                              //   ),
                                              // );
                                            },
                                            child: AllRotationContainer(
                                              duration: true,
                                              endDate: true,
                                              color: initialColor.elementAt(
                                                  index % initialColor.length),
                                              allRotation: allRotationList
                                                  .elementAt(index),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
