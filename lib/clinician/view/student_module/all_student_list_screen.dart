import 'dart:developer';

import 'package:clinicaltrac/clinician/common_widgets/common_dropdown_widget.dart';
import 'package:clinicaltrac/clinician/common_widgets/common_profile_list_widget.dart';
import 'package:clinicaltrac/clinician/model/dropdown_models/rank_dropdown_list_model.dart';
import 'package:clinicaltrac/clinician/model/student_models/student_detail_list_model.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/clinician/view/login_screen/login_bottom_widget.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_expansion_comp_widget.dart';
import 'package:clinicaltrac/common/common_list_container_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class AllStudentListScreen extends StatefulWidget {
  const AllStudentListScreen({super.key});

  @override
  State<AllStudentListScreen> createState() => _AllStudentListScreenState();
}

class _AllStudentListScreenState extends State<AllStudentListScreen> {
  int pageNo = 1;
  int lastpage = 1;
  bool dataNotFound = false;

// is search button of appbar is click
  bool isSearchClicked = false;
  bool isDataLoaded = false;
  TextEditingController searchEditingController = TextEditingController();
  List<String> courseNameList = [];
  List<StudentDetailListData> studentDetailListData = [];
  List<RankDropdownData> rankDropdownList = <RankDropdownData>[];
  RankDropdownData selectedRankValue = new RankDropdownData();
  String selectedRank = '';
  String selectedRankId = '';
  String courseHintText = 'All';
  bool isResetCombo = false;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  RankDropdownListModel rankDropdownListData = RankDropdownListModel(data: []);
  Future<void> rankListData() async {
    UserDatRepo userDatRepo = UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    CommonRequest request = CommonRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      userType: AppConsts.userType,
    );
    return userDatRepo.rankDropdownList(request,
            (RankDropdownListModel rankDropdownListModel) {
          setState(() {
            rankDropdownList = rankDropdownListModel.data;
          });
          return null;
        }, () {}, context);
  }

  Future<void> getStudentDetailListData() async {
    UserDatRepo userDatRepo =  await UserDatRepo();

    if (pageNo == 1 || pageNo <= lastpage) {
      setState(() {
        isDataLoaded = true;
      });
      Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
      CommonRequest request = CommonRequest(
        accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
        userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        userType: AppConsts.userType,
        // userType: '1',
        roleType: box.get(Hardcoded.hiveBoxKey)!.loggedUserRoleType,
        pageNo: pageNo.toString(),
        RecordsPerPage: '10',
        SearchText: searchEditingController.text,
        rankId: selectedRankId,
        requestType: "student"
      );
      return userDatRepo.studentDetailList(request,
              (StudentDetailListModel studentDetailListModel) {
            lastpage =
                (int.parse(studentDetailListModel.pager!.totalRecords!) / 10).ceil();
            if (studentDetailListModel.pager!.totalRecords == '0') {
              setState(() {
                dataNotFound = false;
              });
            } else {
              setState(() {
                dataNotFound = true;
              });
            }
            setState(() {
              if (pageNo != 1) {
                studentDetailListData
                    .addAll(studentDetailListModel.data!);
                // rankListData();
              } else {
                studentDetailListData = studentDetailListModel.data!;
                // rankListData();
                // studentDetailListData = studentDetailListModel.data!;
              }
              isDataLoaded = false;
            });
          }, () {}, context);
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      pageNo += 1;

      getStudentDetailListData();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {
   getStudentDetailListData();
   rankListData();
   _scrollController.addListener(_scrollListener);
    super.initState();
    // rotationEvalList = widget.rotationListStudentJournal.data!;
  }

  Future<void> pullToRefresh() async {
    isDataLoaded = true;
    pageNo = 1;
    getStudentDetailListData();
    searchEditingController.text = '';
    isSearchClicked = false;
  }

  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // rankDropdownList;
    return Scaffold(
      appBar: CommonAppBar(
        isBackArrow: false,
        isCenterTitle: true,
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
                  pageNo = 1;
                  getStudentDetailListData();
                },
              ),
            ),
          ),
        )
            : Text("Students",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            )),
        searchEnabeled: true,
        onTap: () {
          Navigator.pop(context);
          // widget.route == DailyJournalRoute.rotation
          //     ?  Navigator.pop(context):  Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
          //     arguments: BodySwitcherData(
          //         initialPage: Bottom_navigation_control.home));
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
            // searchEditingController.text = '';
            FocusScope.of(context).unfocus();
            if (isSearchClicked == false && searchEditingController.text !='') { isDataLoaded = true;
            pageNo = 1;
            getStudentDetailListData();
            searchEditingController.text = '';
            }
          });
        },
      ),
      backgroundColor: Color(Hardcoded.white),
      body: Stack(
        children: [
          Padding(
            padding:
            EdgeInsets.only(top:globalHeight * 0.08
            ),
            child: Visibility(
              visible: isSearchClicked == false && isDataLoaded && pageNo == 1,
              child: common_loader(),
              replacement: Visibility(
                visible: !dataNotFound,
                child: isSearchClicked
                    ? Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Container(
                      // width: double.infinity,
                      //height: 100,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 0
                          ),
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
                              top: globalHeight * 0.01,
                              bottom: globalHeight * 0.1),
                          child: NoDataFoundWidget(
                            title: "Students not available",
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2, right: 2),
                        child: CupertinoScrollbar(
                          controller: _scrollController,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: studentDetailListData.length,
                              controller: _scrollController,
                              //scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CommonProfileListWidget(
                                  networkImage: studentDetailListData[index].profilePic,
                                  mainTitle: studentDetailListData[index].studentName,
                                  statusString: studentDetailListData[index].rank,
                                  subTitle1: "Email : ",
                                  title1: studentDetailListData[index].email!,
                                  subTitle3: "Phone : ",
                                  title3: studentDetailListData[index].phoneNo,
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),),
          Padding(
            padding: EdgeInsets.only(
                left: 17, right: 17),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ExpansionWidget<RankDropdownData>(
                    hintText:
                    selectedRankValue.title != "All" ? "All" : '',
                    // enabled: selectAllCourseTopic.toString().isEmpty
                    //     ? true
                    //     : false,
                    textColor: Colors.black,
                    OnSelection: (value) {
                      setState(() {
                        RankDropdownData c = value as RankDropdownData;
                        selectedRankValue = c;
                        // singleCourseTopicList.clear();
                        selectedRankId =
                            selectedRankValue.rankId.toString();
                        selectedRank =
                            selectedRankValue.title.toString();
                        pageNo = 1;
                        searchEditingController.text = '';
                        isSearchClicked = false;
                        getStudentDetailListData();
                      });
                      log("id---------${selectedRankValue.rankId}");
                    },
                    items: List.of(
                      rankDropdownList.map(
                            (item) {
                          String text = item.title.toString();
                          return DropdownItem<RankDropdownData>(
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
                                    text,
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
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding:  EdgeInsets.only(left: 2,top: 0.013.sh),
                //   child: Container(
                //     height: 0.07.sh,
                //     width: 0.08.sw,
                //     color: Colors.white,
                //     child: GestureDetector(
                //       onTap: (){
                //         DropDownState(
                //           DropDown(
                //             isDismissible: true,
                //             bottomSheetTitle: const Text(
                //               "Select Course",
                //               style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 20.0,
                //               ),
                //             ),
                //             submitButtonChild: const Text(
                //               'Done',
                //               style: TextStyle(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //             data: rankDropdownData ?? [],
                //             selectedItems: (List<dynamic> selectedList) {
                //               List<String> list = [];
                //               for (var item in selectedList) {
                //                 if (item is SelectedListItem) {
                //                   list.add(item.name);
                //                 }
                //               }
                //               log(list.toString());
                //             },
                //             // enableMultipleSelection: false,
                //           ),
                //         ).showModal(context);
                //       },
                //       child: SvgPicture.asset(
                //         'assets/images/filter.svg',
                //       ),
                //     ),
                //   ),
                // ),
              ],),
            // child: CommonExpansion(
            //   OnSelection: (String value) {
            //     setState(() {
            //       isResetCombo = false;
            //       courseHintText = value;
            //       isSearchClicked = false;
            //     });
            //     store.dispatch(
            //       FilterRotationListByCourseList(
            //           active_status:
            //               commonTypeList[_selectedIndex].type,
            //           courseId: getCourseIdByName(value),
            //           searchText: ''),
            //     );
            //     getRotationListData();
            //   },
            //   bodyList: courseNameList,
            //   trailIcon: "",
            //   hintText: courseHintText,
            //   isReset: isResetCombo,
            //   decoration: BoxDecoration(
            //     color: Color(Hardcoded.textFieldBg),
            //     borderRadius: BorderRadius.circular(12),
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
    );
  }
}
