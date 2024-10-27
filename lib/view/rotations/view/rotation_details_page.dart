import 'dart:developer';

import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_change_hospitalsite_widget.dart';
import 'package:clinicaltrac/common/common_grid_component.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/rotation_container.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/redux/action/dr_interaction/get_dr_rotations_action.dart';
import 'package:clinicaltrac/redux/action/menuAddRemove_action.dart';
import 'package:clinicaltrac/redux/action/midterm_eval/midterm_eval_action.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RotationDetailsPage extends StatefulWidget {
  const RotationDetailsPage(
      {super.key, required this.rotation, required this.rotationListModel,required this.activeStatus});

  final Rotation rotation;
  final RotationListModel rotationListModel;
  final String activeStatus;

  @override
  State<RotationDetailsPage> createState() => _RotationDetailsPageState();
}

class _RotationDetailsPageState extends State<RotationDetailsPage> {
  List<Color> initialColor = [
    Color(Hardcoded.orange),
    Color(Hardcoded.blue),
    Color(Hardcoded.pink)
  ];
  List<String> gridTitleList = [];
  List<String> gridImagePathList = [];
  List<int> activeOptions = [];
  Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
  @override
  void initState() {
    super.initState();
    store.dispatch(getMidtermEvalListAction(
        rotationId: widget.rotation.rotationId,
        pageNo: 1,
        searchTexteNo: '',
        RecordsPerPage: '10'));
    store.dispatch(getDrInteractions(
        searchText: '', rotationId: widget.rotation.rotationId, page: 1));
    store.dispatch(getMenuAddRemoveAction(), notify: true);
    loadGrid();
    // log("${widget.rotation.isSchedule}");
  }

