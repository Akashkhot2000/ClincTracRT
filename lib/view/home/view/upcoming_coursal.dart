// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_brace_in_string_interps, unnecessary_null_comparison

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/ActiveRotationStatus.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/redux/action/homeactions/get_active_rotation_list_action.dart';
import 'package:clinicaltrac/redux/action/rotations/active_rotation_status_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_clockIn_clockout_action.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/home/model/stud_active_rotation.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpcominCoursalBox extends StatefulWidget {
  const UpcominCoursalBox(
      {Key? key,
      required this.activeRotationListModel,
      required this.active_status})
      : super(key: key);
  final ActiveRotationListModel activeRotationListModel;

  final Active_status active_status;

  @override
  State<UpcominCoursalBox> createState() => _UpcominCoursalBoxState();
}

class _UpcominCoursalBoxState extends State<UpcominCoursalBox> {
  /// [currentCardIndex] to determine which card index is currently viewed
  int currentCardIndex = 0;
  String status = 'Clock In';

  /// [upcominCards] this list would consist of all credit cards that need to been shown on homepage
  List<Widget> upcominCards = <Widget>[];

  // List<ActiveRotationListModel> upcominCards = <ActiveRotationListModel>[];
  // CarouselController carouselController = CarouselController();

  Position? objPosition;

  bool isLoading = true;
  int isClockin = 0;
  String rotationId = '';
  String rotationName = '';

