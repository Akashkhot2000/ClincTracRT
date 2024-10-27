import 'dart:developer';

import 'package:clinicaltrac/clinician/common_widgets/clinician_common_grid_widget.dart';
import 'package:clinicaltrac/clinician/common_widgets/rotation_container_widget.dart';
import 'package:clinicaltrac/clinician/model/clinician_rotation_list_model.dart';
import 'package:clinicaltrac/clinician/model/user_menu_add_remove_model.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/clinician/view/rotation_module/student_list_screen_from_rotation.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_change_hospitalsite_widget.dart';
import 'package:clinicaltrac/common/common_grid_component.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/no_data_found_widget.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/rotation_container.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/common_type_list_model.dart';
import 'package:clinicaltrac/redux/action/dr_interaction/get_dr_rotations_action.dart';
import 'package:clinicaltrac/redux/action/menuAddRemove_action.dart';
import 'package:clinicaltrac/redux/action/midterm_eval/midterm_eval_action.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';

class RotationDetailScreenWidget extends StatefulWidget {
  const RotationDetailScreenWidget(
      {super.key, required this.rotationListModel,required this.activeStatus});

  // final Rotation rotation;
  final ClinicianRotationDetailListData rotationListModel;
  final String activeStatus;

  @override
  State<RotationDetailScreenWidget> createState() => _RotationDetailScreenWidgetState();
}

class _RotationDetailScreenWidgetState extends State<RotationDetailScreenWidget> {
  List<Color> initialColor = [
    Color(Hardcoded.orange),
    Color(Hardcoded.blue),
    Color(Hardcoded.pink)
  ];
  int _selectedIndex = 0;
  List<String> gridTitleList = [];
  List<String> gridImagePathList = [];
  List<int> activeOptions = [];
  bool isDataLoaded = false;
  final PageController _pageController = PageController();
  TextEditingController searchEditingController = TextEditingController();
  bool isSearchClicked = false;
  String studentCount = "";
  List<CommonTypeListModel> commonTypeList = [
    CommonTypeListModel(
      type: "functions",
      typeName: "Functions",
    ),
    CommonTypeListModel(
      type: "students",
      typeName: "Students",
    ),
  ];

  UserMenuAddRemoveData userMenuAddRemoveData = UserMenuAddRemoveData();
  Box<UserLoginResponseHive>? box = Boxes.getUserInfo();

