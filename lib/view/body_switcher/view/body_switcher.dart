// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';

import 'package:app_version_update/app_version_update.dart';
import 'package:clinicaltrac/clinician/model/profile_models/user_detail_model.dart';
import 'package:clinicaltrac/clinician/repository/vm_repository.dart';
import 'package:clinicaltrac/clinician/view/clini_dashboard/view/clini_dashboard.dart';
import 'package:clinicaltrac/clinician/view/login_screen/login_bottom_widget.dart';
import 'package:clinicaltrac/clinician/view/rotation_module/rotation_list_screen.dart';
import 'package:clinicaltrac/clinician/view/student_module/all_student_list_screen.dart';
import 'package:clinicaltrac/clinician/view/user_profile/view/user_profile_screen.dart';
import 'package:clinicaltrac/common/App_Version_Update/app_version_update.dart';
import 'package:clinicaltrac/common/bottom_bar_button.dart';
import 'package:clinicaltrac/common/coming_soon_screen_widget.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_models/common_request_model.dart';
import 'package:clinicaltrac/common/common_profile_photo.dart';
import 'package:clinicaltrac/common/drawer.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/redux/action/changeEditableProfile.dart';
import 'package:clinicaltrac/redux/action/rotations/set_acive_inactive_status.dart';
import 'package:clinicaltrac/redux/action/rotations/set_clockIn_clockout_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_rotation_list_action.dart';
import 'package:clinicaltrac/redux/action/set_hive_data_to_state.dart';
import 'package:clinicaltrac/view/announcement/vm_connector/announcement_vm_connector.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/home/vm_conector/home_screen_vm_conector.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/profile/model/get_student_detailss_model.dart';
import 'package:clinicaltrac/view/profile/vm_connector/profile_vm_connector.dart';
import 'package:clinicaltrac/view/rotations/vm_conector.dart/rotation_list_vm_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BodySwitcher extends StatefulWidget {
  const BodySwitcher(
      {super.key,
      required this.userLoginResponse,
      required this.initializeApp,
      required this.studentDetails,
      required this.initialPage,
      this.body});

  ///userLoginResponse
  final UserLoginResponse userLoginResponse;
  final VoidCallback initializeApp;
  final StudentDetailsResponse studentDetails;

  /// to load a particular page at initial time
  final Bottom_navigation_control? initialPage;
  final Widget? body;

  @override
  State<BodySwitcher> createState() => _BodySwitcherState();
}