  void loadGrid() {
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    setState(() {
      //-- Titles
      gridTitleList.clear();
      if (store.state.menuAddRemoveModel.data.drInteraction == true) {
        gridTitleList.add("Dr. Interaction");
      }
      if (store.state.menuAddRemoveModel.data.dailyJournal == true) {
        gridTitleList.add("Daily Journal");
      }
      if (store.state.menuAddRemoveModel.data.formative == true) {
        gridTitleList.add("Formative");
      }
      if (store.state.menuAddRemoveModel.data.dailyWeekly == true) {
        gridTitleList.add("Daily/Weekly");
      }
      if (store.state.menuAddRemoveModel.data.midterm == true) {
        gridTitleList.add("Midterm");
      }
      if (store.state.menuAddRemoveModel.data.summative == true) {
        gridTitleList.add("Summative");
      }
      if (store.state.menuAddRemoveModel.data.masteryEvaluation ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Advanced")
          ? true
          : false) {
        gridTitleList.add("Mastery Evaluation");
      }
      if (store.state.menuAddRemoveModel.data.cIEvaluation == true) {
        gridTitleList.add("CI Evaluation");
      }
      if (store.state.menuAddRemoveModel.data.pEvaluation == true) {
        gridTitleList.add("P Evaluation");
      }
      if (store.state.menuAddRemoveModel.data.siteEvaluation == true) {
        gridTitleList.add("Site Evaluation");
      }
      if (store.state.menuAddRemoveModel.data.volunterEvaluation == true) {
        gridTitleList.add("Volunteer Evaluation");
      }
      if (store.state.menuAddRemoveModel.data.exception == true) {
        gridTitleList.add("Exception");
      }
      // if (store.state.menuAddRemoveModel.data.floorTherapyAndICU == true) {
      // if (store.state.menuAddRemoveModel.data.floorTherapyAndICU == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Advanced") ? true : true) {
      if (store.state.menuAddRemoveModel.data.floorTherapyAndICU ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Standard")
          ? true
          : false) {
        gridTitleList.add("Floor Therapy And ICU Evaluation");
      }
      // if (store.state.menuAddRemoveModel.data.pEFEvaluation == true) {
      // if (store.state.menuAddRemoveModel.data.pEFEvaluation == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Standard") ? true : true) {
      if (store.state.menuAddRemoveModel.data.pEFEvaluation ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Standard")
          ? true
          : false) {
        gridTitleList.add("PEF Evaluation");
      }
      if (store.state.menuAddRemoveModel.data.equipmentList == true) {
        gridTitleList.add("Equipment List");
      }
      if (store.state.menuAddRemoveModel.data.incident == true) {
        gridTitleList.add("Incident");
      }
      if (widget.rotation.isSchedule == "1" && widget.activeStatus == "active") {
        gridTitleList.add("Change Hospital Site");
      }

      //-----
      gridImagePathList.clear();
      if (store.state.menuAddRemoveModel.data.drInteraction == true) {
        gridImagePathList.add("assets/images/dr_interaction.svg");
      }
      if (store.state.menuAddRemoveModel.data.dailyJournal == true) {
        gridImagePathList.add("assets/images/daily_journal.svg");
      }
      if (store.state.menuAddRemoveModel.data.formative == true) {
        gridImagePathList.add("assets/images/formative.svg");
      }
      if (store.state.menuAddRemoveModel.data.dailyWeekly == true) {
        gridImagePathList.add("assets/images/daily_weekly.svg");
      }
      if (store.state.menuAddRemoveModel.data.midterm == true) {
        gridImagePathList.add("assets/images/mid_term.svg");
      }
      if (store.state.menuAddRemoveModel.data.summative == true) {
        gridImagePathList.add("assets/images/summative.svg");
      }
      if (store.state.menuAddRemoveModel.data.masteryEvaluation ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Advanced")
          ? true
          : false) {
        gridImagePathList.add("assets/images/mastery_eval.svg");
      }
      if (store.state.menuAddRemoveModel.data.cIEvaluation == true) {
        gridImagePathList.add("assets/images/ci_eval.svg");
      }
      if (store.state.menuAddRemoveModel.data.pEvaluation == true) {
        gridImagePathList.add("assets/images/p_evaluation.svg");
      }
      if (store.state.menuAddRemoveModel.data.siteEvaluation == true) {
        gridImagePathList.add("assets/images/site_evaluation.svg");
      }
      if (store.state.menuAddRemoveModel.data.volunterEvaluation == true) {
        gridImagePathList.add("assets/images/volunteer_eva.svg");
      }
      if (store.state.menuAddRemoveModel.data.exception == true) {
        gridImagePathList.add("assets/images/exception1.svg");
      }
      // if (store.state.menuAddRemoveModel.data.floorTherapyAndICU == true) {
      // if (store.state.menuAddRemoveModel.data.floorTherapyAndICU == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Advanced") ? true : true) {
      if (store.state.menuAddRemoveModel.data.floorTherapyAndICU ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Standard")
          ? true
          : false) {
        gridImagePathList.add("assets/images/icu.svg");
      }
      // if (store.state.menuAddRemoveModel.data.pEFEvaluation == true) {
      // if (store.state.menuAddRemoveModel.data.pEFEvaluation == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Standard") ? true : true) {
      if (store.state.menuAddRemoveModel.data.pEFEvaluation ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Standard")
          ? true
          : false) {
        gridImagePathList.add("assets/images/pef_evaluation.svg");
      }
      if (store.state.menuAddRemoveModel.data.equipmentList == true) {
        gridImagePathList.add("assets/images/equipment.svg");
      }
      if (store.state.menuAddRemoveModel.data.incident == true) {
        gridImagePathList.add("assets/images/incident1.svg");
      }
      if (widget.rotation.isSchedule == "1" && widget.activeStatus == "active") {
        gridImagePathList.add("assets/images/case_study.svg");
      }

      ////
      activeOptions.clear();
      if (store.state.menuAddRemoveModel.data.drInteraction == true) {
        //activeOptions.add("attendance");
        activeOptions.add(0);
      }
      if (store.state.menuAddRemoveModel.data.dailyJournal == true) {
        //activeOptions.add("caseStudy");
        activeOptions.add(1);
      }
      if (store.state.menuAddRemoveModel.data.formative == true) {
        //activeOptions.add("incident");
        activeOptions.add(2);
      }
      if (store.state.menuAddRemoveModel.data.dailyWeekly == true) {
        //activeOptions.add("briefcase");
        activeOptions.add(3);
      }
      if (store.state.menuAddRemoveModel.data.midterm == true) {
        //activeOptions.add("exception");
        activeOptions.add(4);
      }
      if (store.state.menuAddRemoveModel.data.summative == true) {
        activeOptions.add(5);
      }
      if (store.state.menuAddRemoveModel.data.masteryEvaluation ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Advanced")
          ? true
          : false) {
        activeOptions.add(6);
      }
      if (store.state.menuAddRemoveModel.data.cIEvaluation == true) {
        activeOptions.add(7);
      }
      if (store.state.menuAddRemoveModel.data.pEvaluation == true) {
        activeOptions.add(8);
      }
      if (store.state.menuAddRemoveModel.data.siteEvaluation == true) {
        activeOptions.add(9);
      }
      if (store.state.menuAddRemoveModel.data.volunterEvaluation == true) {
        activeOptions.add(10);
      }
      if (store.state.menuAddRemoveModel.data.exception == true) {
        activeOptions.add(11);
      }
      // if (store.state.menuAddRemoveModel.data.floorTherapyAndICU == true) {
      // if (store.state.menuAddRemoveModel.data.floorTherapyAndICU == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Advanced") ? true : true) {
      if (store.state.menuAddRemoveModel.data.floorTherapyAndICU ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Standard")
          ? true
          : false) {
        activeOptions.add(12);
      }
      // if (store.state.menuAddRemoveModel.data.pEFEvaluation == true) {
      // if (store.state.menuAddRemoveModel.data.pEFEvaluation == (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType == "Standard") ? true : true) {
      if (store.state.menuAddRemoveModel.data.pEFEvaluation ==
              (box.get(Hardcoded.hiveBoxKey)!.loggedUserSchoolType ==
                  "Standard")
          ? true
          : false) {
        activeOptions.add(13);
      }
      if (store.state.menuAddRemoveModel.data.equipmentList == true) {
        activeOptions.add(14);
      }
      if (store.state.menuAddRemoveModel.data.incident == true) {
        activeOptions.add(15);
      }
      if (widget.rotation.isSchedule == "1" && widget.activeStatus == "active") {
        activeOptions.add(16);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<String> gridTitleList = [
    //   "Dr. Interaction",
    //   "Daily Journal",
    //   "Formative",
    //   "Daily/Weekly",
    //   "Midterm",
    //   "Summative",
    //   "Mastery Evaluation",
    //   "CI Evaluation",
    //   "P Evaluation",
    //   "Site Evaluation",
    //   "Volunteer Evaluation",
    //   "Exception",
    //   "Floor Therapy And ICU Evaluation",
    //   "PEF Evaluation",
    //   "Equipment List"
    // ];

    // List<String> gridImagePathList = [
    //   "assets/images/dr_interaction.svg",
    //   "assets/images/daily_journal.svg",
    //   "assets/images/formative.svg",
    //   "assets/images/daily_weekly.svg",
    //   "assets/images/mid_term.svg",
    //   "assets/images/summative.svg",
    //   "assets/images/mastery_eval.svg",
    //   "assets/images/ci_eval.svg",
    //   "assets/images/p_evaluation.svg",
    //   "assets/images/site_evaluation.svg",
    //   "assets/images/volunteer_eva.svg",
    //   "assets/images/exception1.svg",
    //   "assets/images/icu.svg",
    //   "assets/images/pef_evaluation.svg",
    //   "assets/images/equipment.svg",
    // ];
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Rotation Details',
        onTap: () {
          // Navigator.pop(context);
          Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
              arguments: BodySwitcherData(
                initialPage: Bottom_navigation_control.rotation,
              ));
        },
      ),
      body: NoInternet(
        child: ListView(
          // physics: NeverScrollableScrollPhysics(),
          children: [
            RotationContainer(
              pendingRotationList: [],
              activeStatus: Active_status.active,
              showClockIn: false,
              duration: true,
              endDate: true,
              color: initialColor.elementAt(1),
              rotation: widget.rotation,
              rotationListModel: widget.rotationListModel,
            ),
            SizedBox(
              height: 10,
            ),
            CommonGridComponent(
              gridImagePathList: gridImagePathList,
              gridTitleList: gridTitleList,
              activeOptions: activeOptions,
              rotation: widget.rotation,
              // onTapSendMail: (){ GestureDetector(
              //      onTap:(){showModalBottomSheet<void>(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.vertical(
              //         top: Radius.circular(30.0),
              //       ),
              //     ),
              //     context: context,
              //     isScrollControlled: true,
              //     builder: (BuildContext context) {
              //       return ChangeHospitalSiteBottomSheet(
              //         userId: box!
              //             .get(Hardcoded.hiveBoxKey)!
              //             .loggedUserId,
              //         accessToken: box!
              //             .get(Hardcoded.hiveBoxKey)!
              //             .accessToken,
              //         rotationId:
              //         widget.rotation.rotationId,
              //         // preceptorId: widget.rotation.,
              //         isClockIn:  widget.rotation.isClockIn,
              //         hospitalSiteId: widget.rotation.rotationId,
              //         hospitalSiteTitle: widget.rotation.hospitalTitle,
              //       );
              //     },
              //   );});}
            ),
            // const SizedBox(
            //   height: 20,
            // ),
          ],
        ),
      ),
    );
  }
}