  void startTimer() {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    };
  }

  void stopTimer() {
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      };
    });
  }

  bool isFlipOnTuch = false;
  var _status = Permission.location.status;

  @override
  void initState() {
    store.dispatch(GetStudActiveRotationsListAction());
    // getLocation();
    super.initState();
    widget.activeRotationListModel.data.rotationList;
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    // String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    String formattedTime = DateFormat('hh:mm aa').format(now);
    return '${formattedTime}';
  }

  String showStartEndTimeFromDate(DateTime input, int workHr, int addHr) {
    DateTime tmpTime = DateTime(input.year, input.month, input.day,
        (input.hour + workHr + addHr), input.minute, input.second);
    //tmpTime.add(const Duration(hours: 3));
    String tmp = DateFormat('hh:mm a').format(tmpTime);
    return tmp;
  }

  Future<void> _showPermissionAlertDialog() async {
    var _status = await Permission.location.status;
    if (_status.isDenied || _status.isPermanentlyDenied) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                height: globalHeight * 0.42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5.0,
                        spreadRadius: 0.1),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Location Permission',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          left: 5,
                        ),
                        child: Text(
                          'We need your permission to access your location. \n\nThis will allow us to verify your Clock In and Clock Out times to maintain your attendance. Although you can disable location services at any time in the app settings, doing so will affect how your attendance is recorded.',
                         textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color(Hardcoded.primaryGreen),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Text(
                              'OK',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              stopTimer();
                            });
                            Navigator.pop(context);
                            checkLocation();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      await checkLocation();
    }
  }

  Future<void> checkLocation() async {
    var status = Platform.isIOS
        ? await Permission.locationWhenInUse.serviceStatus.isEnabled
        : await Permission.location.serviceStatus.isEnabled;
    // print("perrr:-- ${status}");
    if (status == true) {
      var _status = await Permission.location.status;
      if (_status.isGranted) {
        await _getUserLocation();
      } else {
        Map<Permission, PermissionStatus> status = await [
          Permission.location,
        ].request();
        // print("sskkkgg");
        print(status[Permission.location]);
      }
      if (await Permission.location.isDenied) {
        // Navigator.pop(context);
        openAppSettings();
      }
      if (await Permission.location.isPermanentlyDenied) {
        // Navigator.pop(context);
        openAppSettings();
      }
    } else {
      // Navigator.pop(context);
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          stopTimer();
        });
        await _getUserLocation();

        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        openAppSettings();
        return Future.error('Location permissions are denied');
      } else {
        if (permission == LocationPermission.deniedForever) {
          openAppSettings();
          // Permissions are denied forever, handle appropriately.
          return AppHelper.buildErrorSnackbar(context,
              'Location permissions are permanently denied, we cannot request permissions.');
        } else {
          await _getUserLocation();
        }
      }
    }
  }

  getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppHelper.buildErrorSnackbar(context,
          'Location services are disabled, Please enable your location and try again.');
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        openAppSettings();
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.deniedForever) {
        openAppSettings();
        // Permissions are denied forever, handle appropriately.
        return AppHelper.buildErrorSnackbar(context,
            'Location permissions are permanently denied, we cannot request permissions.');
      } else {
       await _getUserLocation();
      }
    }
  }

  Future<void> _getUserLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        objPosition = position;
        if (objPosition!.longitude != null && objPosition!.latitude != null) {
          common_rotation_popup_widget(
              context,
              isClockin == 0 ? "Clock In" : "Clock Out",
              isClockin == 0
                  ? 'Do you want to clock in for "${rotationName}" rotation?'
                  : 'Do you want to clock out for "${rotationName}" rotation?',
              'assets/images/timer.png',
              isClockin == 0
                  ? Color(Hardcoded.primaryGreen)
                  : Color(0xFFFA0202), () {

            if (isClockin != 2) {
              store.dispatch(
                SetClockInOutAction(
                  isForActiveRotation: false,
                  clockInOutStatus: isClockin == 1
                      ? ClockInOutStatus.out
                      : isClockin == 0
                          ? ClockInOutStatus.inn
                          : ClockInOutStatus.stop,
                  longitude: objPosition!.longitude.toString(),
                  lattitude: objPosition!.latitude.toString(),
                  rotationID: rotationId,
                ),
              );

              if (isClockin == 0) {
                store.dispatch(
                  ActiveRotationStatusAction(
                    activeRotationStatus: ActiveRotationStatus(
                      isRotationActive: true,
                      rotationId: int.parse(rotationId),
                      rotationName: rotationName,
                    ),
                  ),
                );
                Navigator.pop(context);
              } else {
                store.dispatch(
                  ActiveRotationStatusAction(
                    activeRotationStatus: ActiveRotationStatus(
                      isRotationActive: false,
                      rotationId: 0,
                      rotationName: '',
                    ),
                  ),
                );
              }
              ;
              Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                  arguments: BodySwitcherData(
                    initialPage: Bottom_navigation_control.home,
                  ));
            } else {
              store.dispatch(
                ActiveRotationStatusAction(
                  activeRotationStatus: ActiveRotationStatus(
                    isRotationActive: false,
                    rotationId: 0,
                    rotationName: '',
                  ),
                ),
              );
               AppHelper.buildErrorSnackbar(context, "You already completed this rotation");
            }
            if (isClockin == 1) {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                  arguments: BodySwitcherData(
                    initialPage: Bottom_navigation_control.home,
                  ));
            }
          });
        } else {
          null;
        }
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }


  @override
  Widget build(BuildContext context) {
    return widget.activeRotationListModel.data.rotationList.isEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Color(Hardcoded.greenLight),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 0.1,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 25,
                left: 20.0,
                right: 20,
                bottom: 25,
              ),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/notebook.png",
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 25,
                        left: 15.0,
                        right: 10,
                        bottom: 25,
                      ),
                      child: Text(
                        "NO ROTATIONS \nAVAILABLE",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7D7D7D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        :

        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 0.15.sh,
                          width: double.infinity,
                          child: CarouselSlider.builder(
                            itemCount: widget.activeRotationListModel.data
                                .rotationList.length,
                            itemBuilder: (context, itemIndex, realIndex) {
                              final int tempmonth = widget
                                  .activeRotationListModel.data.rotationList
                                  .elementAt(itemIndex)
                                  .startDate
                                  .month;
                              String monthInString =
                                  AppConsts.months.elementAt(tempmonth - 1);

                              return
                                  Container(
                                decoration: BoxDecoration(
                                  color: Color(0x857BF9C),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Color(0x8035E8AC)),
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.only(
                                      top: 10.h,
                                      left: 15.0,
                                      right: 15,
                                      bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                         child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 0.085.sh,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Color(0x8035E8AC)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${widget.activeRotationListModel.data.rotationList[itemIndex].startDate.day}",
                                                    // '14',
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15.sp,
                                                        ),
                                                    textScaleFactor: 1.0,
                                                  ),
                                                  Text(
                                                    monthInString,
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12.sp,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              // flex: 5,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${widget.activeRotationListModel.data.rotationList[itemIndex].title}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14.sp,
                                                          ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "${DateFormat("hh:mm aa").format(widget.activeRotationListModel.data.rotationList[itemIndex].startDate)} - ${DateFormat('hh:mm aa').format(widget.activeRotationListModel.data.rotationList[itemIndex].endDate)}",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11.sp,
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'End date : ',
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 10.sp,
                                                                  color: Colors
                                                                      .black54),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 5),
                                                            child: Text(
                                                              "${DateFormat("MMM dd, yyyy").format(widget.activeRotationListModel.data.rotationList[itemIndex].endDate)}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        10.sp,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 5,
                                                                    right: 5),
                                                            child: Text(
                                                              "${widget.activeRotationListModel.data.rotationList[itemIndex].hospitalTitle}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        11.sp,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          isClockin = widget
                                              .activeRotationListModel
                                              .data
                                              .rotationList
                                              .elementAt(itemIndex)
                                              .isClockIn;
                                          rotationName = widget
                                              .activeRotationListModel
                                              .data
                                              .rotationList
                                              .elementAt(itemIndex)
                                              .title;
                                          rotationId = widget
                                              .activeRotationListModel
                                              .data
                                              .rotationList
                                              .elementAt(itemIndex)
                                              .rotationId;
                                          // log(widget.activeRotationListModel.data.rotationList.elementAt(itemIndex).isClockIn.toString());
                                          if (widget.activeRotationListModel.data.rotationList.elementAt(itemIndex).isClockIn == 2) {
                                             AppHelper.buildErrorSnackbar(context,
                                                "You already completed this rotation");
                                            return;
                                          }
                                          // log("onFlip called");
                                          if (widget
                                                  .activeRotationListModel
                                                  .data
                                                  .pendingRotation
                                                  .isNotEmpty &&
                                              (widget
                                                      .activeRotationListModel
                                                      .data
                                                      .pendingRotation
                                                      .first
                                                      .rotationId !=
                                                  widget.activeRotationListModel
                                                      .data.rotationList
                                                      .elementAt(itemIndex)
                                                      .rotationId)) {
                                             AppHelper.buildErrorSnackbar(context,
                                               "${widget
                                                   .activeRotationListModel
                                                   .data
                                                   .pendingRotation.first.rotationTitle} rotation is already running",
                                              // "Clock out previously clocked in Rotation",
                                            );
                                            return;
                                          }

                                          startTimer();
                                          await _showPermissionAlertDialog()
                                              .whenComplete(() async {
                                            var status = Platform.isIOS
                                                ? await Permission.locationWhenInUse.serviceStatus.isEnabled
                                                : await Permission.location.serviceStatus.isEnabled;
                                            if (status ||
                                                await Permission
                                                    .location.isGranted) {
                                              setState(() {
                                                objPosition;
                                              });
                                            } else {
                                              Future.delayed(
                                                  Duration(seconds: 1), () {
                                                setState(() {
                                                  AppHelper.buildErrorSnackbar(context,
                                                      'Location services are disabled, Please enable your location and try again.');
                                                });
                                              });
                                            }
                                          });

                                          stopTimer();
                                        },
                                        child: Visibility(
                                          visible: !isLoading,
                                          child: common_loader(
                                            padding: 10,
                                          ),
                                          replacement: Visibility(
                                            child: Container(
                                              height: 0.12.sh,
                                              padding: REdgeInsets.all(09),
                                              decoration: BoxDecoration(
                                                color: Color(0x2657BF9C),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    widget.activeRotationListModel.data.rotationList.elementAt(itemIndex).isClockIn == 0
                                                        ? "Clock In"
                                                        : widget.activeRotationListModel.data.rotationList.elementAt(itemIndex).isClockIn ==
                                                                1
                                                            ? "Clock Out"
                                                            : "Stop",
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12.sp,
                                                        ),
                                                  ),
                                                   SizedBox(
                                                    height: 1.5.h,
                                                  ),
                                                  FlipCard(
                                                    flipOnTouch: false,
                                                    onFlip: () {},
                                                    back: Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: widget
                                                                    .activeRotationListModel
                                                                    .data
                                                                    .rotationList
                                                                    .elementAt(
                                                                        itemIndex)
                                                                    .isClockIn ==
                                                                0
                                                            ? Color(Hardcoded
                                                                .primaryGreen)
                                                            : widget
                                                                        .activeRotationListModel
                                                                        .data
                                                                        .rotationList
                                                                        .elementAt(
                                                                            itemIndex)
                                                                        .isClockIn ==
                                                                    1
                                                                ? Color(
                                                                    Hardcoded
                                                                        .pink)
                                                                : Colors.grey,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                             REdgeInsets
                                                                    .only(
                                                                right: 10,
                                                                left: 8,
                                                                top: 8,
                                                                bottom: 10),
                                                        child: Image.asset(
                                                          "assets/images/timer.png",
                                                          color: Colors.white,
                                                          height: 0.04.sh,
                                                        ),
                                                      ),
                                                    ),
                                                    front: Container(
                                                      decoration: BoxDecoration(
                                                        color: widget
                                                                    .activeRotationListModel
                                                                    .data
                                                                    .rotationList
                                                                    .elementAt(
                                                                        itemIndex)
                                                                    .isClockIn ==
                                                                0
                                                            ? Color(Hardcoded
                                                                .primaryGreen)
                                                            : widget
                                                                        .activeRotationListModel
                                                                        .data
                                                                        .rotationList
                                                                        .elementAt(
                                                                            itemIndex)
                                                                        .isClockIn ==
                                                                    1
                                                                ? Color(
                                                                    Hardcoded
                                                                        .pink)
                                                                : Colors.grey,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                             REdgeInsets
                                                                    .only(
                                                                right: 10,
                                                                left: 8,
                                                                top: 5,
                                                                bottom: 10),
                                                        child: Image.asset(
                                                          "assets/images/timer.png",
                                                          color: Colors.white,
                                                          height: 35.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            // carouselController: carouselController,
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              enlargeCenterPage: true,
                              onPageChanged: (int index, _) {
                                // log("$index=====");
                                setState(() {
                                  currentCardIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        widget.activeRotationListModel.data
                            .rotationList.length == 1 ? Container() : SizedBox(
                          height: 10,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.activeRotationListModel.data
                                .rotationList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  left: 5,
                                  right: 5,
                                ),
                                height: 5,
                                width: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentCardIndex == index
                                      ? Color(Hardcoded.primaryGreen)
                                      : Color(Hardcoded.primaryGreen)
                                          .withOpacity(0.5),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
