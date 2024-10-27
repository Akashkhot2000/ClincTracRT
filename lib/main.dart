import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:async_redux/async_redux.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/web_data_service.dart';
import 'package:clinicaltrac/clinician/view/change_password/ChangePasswordNewScreen.dart';
import 'package:clinicaltrac/clinician/view/daily_journal_module/daily_journal_list_screen.dart';
import 'package:clinicaltrac/clinician/view/dr_intraction/view/dr_intraction_list_screen.dart';
import 'package:clinicaltrac/clinician/view/forgot_pwd/view/forgot_pwd_screen_new.dart';
import 'package:clinicaltrac/clinician/view/login_screen/login_screen.dart';
import 'package:clinicaltrac/clinician/view/login_screen/role_selection_screen.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/view/Midterm_evaluation/Vm_conector/add_midterm_vm_connector.dart';
import 'package:clinicaltrac/view/PEF_Evaluation/vm_connector/pef_eval_vm_connector.dart';
import 'package:clinicaltrac/view/announcement/vm_connector/announcement_vm_connector.dart';
import 'package:clinicaltrac/view/app_entry/app_entry.dart';
import 'package:clinicaltrac/view/attendance/vm_connector/add_exception_vm_connector.dart';
import 'package:clinicaltrac/view/attendance/vm_connector/attendance_vm_connector.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/brief_case/vm_connector/brief_case_vm_connector.dart';
import 'package:clinicaltrac/view/case_study/vm_connector/case_study_connector.dart';
import 'package:clinicaltrac/view/change_password/ChangePasswordScreen.dart';
import 'package:clinicaltrac/view/check_offs/vm_connector/checkoffs_connector.dart';
import 'package:clinicaltrac/view/ci/vm_connector/ci_vm_connector.dart';
import 'package:clinicaltrac/view/daily_journal_details/vm_connector.dart/dailyJournal_detail_vm_connector.dart';
import 'package:clinicaltrac/view/daily_journal_details/vm_connector.dart/daily_journal_details_vm_connector.dart';
import 'package:clinicaltrac/view/daily_weekly/vm_connector/add_dailyweekly_vm_connector.dart';
import 'package:clinicaltrac/view/dr_intraction/vm_conector/dr_interaction_detail_vm_connector.dart';
import 'package:clinicaltrac/view/equipment/vm_connector/equipment_vm_connector.dart';
import 'package:clinicaltrac/view/floor_therapy/vm_connector/add_floorTherapy_vm_connector.dart';
import 'package:clinicaltrac/view/floor_therapy/vm_connector/floor_vm_list_connector.dart';
import 'package:clinicaltrac/view/forgot_pwd/forgot_pwd_screen.dart';
import 'package:clinicaltrac/view/formative/view/detailedViewFormative.dart';
import 'package:clinicaltrac/view/formative/view/signOffScreen.dart';
import 'package:clinicaltrac/view/formative/vm_connector/formative_vm_connector.dart';
import 'package:clinicaltrac/view/home/view/upcoming_carousal_container.dart';
import 'package:clinicaltrac/view/exception_dashboard/vm_connector/exception_rotation_conector.dart';
import 'package:clinicaltrac/view/incident/vm_connector/incident_vm_connector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/login_screen.dart';
import 'package:clinicaltrac/view/mastery_evaluation/vm_connector/mastery_evaluation_vm_connector.dart';
import 'package:clinicaltrac/view/medical_treminology/vm_conector/medical_term_connector.dart';
import 'package:clinicaltrac/view/midterm_evaluation/Vm_conector/midterm_eval_vm_conector.dart';
import 'package:clinicaltrac/view/p_evaluation/model/p_eval_vm_connector.dart';
import 'package:clinicaltrac/view/procedurer_counts/vm_conector/all_rotation_list_vm_conector.dart';
import 'package:clinicaltrac/view/profile/vm_connector/profile_vm_connector.dart';
import 'package:clinicaltrac/view/summative/vm_connector/add_summative_vm_connector.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clinician/view/dr_intraction/vm_model/dr_interaction_vm_conector.dart';
import 'redux/app_state.dart';
import 'view/daily_journal/vm_connector/daily_journal_vm_connector.dart';
import 'view/daily_weekly/vm_connector/daily_weekly_vm_connector.dart';
import 'view/dr_intraction/vm_conector/add_view_dr_interaction_vm_conector.dart';
import 'view/dr_intraction/vm_conector/dr_interaction_vm_conector.dart';
import 'view/formative/vm_connector/add_formative_vm_connector.dart';
import 'view/rotations/vm_conector.dart/rotation_list_vm_conector.dart';
import 'view/site_evaluation/vm_conector/site_eval_vm_conector.dart';
import 'view/summative/vm_connector/summative_vm_connector.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