class _BodySwitcherState extends State<BodySwitcher> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Widget body;
  UserDetailData userDetailData = new UserDetailData();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
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

  /// created [selectedNavigation] variable to know the bottom navigation bar state
  @override
  void initState() {
    Widget body = widget.userLoginResponse.data.loggedUserType != "Clinician"
        ? HomePageScreenConnector(
            pageChange: (Bottom_navigation_control BottomNavigationControl) {},
          )
        : ClinicianHomeScreen(
            pageChange: (Bottom_navigation_control BottomNavigationControl) {},
          );
    body = body;
    //widget.getwhatsAppStatus();
    if (widget.initialPage != null) {
      _onItemTapped(
        widget.initialPage ?? Bottom_navigation_control.home,
        context,
      );
    } else {
      body = widget.userLoginResponse.data.loggedUserType != "Clinician"
          ? HomePageScreenConnector(
              pageChange: pageChangeCallbackHandle,
            )
          : ClinicianHomeScreen(
              pageChange: pageChangeCallbackHandle,
            );
    }
    // setState(() {
    //   _checkAppUpdate();
    // });
    getLoggedUserDetails();
    store.dispatch(SetHiveDataToStateAction());
    getLocationPermission();
    widget.initializeApp();
    super.initState();
  }

  Future<void> getLoggedUserDetails() async {
    UserDatRepo userDatRepo = UserDatRepo();
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    CommonRequest request = CommonRequest(
      accessToken: box.get(Hardcoded.hiveBoxKey)!.accessToken,
      userId: box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
      userType: AppConsts.userType,
    );
    return userDatRepo.getUserDetailData(request,
        (UserDetailModel userDetailModel) {
      setState(() {
        userDetailData = userDetailModel.data!;
      });
      // return null;
    }, () {}, context);
  }

  Bottom_navigation_control selectedNavigation = Bottom_navigation_control.home;

  String greeting() {
    var hour = DateTime.now().hour;

    TimeOfDay day = TimeOfDay.now();
    final localizations = MaterialLocalizations.of(context);
    final formattedTimeOfDay = localizations.formatTimeOfDay(day);
    switch (day.period) {
      case DayPeriod.am:
        if (hour < 5) {
          return 'Good night!';
        }
        if (hour < 12 && hour > 5) {
          return 'Good Morning!';
        }
        break;
      case DayPeriod.pm:
        if (hour > 12 && hour < 17) {
          return 'Good Afternoon!';
        }
        if (hour > 17 && hour < 21) {
          return 'Good Evening!';
        }
        if (hour > 21 && hour < 24) {
          return 'Good Night!';
        }
        break;
    }
    // log("${hour}hour");

    return 'Good Morning!';
  }

  getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return AppHelper.buildErrorSnackbar(context,
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  @override
  Widget build(BuildContext context) {
    globalWidth = MediaQuery.of(context).size.width;
    globalHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: selectedNavigation == Bottom_navigation_control.home
          ? AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              toolbarHeight: 70,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 0),
                      child:
                          // widget.userLoginResponse.data.loggedUserType != "Clinician" ?
                          Text(
                        'Hi, ${userDetailData.loggedUserFirstName}',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                      )
                      // :Text(
                      //           'Hi, ${widget.userLoginResponse.data.loggedUserFirstName}',
                      //           textAlign: TextAlign.start,
                      //           style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      //             fontWeight: FontWeight.w600,
                      //             fontSize: 20,
                      //           ),
                      //         ),
                      ),
                  Text(
                    greeting(),
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          // fontSize: 17.25,
                        ),
                  ),
                ],
              ),
              elevation: 0,
              backgroundColor: Color(Hardcoded.white),
              actions: [
                GestureDetector(
                  onTap: _openEndDrawer,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      bottom: 10,
                    ),
                    child: commonProfilePhoto(
                      isEdit: false,
                      ImageLink:
                          // widget.userLoginResponse.data.loggedUserType != "Clinician" ? TextEditingController(text: widget.studentDetails.data.loggedUserProfile):
                          TextEditingController(
                              text: userDetailData.loggedUserProfile),
                      LocalPath: 'assets/images/default_profile_photo.png',
                      //  TextEditingController(
                      //   text: 'assets/images/default_profile_photo.png',
                      // ),
                      radius: 23,
                      isLocal:
                          // widget.userLoginResponse.data.loggedUserType != "Clinician" ? store.state.studentDetailsResponse.data.loggedUserProfile.isEmpty:
                          store.state.userLoginResponse.data.loggedUserProfile
                              .isEmpty,
                    ),
                    // child: CircleAvatar(child: Image.network(widget.userLoginResponse.data.loggedUserProfile),),
                  ),
                )
              ],
            )
          : selectedNavigation == Bottom_navigation_control.rotation
              ? null
              : selectedNavigation == Bottom_navigation_control.student
                  ? null
                  // CommonAppBar(
                  //   appBarColor: Colors.white,
                  //   isBackArrow: false,
                  //   isCenterTitle: true,
                  //   title: "Student",
                  //   onTap: () {
                  //     Navigator.pushReplacementNamed(
                  //       context,
                  //       Routes.bodySwitcher,
                  //       arguments: BodySwitcherData(
                  //           initialPage: Bottom_navigation_control.home),
                  //     );
                  //   },
                  // )
                  : selectedNavigation == Bottom_navigation_control.profile
                      ? null
                      : CommonAppBar(
                          appBarColor: Colors.white,
                          isBackArrow: false,
                          isCenterTitle: true,
                          title: "Announcement",
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.bodySwitcher,
                              arguments: BodySwitcherData(
                                  initialPage: Bottom_navigation_control.home),
                            );
                          },
                        ),
      endDrawer: clinicaltracDrawer(
        studentDetailsResponse: widget.studentDetails,
        userDetailData: userDetailData,
      ),
      endDrawerEnableOpenDragGesture: false,
      body: body,
      bottomNavigationBar: Container(
        child: SizedBox(
          height: globalHeight * 0.09,
          child: Center(
            child: Container(
              height: globalHeight * 0.7,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                new BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ]),
              child: Padding(
                padding: EdgeInsets.only(
                  left: globalWidth * 0.06,
                  // left: globalWidth * 0.1,
                  right: globalWidth * 0.06,
                  // right: globalWidth * 0.1,
                ),
                child:
                    widget.userLoginResponse.data.loggedUserType != "Clinician"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BottomBarButton(
                                  "Home",
                                  'assets/images/home.png',
                                  Bottom_navigation_control.home,
                                  selectedNavigation,
                                  _onItemTapped),
                              BottomBarButton(
                                  "Rotations",
                                  'assets/images/rotations.png',
                                  Bottom_navigation_control.rotation,
                                  selectedNavigation,
                                  _onItemTapped),
                              BottomBarButton(
                                  "Announcement",
                                  'assets/images/mike.png',
                                  // 'assets/images/messages.svg',
                                  Bottom_navigation_control.chat,
                                  selectedNavigation,
                                  _onItemTapped),
                              BottomBarButton(
                                  "Profile",
                                  'assets/images/profile.png',
                                  Bottom_navigation_control.profile,
                                  selectedNavigation,
                                  _onItemTapped),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BottomBarButton(
                                  "Home",
                                  'assets/images/home.png',
                                  Bottom_navigation_control.home,
                                  selectedNavigation,
                                  _onItemTapped),
                              BottomBarButton(
                                  "Rotations",
                                  'assets/images/rotations.png',
                                  Bottom_navigation_control.rotation,
                                  selectedNavigation,
                                  _onItemTapped),
                              BottomBarButton(
                                  "Students",
                                  'assets/images/students.png',
                                  Bottom_navigation_control.student,
                                  selectedNavigation,
                                  _onItemTapped),
                              BottomBarButton(
                                  "Announcement",
                                  'assets/images/mike.png',
                                  // 'assets/images/messages.svg',
                                  Bottom_navigation_control.chat,
                                  selectedNavigation,
                                  _onItemTapped),
                              BottomBarButton(
                                  "Profile",
                                  'assets/images/profile.png',
                                  Bottom_navigation_control.profile,
                                  selectedNavigation,
                                  _onItemTapped),
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pageChangeCallbackHandle(Bottom_navigation_control pageChange) {
    _onItemTapped(pageChange, context);
  }

  /// Just a method to handle different navigation clicks for bottom navigation bar items and home,notification
  /// this function would also take care of switching the body widget
  void _onItemTapped(Bottom_navigation_control index, BuildContext context) {
    setState(
      () {
        //  We need to set the index value only under each of the case so that
        //  when the drawer is opened, we do not highlight the drawer option.
        switch (index) {
          case Bottom_navigation_control.home:
            selectedNavigation = index;
getLoggedUserDetails();
            body = widget.userLoginResponse.data.loggedUserType != "Clinician"
                ? HomePageScreenConnector(pageChange: pageChangeCallbackHandle)
                : ClinicianHomeScreen(pageChange: pageChangeCallbackHandle);
            break;

          case Bottom_navigation_control.rotation:
            selectedNavigation = index;
            store.dispatch(
                SetRotationsListAction(active_status: Active_status.active));
            store.dispatch(SetActiveInactiveStatusAction(
                active_status: Active_status.active));
            // body = RotationListScreenConector();
            body = widget.userLoginResponse.data.loggedUserType != "Clinician"
                ? RotationListConector()
                : RotationListScreen();
            break;
          case Bottom_navigation_control.student:
            selectedNavigation = index;
            body = AllStudentListScreen();
            // body = Container(child: Center(child: Text("Student"),),);
            break;
          case Bottom_navigation_control.chat:
            selectedNavigation = index;
            // body = RotationListConector();
            body = AnnouncementConnector();
            break;
          // case Bottom_navigation_control.chat:
          //   selectedNavigation = index;
          //   body = CominSoonScreen();
          //   break;
          case Bottom_navigation_control.profile:
            selectedNavigation = index;
            store.dispatch(makeProfileEditable());

            // body = ProfileScreenConnector();
            body =
            // widget.userLoginResponse.data.loggedUserType != "Clinician" ? ProfileScreenConnector() :
            Profile();
            // Container(child: Center(child: Text("Profile"),),);
            break;
        }
      },
    );
  }
}
