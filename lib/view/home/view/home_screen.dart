// ignore_for_file: non_constant_identifier_names, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:app_version_update/app_version_update.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/App_Version_Update/app_version_update.dart';
import 'package:clinicaltrac/common/coming_soon_screen_widget.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/gps_common_widget.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/menu_add_remove_model.dart';
import 'package:clinicaltrac/redux/action/dr_interaction/get_dr_rotations_action.dart';
import 'package:clinicaltrac/redux/action/get_student_details.dart';
import 'package:clinicaltrac/redux/action/homeactions/get_stud_dashboard_data_action.dart';
import 'package:clinicaltrac/redux/action/initializeAction.dart';
import 'package:clinicaltrac/redux/action/menuAddRemove_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_rotation_list_action.dart';
import 'package:clinicaltrac/redux/typedef/typdef.dart';
import 'package:clinicaltrac/view/brief_case/vm_connector/brief_case_vm_connector.dart';
import 'package:clinicaltrac/view/check_offs/vm_connector/checkoffs_connector.dart';
import 'package:clinicaltrac/view/daily_journal/vm_connector/daily_journal_vm_connector.dart';
import 'package:clinicaltrac/view/daily_weekly/vm_connector/daily_weekly_vm_connector.dart';
import 'package:clinicaltrac/view/dr_intraction/vm_conector/dr_interaction_vm_conector.dart';
import 'package:clinicaltrac/view/home/model/home_grid_data.dart';
import 'package:clinicaltrac/view/home/model/menu_add_remove_request.dart';
import 'package:clinicaltrac/view/home/model/stud_active_rotation.dart';
import 'package:clinicaltrac/view/home/model/stud_dashboard_model.dart';
import 'package:clinicaltrac/view/home/vm_conector/studactiverotation_vm_connector.dart';
import 'package:clinicaltrac/view/incident/vm_connector/incident_vm_connector.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/profile/model/get_student_detailss_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.pageChange,
    required this.userLoginResponse,
    required this.activeRotationListModel,
    required this.studDashboardModel,
    required this.studentDetailsResponse,
    required this.menuAddRemoveModelData,
  }) : super(key: key);

  /// page change callback
  final ChangeScreen pageChange;

  ///userLoginResponse
  final UserLoginResponse userLoginResponse;

  final ActiveRotationListModel activeRotationListModel;
  final StudDashboardModel studDashboardModel;
  final StudentDetailsResponse studentDetailsResponse;
  final MenuAddRemoveModel menuAddRemoveModelData;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String status = 'Clock In';
  List<String> gridTitleList = [];
  List<GridData> gridDataList = [];
  List<String> gridImagePathList = [];
  List<int> activeOptions = [];

  void getGridData() {
    for (var element in gridData) {
      final GridData gridData = GridData.fromJson(element);
      gridDataList.add(gridData);
    }
    //getMenuAddRemoveData();
     loadGrid();
  }

  bool loading = true;

  void startTimer() {
    setState(() {
      loading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
    if(mounted){  setState(() {
        loading = false;
        loadGrid();
      });
    }});
  }

  bool isDataLoading = true;

  @override
  void initState() {
    // _checkAppUpdate();
    store.dispatch(SetRotationsListAction(active_status: Active_status.active));
    store.dispatch(GetStudDashBoardAction());
    store.dispatch(getDrInteractions(
      page: 1,
      searchText: '',
      rotationId: '0',
    ));
    startTimer();

    super.initState();
    store.dispatch(getStudentDetailsAction());
    store.dispatch(getMenuAddRemoveAction(),notify: true);
    // print(store.state.menuAddRemoveModel.data.attendance);
    getGridData();
   // widget.menuAddRemoveModelData.data = store.state.menuAddRemoveModel.data;
  }

  void _checkAppUpdate() async {
    final appleId =
        '6450888634'; // If this value is null, its packagename will be considered
    final playStoreId =
        'com.clinicaltrac.app'; // If this value is null, its packagename will be considered
    final country =
        'us'; // If this value is null 'us' will be the default value
    AppVersionUpdate.checkForUpdates(
        appleId: appleId, playStoreId: playStoreId, country: country)
        .then((data) async {
      if (data.canUpdate!) {
        print(data.storeUrl);
        print(data.storeVersion);
        print("canUpdate${data.canUpdate}");

        CTAppVersionUpdate.showAlertUpdate(
            context: context,
            appVersionResult: data,
            title: 'New version available',
            mandatory: true,
            titleTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 20.0, fontWeight: FontWeight.w600),
            content: 'Please update your application',
            contentTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16.0, fontWeight: FontWeight.w400),
            cancelButtonStyle: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.grey)),
            updateButtonStyle: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFF01A750))),
            // cancelButtonText: 'UPDATE LATER',
            updateButtonText: 'UPDATE',
            cancelTextStyle: TextStyle(color: Colors.white),
            updateTextStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.white);
      }
    });
  }

  /*void getMenuAddRemoveData() {
    setState(() {
      isDataLoading = true;
      widget.menuAddRemoveModelData.data = store.state.menuAddRemoveModel.data;
      loadGrid();
    });

    // log("${dataResponseModel.data}");
  }*/

  List<Map<String, String>> gridData = [
    {
      'color': 'Hardcoded.lightBlue',
      'icon_path': 'assets/images/daily_jour.png',
      'title': 'Daily Journals'
    },
    {
      'color': 'Hardcoded.lightPurple',
      'icon_path': 'assets/images/proce_count.svg',
      'title': 'Procedure Counts'
    },
    {
      'color': 'Hardcoded.lightOrange',
      'icon_path': 'assets/images/dr_int.png',
      'title': 'Dr. Interaction'
    },
    {
      'color': 'Hardcoded.lightPink',
      'icon_path': 'assets/images/pef_checkoff.svg',
      'title': 'PEF Checkoffs'
    }
  ];

  void loadGrid() {
    setState(() {
      isDataLoading = true;
      //-- Titles
      gridTitleList.clear();
      if (store.state.menuAddRemoveModel.data.attendance == true) {
        gridTitleList.add("Attendance");
      } if (store.state.menuAddRemoveModel.data.caseStudy == true) {
        gridTitleList.add("Case Study");
      } if (store.state.menuAddRemoveModel.data.dailyWeekly == true) {
        gridTitleList.add("Daily/Weekly");
      // } if (store.state.menuAddRemoveModel.data.incident == true) {
      //   gridTitleList.add("Incident");
      } if (store.state.menuAddRemoveModel.data.briefcase == true) {
        gridTitleList.add("Briefcase");
      } if (store.state.menuAddRemoveModel.data.exception == true) {
        gridTitleList.add("Exception");
      } if (store.state.menuAddRemoveModel.data.medicalTerminology ==
          true) {
        gridTitleList.add("Medical Terminology");
      }
      //-----
      gridImagePathList.clear();
      if (store.state.menuAddRemoveModel.data.attendance == true) {
        gridImagePathList.add("assets/images/attendence1.svg");
      } if (store.state.menuAddRemoveModel.data.caseStudy == true) {
        gridImagePathList.add("assets/images/case_study.svg");
      } if (store.state.menuAddRemoveModel.data.dailyWeekly == true) {
        gridImagePathList.add("assets/images/daily_weekly1.svg");
      // } if (store.state.menuAddRemoveModel.data.incident == true) {
      //   gridImagePathList.add("assets/images/incident1.svg");
      } if (store.state.menuAddRemoveModel.data.briefcase == true) {
        gridImagePathList.add("assets/images/brif_case1.svg");
      } if (store.state.menuAddRemoveModel.data.exception == true) {
        gridImagePathList.add("assets/images/exceptions1.svg");
      } if (store.state.menuAddRemoveModel.data.medicalTerminology ==
          true) {
        gridImagePathList.add("assets/images/medical_term1.svg");
      }

      ////
      activeOptions.clear();
      if (store.state.menuAddRemoveModel.data.attendance == true) {
        //activeOptions.add("attendance");
        activeOptions.add(0);
      } if (store.state.menuAddRemoveModel.data.caseStudy == true) {
        //activeOptions.add("caseStudy");
        activeOptions.add(1);
      } if (store.state.menuAddRemoveModel.data.dailyWeekly == true) {
      // } if (store.state.menuAddRemoveModel.data.incident == true) {
        //activeOptions.add("incident");
        activeOptions.add(2);
      } if (store.state.menuAddRemoveModel.data.briefcase == true) {
        //activeOptions.add("briefcase");
        activeOptions.add(3);
      } if (store.state.menuAddRemoveModel.data.exception == true) {
        //activeOptions.add("exception");
        activeOptions.add(4);
      } if (store.state.menuAddRemoveModel.data.medicalTerminology ==
          true) {
        //activeOptions.add("medicalTerminology");
        activeOptions.add(5);
      }
    });
  }

  // void getGridData() {
  //   for (var element in gridData) {
  //     final GridData gridData = GridData.fromJson(element);
  //     gridDataList.add(gridData);
  //   }
  // }
  //
  // @override
  // void initState() {
  //   store.dispatch(GetStudDashboardDataAction());
  //   super.initState();
  //   getGridData();
  // }

  // List<String> gridTitleList = [
  //
  // ];

  // List<String> gridImagePathList = [
  //   "assets/images/attendence1.svg",
  //   "assets/images/case_study.svg",
  //   "assets/images/incident1.svg",
  //   "assets/images/brif_case1.svg",
  //   "assets/images/exceptions1.svg",
  //   "assets/images/medical_term1.svg",
  // ];

  @override
  Widget build(BuildContext context) {
    return
        // Visibility(visible: !isDataLoading,
        //   replacement: common_loader(), child:
        loading == true
            ? NoInternet(child: common_loader())
            : NoInternet(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: REdgeInsets.only(
                            left: 17, top: 10, bottom: 15, right: 10),
                        child: Row(
                          children: [
                            store
                                    .state
                                    .studDashboardModel
                                    .data
                                    .loggedUserDetails
                                    .loggedUserSchoolImagePath
                                    .isEmpty
                                ? Container()
                                : FadeInImage(
                                    // fit: BoxFit.cover,
                                    height: 50.h,
                                    width: 90.w,
                                    placeholder: AssetImage(
                                      'assets/images/defaultschoolimg.png',
                                    ),
                                    image: NetworkImage(
                                      store
                                          .state
                                          .studDashboardModel
                                          .data
                                          .loggedUserDetails
                                          .loggedUserSchoolImagePath,
                                    ),
                                  ),
                            // Image.network(
                            //   store.state.studDashboardModel.data.loggedUserDetails.loggedUserSchoolImagePath,
                            //   height: 40,
                            //   width: 90,
                            // ),
                             SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Padding(
                                padding: REdgeInsets.only(right: 2).r,
                                child: Text(
                                  ' ${store.state.studDashboardModel.data.loggedUserDetails.loggedUserSchoolName}',
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15.sp,
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            REdgeInsets.only(right: 20, left: 20, top: 5).r,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ///Slider
                              StudActiveRotationListScreenConector(),
                              SizedBox(
                                height: 0.02.sh,
                              ),

                              /// Middle grid
                              GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 2.1,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: gridDataList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {

                                        switch (index) {
                                          case 0:
                                            Navigator.pushNamed(context,
                                                Routes.dailyJournalScreen,
                                                arguments: DailyRoutingData(
                                                    route: DailyJournalRoute.direct));
                                            break;
                                          case 1:
                                            Navigator.pushNamed(
                                                context,
                                                Routes
                                                    .procedureRotationListScreen
                                                // Routes.procedureCountScreen,
                                                );
                                            break;

                                          case 2:
                                            Navigator.pushNamed(context,
                                                Routes.drInteractionListScreen,
                                                arguments:
                                                    DrInteractionListScreenDta(
                                                        showAdd: false));
                                            break;
                                          case 3:
                                            Navigator.pushNamed(context,
                                                Routes.checkoffsListScreen,
                                                arguments: CheckoffsDta(
                                                    showAdd: false,
                                                    route: DailyJournalRoute
                                                        .direct));
                                            break;
                                        }
                                      },
                                      child: GridComponent(
                                          gridDataList[index].color,
                                          index == 0
                                              ? widget.studDashboardModel.data
                                                  .journalCount
                                              : index == 1
                                                  ? widget.studDashboardModel
                                                      .data.procedureCount
                                                  : index == 2
                                                      ? widget
                                                          .studDashboardModel
                                                          .data
                                                          .interactionCount
                                                      : widget
                                                          .studDashboardModel
                                                          .data
                                                          .checkoffCount,
                                          gridDataList[index].iconPath,
                                          gridDataList[index].title),
                                    );
                                  }),
                              SizedBox(
                                height: 0.026.sh,
                              ),

                              /// Bottom grid
                              GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                     SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 1,
                                  childAspectRatio: 1,
                                ),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: gridImagePathList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                        switch (activeOptions[index]){
                                          case 0:
                                            Navigator.pushNamed(
                                                    context,
                                                    Routes.attendanceScreen,
                                                  );
                                                  break;
                                          case 1:
                                            Navigator.pushNamed(
                                              context,
                                                Routes.caseStudyListScreen,
                                            );
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           CominSoonScreen(
                                            //             isAppbar: true,
                                            //             title: "Case Study",
                                            //           )),
                                            // );
                                            break;
                                          case 2:
                                            Navigator.pushNamed(context, Routes.dailyWeeklyScreen,
                                                arguments:
                                                DailyWeeklyRoutingData(route: DailyJournalRoute.direct));
                                            // Navigator.pushNamed(context, Routes.incidentScreen, arguments: DailyRoutingDetails(route: DailyJournalRoute.direct));
                                            break;
                                          case 3:
                                            Navigator.pushNamed(
                                              context,
                                            Routes.briefcasescreen,
                                            );
                                            break;
                                          case 4:
                                            Navigator.pushNamed(
                                                context,
                                                Routes
                                                    .exceptionRotationListScreen, arguments:  BriefCaseRoutingData( )
                                              // Routes.procedureCountScreen,
                                            );
                                            break;
                                          // case 4:
                                          //   Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             CominSoonScreen(
                                          //               isAppbar: true,
                                          //               title: "Exception",
                                          //             )),
                                          //   );
                                          //   break;
                                          case 5:
                                            Navigator.pushNamed(
                                              context,
                                              Routes.medicalTerminologyScreen,
                                            );
                                            break;
                                        }
                                      //}
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: REdgeInsets.only(
                                              left: 5, right: 3),
                                          height: 0.075.sh,
                                          width: 60.w,
                                          // decoration: BoxDecoration(shape: BoxShape.circle, color: Color(Hardcoded.greenLight)),
                                          child: Padding(
                                            padding: REdgeInsets.all(1.0),
                                            child: gridImagePathList
                                                    .elementAt(index)
                                                    .contains('.png')
                                                ? Image.asset(
                                                    gridImagePathList
                                                        .elementAt(index),
                                                  )
                                                : SvgPicture.asset(
                                                    gridImagePathList
                                                        .elementAt(index),
                                                  ),
                                          ),
                                        ),
                                        SizedBox(height: 2.8.h),
                                        Text(
                                          gridTitleList.elementAt(index),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.sp,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height:0.01.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
  }

  Widget GridComponent(String color, String value, String path, String title) {
    return Stack(
      children: [
        Container(
          height: 0.4.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
            color: color == "Hardcoded.lightBlue"
                ? Color(Hardcoded.lightBlue)
                : color == "Hardcoded.lightPurple"
                    ? Color(Hardcoded.lightPurple)
                    : color == "Hardcoded.lightOrange"
                        ? Color(Hardcoded.lightOrange)
                        : Color(Hardcoded.lightPink),
          ),
          child: Padding(
            padding:
                REdgeInsets.only(left: 5, top: 8, right: 12, bottom: 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: REdgeInsets.only(left: 5, bottom: 5),
                      height: 0.04.sh,
                      width: 0.1.sw,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                          ),
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                blurStyle: BlurStyle.normal,
                                // spreadRadius: 0.5,
                                // blurRadius: 5,
                                color: Colors.grey)
                          ]),
                      child: Padding(
                        padding: REdgeInsets.all(5),
                        child: path.contains(".png")
                            ? Image.asset(path)
                            : SvgPicture.asset(path),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            value,
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22.sp,
                                    color: Color(Hardcoded.black)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: REdgeInsets.only(
                    left: 5,
                    top: 5,
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        letterSpacing: 0.5,
                        color: Color(Hardcoded.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 140,
          top: -25,
          child: Image.asset('assets/images/splash_top.png', height: 70.h),
        ),
      ],
    );
  }
}