double globalHeight =
    MediaQuery
        .of(navigatorKey.currentState!.context)
        .size
        .height;
double globalWidth =
    MediaQuery
        .of(navigatorKey.currentState!.context)
        .size
        .width;

int PDF_SIZE_LIMIT = 5000000;

/// store variable to store the redux data
late Store<AppState> store;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

  ///initial state of [AppState]
  final AppState state = await AppState.initialState();

  await setupServiceLocator();
  store = Store<AppState>(initialState: state);

  ///initialize hive
  await Hive.initFlutter();

  ///register owr generated class
  Hive.registerAdapter(UserLoginResponseHiveAdapter());

  ///open the hive box
  await Hive.openBox<UserLoginResponseHive>(Hardcoded.hiveBoxKey);

  await runZonedGuarded(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    ////RunApp
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
        .then((_) {
      runApp(StoreProvider<AppState>(
        store: store,
        child: MyApp(),
      ));
    });
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver, RouteAware {
  bool isUSerLogin = false;
  bool jailbroken = false;
  bool developerMode = false;

  //declaration of hive box
  late Box<UserLoginResponseHive> box;

  Future<void> getIsLoginValue() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      isUSerLogin = sharedPreferences.getBool('isUserLogin') ?? false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getIsLoginValue();
    checkJailBreak();
    super.initState();
    box = Boxes.getUserInfo();
    WidgetsBinding.instance?.addObserver(this);
    final DateTime now = DateTime.now();
    final DateFormat formatter =
    DateFormat('ddMMyyyy'); //DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);

    // getAppBuild Version
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      if (WebDataService.baseurl == "https://rt.clinicaltrac.net") {
        setState(() {
          AppConsts.strBuildVersion =
          Platform.isIOS ? "V.${version}_${buildNumber}" : "V.${version}";
          AppConsts.strAndroidIOSBuildVersion = Platform.isIOS
              ? "IOS.${version}.${buildNumber}"
              : "AND.${version}";
          // log("and/IOS..............${AppConsts.strAndroidIOSBuildVersion}");

          // "${version}.${buildNumber}_${formatted}";
        });
      }
    });
  }

  @override
  void didPush() {
    print('Home page pushed');
  }

  @override
  void didPopNext() {
    print('Home page popped');
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void checkJailBreak() async {
    jailbroken = await FlutterJailbreakDetection.jailbroken;
    developerMode = await FlutterJailbreakDetection.developerMode;
    if (Platform.isAndroid) {
      if (developerMode == true) {
        _showJailBreakOverlay(navigatorKey.currentState!.context);
      }
    } else {
      if (jailbroken == true) {
        _showJailBreakOverlay(navigatorKey.currentState!.context);
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // Perform specific actions based on the lifecycle state
    switch (state) {
      case AppLifecycleState.resumed:
        print('App resumed');
        checkJailBreak();
        break;
      case AppLifecycleState.inactive:
        print('App inactive');
        checkJailBreak();
        break;
      case AppLifecycleState.paused:
        print('App paused');
        checkJailBreak();
        break;
      case AppLifecycleState.detached:
        print('App detached');

        break;
    }
  }

  final CTRouteObserver routeObserver =
  CTRouteObserver(); //RouteObserver<PageRoute>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // log(isUSerLogin.toString());
    return ScreenUtilInit(
        designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child)
    {
      return KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection
        ],
        child: MaterialApp(

            navigatorKey: navigatorKey,
            builder: EasyLoading.init(
              builder: (BuildContext context, Widget? child) {
                ScreenUtil.init(context);
                EasyLoading.init();
                globalWidth = ScreenUtil().screenWidth;
                globalHeight = ScreenUtil().screenHeight;
                child = MediaQuery(
                  child: child!,
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                );
                return child;
              },
            ),
            title: 'Clinical Trac RT',
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.appEntry,
            // initialRoute: Routes.roleSelectionScreen,
           theme: ThemeData(
              fontFamily: "Poppins",
              primarySwatch: Colors.blue,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Color.fromARGB(255, 1, 167, 80),
                selectionColor: Color.fromARGB(255, 8, 204, 116),
                selectionHandleColor: Color.fromARGB(255, 1, 167, 80),
              ),
            ),
            navigatorObservers: [routeObserver],
            routes: <String, WidgetBuilder>{
              Routes.appEntry: (BuildContext context) => const AppEntry(),
              Routes.roleSelectionScreen: (BuildContext context) => const UserRoleSelectScreen(),
              // Clinician/Student ---------------------------------------------------------------------------------------------------------------

              Routes.userLogin: (BuildContext context) => const UserLoginScreen(),
              Routes.forgotUserPasswordScreen: (BuildContext context) =>
              const ForgotUserPasswordScreen(),
              ////ohk
              Routes.changeUserPasswordScreen: (BuildContext context) =>
              const ChangeUserPasswordScreen(),

              // Routes.dailyJournalListScreen: (BuildContext context) => DailyJournalListScreen(),
              //
              // Routes.dailyJournalsDetailsScreen: (BuildContext context) => DailyJournalListScreen(),

              /// Student ----------------------------------------------------------------------------------------------------
              Routes.login: (BuildContext context) => const LoginScreen(),
              Routes.rotationsListScreen: (
                  BuildContext context) => const RotationListConector(),
              Routes.upcomingCarousalContainer: (BuildContext context) =>
              const UpcomingCarousalContainer(),
              Routes.changePasswordScreen: (BuildContext context) =>
              const ChangePasswordScreen(),
              Routes.profileScreen: (BuildContext context) =>
              const ProfileScreenConnector(),
              Routes.medicalTerminologyScreen: (BuildContext context) =>
              const MedicalTerminologyScreenConector(),
              Routes.procedureRotationListScreen: (BuildContext context) =>
                  AllRotationListConector(),
              Routes.exceptionRotationListScreen: (BuildContext context) =>
                  ExceptionRotationListConector(),
              Routes.attendanceScreen: (BuildContext context) =>
                  AttedanceScreenConnector(),
              Routes.caseStudyListScreen: (BuildContext context) =>
                  CaseStudyScreenConnector(),
              Routes.announcementListScreen: (BuildContext context) =>
                  AnnouncementConnector(),

            },
            onGenerateRoute: (RouteSettings settings) {
              final Object? argument = settings.arguments;

              switch (settings.name) {
                // case Routes.drInteractionListScreen:
                //   {
                //     // return MaterialPageRoute(builder: (context) =>
                //     //     DrInteractionNewListScreen(
                //     //         drInteractionListScreenVM: UniDrInteractionListScreenVM(
                //     //             showAdd: false)));
                //   }
                case Routes.bodySwitcher:
                  {
                    return BodySwitcherData.resolveRoute(
                      settings.arguments == null
                          ? BodySwitcherData(
                          initialPage: Bottom_navigation_control.home)
                          : argument! as BodySwitcherData,
                      settings,
                    );
                  }
                case Routes.dailyJournalDetailsScreen:
                  {
                    return DailyJournalData.resolveRoute(
                      argument! as DailyJournalData,
                      settings,
                    );
                  }
                case Routes.incidentScreen:
                  {
                    return DailyRoutingDetails.resolveRoute(
                      argument! as DailyRoutingDetails,
                      settings,
                    );
                  }
                case Routes.dailyJournalDetailDataScreen:
                  {
                    return DailyJournalDetailData.resolveRoute(
                      argument! as DailyJournalDetailData,
                      settings,
                    );
                  }
                case Routes.addDrInteractionScreen:
                  {
                    return AddViewDrIntgeractionData.resolveRoute(
                      argument! as AddViewDrIntgeractionData,
                      settings,
                    );
                  }

                case Routes.drInteractionDetailScreen:
                  {
                    return DrInteractionDetailData.resolveRoute(
                      argument! as DrInteractionDetailData,
                      settings,
                    );
                  }
                case Routes.SignOffEvualtionScreen:
                  {
                    return SignOffEvaluationRoutingData.resolveRoute(
                      argument! as SignOffEvaluationRoutingData,
                      settings,
                    );
                  }
                case Routes.drInteractionListScreen:
                  {
                    return
                      DrInteractionListScreenDta.resolveRoute(
                        argument! as DrInteractionListScreenDta,
                        settings,
                      );
                    // DrInteractionNewListScreen(active_status: ,);
                  }
                case Routes.checkoffsListScreen:
                  {
                    return CheckoffsDta.resolveRoute(
                      argument! as CheckoffsDta,
                      settings,
                    );
                  }
              // {
              //     return DrInteractionListScreenDta.resolveRoute(
              //       argument! as DrInteractionListScreenDta,
              //       settings,
              //     );
              //   }//old flow
                case Routes.detailedFormativeScreen:
                  {
                    return DetailedViewFormativeRoutingData.resolveRoute(
                      argument! as DetailedViewFormativeRoutingData,
                      settings,
                    );
                  }
                case Routes.dailyJournalScreen:
                  {
                    return DailyRoutingData.resolveRoute(
                      argument! as DailyRoutingData,
                      settings,
                    );
                  }
                case Routes.formativeScreen:
                  {
                    return FormativeRoutingData.resolveRoute(
                      argument! as FormativeRoutingData,
                      settings,
                    );
                  }
                case Routes.exceptionScreen:
                  {
                    return AddAttendExceptionRoutingData.resolveRoute(
                      argument! as AddAttendExceptionRoutingData,
                      settings,
                    );
                  }
                case Routes.addformativeScreen:
                  {
                    return AddFormativeRoutingData.resolveRoute(
                      argument! as AddFormativeRoutingData,
                      settings,
                    );
                  }
                case Routes.dailyWeeklyScreen:
                  {
                    return DailyWeeklyRoutingData.resolveRoute(
                      argument! as DailyWeeklyRoutingData,
                      settings,
                    );
                  }
                case Routes.summativeScreen:
                  {
                    return SummativeRoutingData.resolveRoute(
                      argument! as SummativeRoutingData,
                      settings,
                    );
                  }
                case Routes.ciScreen:
                  {
                    return CIRoutingData.resolveRoute(
                      argument! as CIRoutingData,
                      settings,
                    );
                  }

                case Routes.masteryListScreen:
                  {
                    return MasteryEvaluationRoutingData.resolveRoute(
                      argument! as MasteryEvaluationRoutingData,
                      settings,
                    );
                  }
                case Routes.briefcasescreen:
                  {
                    return BriefCaseRoutingData.resolveRoute(
                      settings,
                    );
                  }
                case Routes.addSummativeScreen:
                  {
                    return AddSummativeRoutingData.resolveRoute(
                      argument! as AddSummativeRoutingData,
                      settings,
                    );
                  }
                case Routes.addMidtermScreen:
                  {
                    return AddMidtermRoutingData.resolveRoute(
                      argument! as AddMidtermRoutingData,
                      settings,
                    );
                  }

                case Routes.addDailyWeeklyScreen:
                  {
                    return AddDailyWeeklyRoutingData.resolveRoute(
                      argument! as AddDailyWeeklyRoutingData,
                      settings,
                    );
                  }
                case Routes.pefEvaluationScreen:
                  {
                    return GetPefEvalListRoutingData.resolveRoute(
                      argument! as GetPefEvalListRoutingData,
                      settings,
                    );
                  }
                case Routes.pEvaluationScreen:
                  {
                    return GetPEvalListRoutingData.resolveRoute(
                      argument! as GetPEvalListRoutingData,
                      settings,
                    );
                  }
                case Routes.floorEvaluationScreen:
                  {
                    return GetFloorListRoutingData.resolveRoute(
                      argument! as GetFloorListRoutingData,
                      settings,
                    );
                  }
                case Routes.addFloorTherapyScreen:
                  {
                    return AddFloorTherapyRoutingData.resolveRoute(
                      argument! as AddFloorTherapyRoutingData,
                      settings,
                    );
                  }
                case Routes.equipmentListScreen:
                  {
                    return GetEquipmentListRoutingData.resolveRoute(
                      argument! as GetEquipmentListRoutingData,
                      settings,
                    );
                  }
              }
              return null;
            }),
      );
    });
  }
}

class CTRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  // Override the methods you want to track
  bool isUSerLogin = false;
  bool jailbroken = false;
  bool developerMode = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Route push event
    print('Route pushed: ${route.settings.name}');
    checkJailBreak();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Route pop event
    print('Route popped: ${route.settings.name}');
    checkJailBreak();
  }

  void checkJailBreak() async {
    jailbroken = await FlutterJailbreakDetection.jailbroken;
    developerMode = await FlutterJailbreakDetection.developerMode;
    if (Platform.isAndroid) {
      if (developerMode == true) {
        _showJailBreakOverlay(navigatorKey.currentState!.context);
      }
    } else {
      if (jailbroken == true) {
        _showJailBreakOverlay(navigatorKey.currentState!.context);
      }
    }
  }
}

void _showJailBreakOverlay(BuildContext context) {
  // OverlayState? overlayState = Overlay.of(context);
  // late OverlayEntry overlayEntry;
  //
  // overlayEntry = OverlayEntry(
  //   opaque: true,
  //   maintainState: true,
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: Text('Information'),
  //       content: Text('Please disable developer mode.'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             overlayEntry.remove();
  //             //SystemNavigator.pop();
  //             SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //           },
  //           child: Text('Close'),
  //         ),
  //       ],
  //     );
  //   },
  // );
  // overlayState?.insert(overlayEntry);
}

String DateToString(DateTime? dateTime, {istime = false}) {
  if (dateTime == null) return "-";
  return istime
      ? DateFormat("MMM dd, yyyy; hh:mm a").format(dateTime)
      : DateFormat("MMM dd, yyyy").format(dateTime);
}