  Future<void> getUserMenuAddRemove() async {
    UserDatRepo userDatRepo = UserDatRepo();
    setState(() {
      isDataLoaded = true;
    });
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    CommonRequest request = CommonRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      userType: AppConsts.userType,
    );
    return userDatRepo.userMenuAddRemove(request,
            (UserMenuAddRemoveModel userMenuAddRemoveModel) {
          setState(() {
            userMenuAddRemoveData = userMenuAddRemoveModel.data!;
            loadGrid();
            isDataLoaded= false;
          });
          return null;
        }, () {}, context);
  }

  @override
  void initState() {
    super.initState();
    getUserMenuAddRemove();
  }

  void loadGrid() {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    setState(() {
      //-- Titles
      gridTitleList.clear();
      if (userMenuAddRemoveData.drInteraction == true) {
        gridTitleList.add("Dr. Interaction");
      }
      if (userMenuAddRemoveData.dailyJournal == true) {
        gridTitleList.add("Daily Journal");
      }
      if (userMenuAddRemoveData.formative == true) {
        gridTitleList.add("Formative");
      }
      if (userMenuAddRemoveData.dailyWeekly == true) {
        gridTitleList.add("Daily/Weekly");
      }
      if (userMenuAddRemoveData.midterm == true) {
        gridTitleList.add("Midterm");
      }
      if (userMenuAddRemoveData.summative == true) {
        gridTitleList.add("Summative");
      }
      if (userMenuAddRemoveData.masteryEvaluation ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Advanced")
          ? true
          : false) {
        gridTitleList.add("Mastery Evaluation");
      }
      if (userMenuAddRemoveData.cIEvaluation == true) {
        gridTitleList.add("CI Evaluation");
      }
      if (userMenuAddRemoveData.pEvaluation == true) {
        gridTitleList.add("P Evaluation");
      }
      if (userMenuAddRemoveData.siteEvaluation == true) {
        gridTitleList.add("Site Evaluation");
      }
      if (userMenuAddRemoveData.volunterEvaluation == true) {
        gridTitleList.add("Volunteer Evaluation");
      }
      if (userMenuAddRemoveData.exception == true) {
        gridTitleList.add("Exception");
      }
      // if (userMenuAddRemoveData.floorTherapyAndICU == true) {
      // if (userMenuAddRemoveData.floorTherapyAndICU == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Advanced") ? true : true) {
      if (userMenuAddRemoveData.floorTherapyAndICU ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Standard")
          ? true
          : false) {
        gridTitleList.add("Floor Therapy And ICU Evaluation");
      }
      // if (userMenuAddRemoveData.pEFEvaluation == true) {
      // if (userMenuAddRemoveData.pEFEvaluation == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Standard") ? true : true) {
      if (userMenuAddRemoveData.pEFEvaluation ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Standard")
          ? true
          : false) {
        gridTitleList.add("PEF Evaluation");
      }
      if (userMenuAddRemoveData.equipmentList == true) {
        gridTitleList.add("Equipment List");
      }
      if (userMenuAddRemoveData.incident == true) {
        gridTitleList.add("Incident");
      }
      // if (widget.rotationListModel.isSchedule! == "1" && widget.activeStatus == "active") {
      //   gridTitleList.add("Change Hospital Site");
      // }

      //-----
      gridImagePathList.clear();
      if (userMenuAddRemoveData.drInteraction == true) {
        gridImagePathList.add("assets/images/dr_interaction.svg");
      }
      if (userMenuAddRemoveData.dailyJournal == true) {
        gridImagePathList.add("assets/images/daily_journal.svg");
      }
      if (userMenuAddRemoveData.formative == true) {
        gridImagePathList.add("assets/images/formative.svg");
      }
      if (userMenuAddRemoveData.dailyWeekly == true) {
        gridImagePathList.add("assets/images/daily_weekly.svg");
      }
      if (userMenuAddRemoveData.midterm == true) {
        gridImagePathList.add("assets/images/mid_term.svg");
      }
      if (userMenuAddRemoveData.summative == true) {
        gridImagePathList.add("assets/images/summative.svg");
      }
      if (userMenuAddRemoveData.masteryEvaluation ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Advanced")
          ? true
          : false) {
        gridImagePathList.add("assets/images/mastery_eval.svg");
      }
      if (userMenuAddRemoveData.cIEvaluation == true) {
        gridImagePathList.add("assets/images/ci_eval.svg");
      }
      if (userMenuAddRemoveData.pEvaluation == true) {
        gridImagePathList.add("assets/images/p_evaluation.svg");
      }
      if (userMenuAddRemoveData.siteEvaluation == true) {
        gridImagePathList.add("assets/images/site_evaluation.svg");
      }
      if (userMenuAddRemoveData.volunterEvaluation == true) {
        gridImagePathList.add("assets/images/volunteer_eva.svg");
      }
      if (userMenuAddRemoveData.exception == true) {
        gridImagePathList.add("assets/images/exception1.svg");
      }
      // if (userMenuAddRemoveData.floorTherapyAndICU == true) {
      // if (userMenuAddRemoveData.floorTherapyAndICU == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Advanced") ? true : true) {
      if (userMenuAddRemoveData.floorTherapyAndICU ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Standard")
          ? true
          : false) {
        gridImagePathList.add("assets/images/icu.svg");
      }
      // if (userMenuAddRemoveData.pEFEvaluation == true) {
      // if (userMenuAddRemoveData.pEFEvaluation == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Standard") ? true : true) {
      if (userMenuAddRemoveData.pEFEvaluation ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Standard")
          ? true
          : false) {
        gridImagePathList.add("assets/images/pef_evaluation.svg");
      }
      if (userMenuAddRemoveData.equipmentList == true) {
        gridImagePathList.add("assets/images/equipment.svg");
      }
      if (userMenuAddRemoveData.incident == true) {
        gridImagePathList.add("assets/images/incident1.svg");
      }
      // if (widget.rotation.isSchedule == "1" && widget.activeStatus == "active") {
      //   gridImagePathList.add("assets/images/case_study.svg");
      // }

      ////
      activeOptions.clear();
      if (userMenuAddRemoveData.drInteraction == true) {
        //activeOptions.add("attendance");
        activeOptions.add(0);
      }
      if (userMenuAddRemoveData.dailyJournal == true) {
        //activeOptions.add("caseStudy");
        activeOptions.add(1);
      }
      if (userMenuAddRemoveData.formative == true) {
        //activeOptions.add("incident");
        activeOptions.add(2);
      }
      if (userMenuAddRemoveData.dailyWeekly == true) {
        //activeOptions.add("briefcase");
        activeOptions.add(3);
      }
      if (userMenuAddRemoveData.midterm == true) {
        //activeOptions.add("exception");
        activeOptions.add(4);
      }
      if (userMenuAddRemoveData.summative == true) {
        activeOptions.add(5);
      }
      if (userMenuAddRemoveData.masteryEvaluation ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Advanced")
          ? true
          : false) {
        activeOptions.add(6);
      }
      if (userMenuAddRemoveData.cIEvaluation == true) {
        activeOptions.add(7);
      }
      if (userMenuAddRemoveData.pEvaluation == true) {
        activeOptions.add(8);
      }
      if (userMenuAddRemoveData.siteEvaluation == true) {
        activeOptions.add(9);
      }
      if (userMenuAddRemoveData.volunterEvaluation == true) {
        activeOptions.add(10);
      }
      if (userMenuAddRemoveData.exception == true) {
        activeOptions.add(11);
      }
      // if (userMenuAddRemoveData.floorTherapyAndICU == true) {
      // if (userMenuAddRemoveData.floorTherapyAndICU == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Advanced") ? true : true) {
      if (userMenuAddRemoveData.floorTherapyAndICU ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Standard")
          ? true
          : false) {
        activeOptions.add(12);
      }
      // if (userMenuAddRemoveData.pEFEvaluation == true) {
      // if (userMenuAddRemoveData.pEFEvaluation == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Standard") ? true : true) {
      if (userMenuAddRemoveData.pEFEvaluation ==
          (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
              "Standard")
          ? true
          : false) {
        activeOptions.add(13);
      }
      if (userMenuAddRemoveData.equipmentList == true) {
        activeOptions.add(14);
      }
      if (userMenuAddRemoveData.incident == true) {
        activeOptions.add(15);
      }
      // if (widget.rotation.isSchedule == "1" && widget.activeStatus == "active") {
      //   activeOptions.add(16);
      // }
    });
  }

  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: CommonAppBar(
         appBarColor: Colors.white,
         isBackArrow: true,
         isCenterTitle: true,
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
                 textEditingController: searchEditingController,
                 onChanged: (value) {

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
         searchEnabeled:   _selectedIndex == 1? false : false,
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
             searchEditingController.text = '';
             FocusScope.of(context).unfocus();
             // if (isSearchClicked == false) getClinicianRotationList();
           });
         },
         onTap: () {
           Navigator.pushReplacementNamed(
             context,
             Routes.bodySwitcher,
             arguments:
             BodySwitcherData(initialPage: Bottom_navigation_control.home),
           );
         },
       ),
      // appBar: CommonAppBar(
      //   title: 'Rotation Details',
      //   onTap: () {
      //     // Navigator.pop(context);
      //     Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
      //         arguments: BodySwitcherData(
      //           initialPage: Bottom_navigation_control.rotation,
      //         ));
      //   },
      // ),
      body: NoInternet(
        child:
        Column(
          children: [
                  RotationContainerWidget(
                    activeStatus: Active_status.active,
                    showClockIn: false,
                    duration: true,
                    endDate: true,
                    color: initialColor.elementAt(1),
                    clinicianRotationDetailListData: widget.rotationListModel,
                  ),
                  SizedBox(
                    height: 5,
                  ),
            Container(
              // color: Colors.green,
              height: globalHeight * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: commonTypeList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      // searchEditingController.text = '';
                      // pageNo = 1;
                      // getClinicianRotationList();
                      // isSearchClicked = false;
                    },
                    child: Container(
                      height: globalHeight * 1,
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
                          // left: globalWidth * 0.10,
                          // right: globalWidth * 0.2,
                          // left: globalWidth * 0.06, right: globalWidth * 0.06,
                        ),
                        child: Container(
                          height: globalHeight * 0.1,
                          width: globalWidth * 0.5,
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: globalHeight * 0.001,
                                  ),
                                  child: Text(
                                    commonTypeList[index]
                                        .type == "students" ? "Student (${widget.rotationListModel.studentCount})" : "Functions",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      // letterSpacing: 1,
                                      fontSize: 16,
                                      color:
                                      index == _selectedIndex
                                          ? Color(Hardcoded
                                          .primaryGreen)
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
            SizedBox(
              height: globalHeight * 0.015,
            ),
            Expanded(
              child: Visibility(
                visible:
                isDataLoaded ,
                child:
                Padding(
                  padding: EdgeInsets.only(bottom: 0.2.sh),
                  child: common_loader(),
                ),
                replacement:
                 _selectedIndex == 0?
                 ClinicianCommonGridWidget(
               gridImagePathList: gridImagePathList,
               gridTitleList: gridTitleList,
               activeOptions: activeOptions,
               rotationDetailListData: widget.rotationListModel,
       ):StudentListScreenFromRotation(rotationId: widget.rotationListModel.rotationId!,searchText: searchEditingController.text,isSearchClicked: isSearchClicked,)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
