// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/ActiveRotationStatus.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/redux/action/rotations/active_rotation_status_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_acive_inactive_status.dart';
import 'package:clinicaltrac/redux/action/rotations/set_clockIn_clockout_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_rotation_list_action.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

// import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_banners/super_banners.dart';

class RotationContainerScreen extends StatefulWidget {
  RotationContainerScreen(
      {super.key,
      required this.color,
      required this.showClockIn,
      required this.duration,
      required this.endDate,
      required this.rotation,
      this.containercolor,
      required this.activeStatus,
      required this.pendingRotationList,
      required this.rotationListModel});

  ///color to paint on date circular Container
  final Color color;

  final Rotation rotation;

  final bool showClockIn;
  final bool duration;
  final bool endDate;
  final String activeStatus;

  Color? containercolor;
  final RotationListModel rotationListModel;

// final PendingRotation pendingRotationList;
  final List<PendingRotation> pendingRotationList;

  @override
  State<RotationContainerScreen> createState() =>
      _RotationContainerScreenState();
}

class _RotationContainerScreenState extends State<RotationContainerScreen> {
  String getMonthString(int monthInInt) {
    switch (monthInInt) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return '';
  }

  Position? objPosition;
  bool isLoading = true;

  void startTimer() {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void stopTimer() {
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      ;
    });
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
// 'We need your permission to access your location. \n This will allow us to verify your Clock in and Clock out times to maintain your attendance. You can disable location services at any time in the app settings, but this may affect your attendance records.',
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
// }
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
        print("sskkkgg");
        // print(status[Permission.location]);
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
        // if(await Permission.location.serviceStatus.isDisabled){AppHelper.buildErrorSnackbar(context,'Location services are disabled, Please enable your location and try again.');}
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
              widget.rotation.isClockIn == 0 ? "Clock In" : "Clock Out",
              widget.rotation.isClockIn == 0
                  ? 'Do you want to clock in for "${widget.rotation.rotationTitle}" rotation?'
                  : 'Do you want to clock out for "${widget.rotation.rotationTitle}" rotation?',
              'assets/images/timer.png',
              widget.rotation.isClockIn == 0
                  ? Color(Hardcoded.primaryGreen)
                  : Color(0xFFFA0202), () {
            if (widget.rotation.isClockIn != 2) {
              store.dispatch(
                SetClockInOutAction(
                  isForActiveRotation: false,
                  clockInOutStatus: widget.rotation.isClockIn == 1
                      ? ClockInOutStatus.out
                      : widget.rotation.isClockIn == 0
                          ? ClockInOutStatus.inn
                          : ClockInOutStatus.stop,
                  longitude: objPosition!.longitude.toString(),
                  lattitude: objPosition!.latitude.toString(),
                  rotationID: widget.rotation.rotationId,
                ),
              );

              if (widget.rotation.isClockIn == 0) {
                store.dispatch(
                  ActiveRotationStatusAction(
                    activeRotationStatus: ActiveRotationStatus(
                      isRotationActive: true,
                      rotationId: int.parse(widget.rotation.rotationId),
                      rotationName: widget.rotation.rotationTitle,
                    ),
                  ),
                );
                setState(() {
                  Navigator.of(context).pop();
                });
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
                    initialPage: Bottom_navigation_control.rotation,
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
              AppHelper.buildErrorSnackbar(
                  context, "You already completed this rotation");
            }
            if (widget.rotation.isClockIn == 1) {
              setState(() {
                Navigator.of(context).pop();
              });
              Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                  arguments: BodySwitcherData(
                    initialPage: Bottom_navigation_control.rotation,
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
  void initState() {
// _showPermissionAlertDialog();
    widget.rotation.isClockIn.toString();
// store.dispatch(SetRotationsListAction(active_status: widget.activeStatus));
    super.initState();
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
// log(widget.rotation.isClockIn.toString());
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 9,
        top: 9,
        right: 15,
        left: 15,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              color: widget.containercolor ?? Color(Hardcoded.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: globalHeight * 0.077,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.containercolor == null
                              ? widget.color.withOpacity(0.2)
                              : widget.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${widget.rotation.startDate.day}",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: widget.containercolor == null
                                        ? widget.color
                                        : Colors.white,
                                  ),
                            ),
                            Text(
                              getMonthString(widget.rotation.startDate.month),
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: widget.containercolor == null
                                        ? widget.color
                                        : Colors.white,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 0,
                                top: 0,
                              ),
                              child: Text(
                                widget.rotation.rotationTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.rotation.hospitalTitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.rotation.courseTitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.showClockIn)
                        if (!widget.rotation.isExpired)
                          Visibility(
                            visible: widget.rotation.isClockIn == 2
                                 && widget.activeStatus == "inActive"
                                ? false
                                : true,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                                right: 5,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  if (widget.rotation.isClockIn == 2) {
                                    AppHelper.buildErrorSnackbar(context,
                                        "You already completed this rotation");
                                    return;
                                  }

                                  if (widget.rotationListModel.data
                                              .isClockedIn ==
                                          true &&
                                      widget.pendingRotationList.isNotEmpty &&
                                      (widget.pendingRotationList.first
                                              .rotationId !=
                                          widget.rotation.rotationId)) {
                                    AppHelper.buildErrorSnackbar(
                                      context,
                                        "${widget.pendingRotationList.first
                                            .rotationTitle} rotation is already running",
                                      // "Clock out previously clocked in Rotation",
// durationMultiplier: 3
                                    );
                                    return;
                                  }
                                  startTimer();
// if (objPosition == null) {
                                  await _showPermissionAlertDialog()
                                      .whenComplete(() async {
                                    var status = Platform.isIOS
                                        ? await Permission.locationWhenInUse
                                            .serviceStatus.isEnabled
                                        : await Permission
                                            .location.serviceStatus.isEnabled;
                                    if (status ||
                                        await Permission.location.isGranted) {
                                      setState(() {
                                        objPosition;
                                      });
                                    } else {
                                      Future.delayed(Duration(seconds: 1), () {
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
                                  replacement:
                                      // Visibility(
                                      //   visible: widget.activeStatus == "inActive",
                                      //   child:
                                      widget.activeStatus != "inActive"
                                          ? Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFF1F5F5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      widget.rotation
                                                                  .isClockIn ==
                                                              0
                                                          ? "Clock In"
                                                          : widget.rotation
                                                                      .isClockIn ==
                                                                  1
                                                              ? "Clock Out"
                                                              : "Stop",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge!
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 10,
                                                          ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    FlipCard(
                                                      flipOnTouch: false,
                                                      onFlip: () {},
                                                      back: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: widget.rotation
                                                                      .isClockIn ==
                                                                  0
                                                              ? Color(Hardcoded
                                                                  .primaryGreen)
                                                              : widget.rotation
                                                                          .isClockIn ==
                                                                      1
                                                                  ? Color(
                                                                      Hardcoded
                                                                          .pink)
                                                                  : Colors.grey,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10,
                                                                  left: 8,
                                                                  top: 8,
                                                                  bottom: 10),
                                                          child: Image.asset(
                                                            "assets/images/timer.png",
                                                            color: Colors.white,
                                                            height: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      front: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: widget.rotation
                                                                      .isClockIn ==
                                                                  0
                                                              ? Color(Hardcoded
                                                                  .primaryGreen)
                                                              : widget.rotation
                                                                          .isClockIn ==
                                                                      1
                                                                  ? Color(
                                                                      Hardcoded
                                                                          .pink)
                                                                  : Colors.grey,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10,
                                                                  left: 8,
                                                                  top: 8,
                                                                  bottom: 10),
                                                          child: Image.asset(
                                                            "assets/images/timer.png",
                                                            color: Colors.white,
                                                            height: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          // : widget.rotation.isClockIn == 1
                                          //     ? Container(
                                          //         decoration: BoxDecoration(
                                          //           color: Color(0xFFF1F5F5),
                                          //           borderRadius:
                                          //               BorderRadius.circular(
                                          //                   10),
                                          //         ),
                                          //         child: Padding(
                                          //           padding:
                                          //               const EdgeInsets.all(
                                          //                   8.0),
                                          //           child: Column(
                                          //             children: [
                                          //               Text(
                                          //                 "Clock Out",
                                          //                 textAlign:
                                          //                     TextAlign.start,
                                          //                 style:
                                          //                     Theme.of(context)
                                          //                         .textTheme
                                          //                         .titleLarge!
                                          //                         .copyWith(
                                          //                           fontWeight:
                                          //                               FontWeight
                                          //                                   .w500,
                                          //                           fontSize:
                                          //                               10,
                                          //                         ),
                                          //               ),
                                          //               const SizedBox(
                                          //                 height: 5,
                                          //               ),
                                          //               FlipCard(
                                          //                 flipOnTouch: false,
                                          //                 onFlip: () {},
                                          //                 back: Container(
                                          //                   decoration:
                                          //                       BoxDecoration(
                                          //                     shape: BoxShape
                                          //                         .circle,
                                          //                     color: Color(
                                          //                         Hardcoded
                                          //                             .pink),
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding:
                                          //                         const EdgeInsets
                                          //                                 .only(
                                          //                             right: 10,
                                          //                             left: 8,
                                          //                             top: 8,
                                          //                             bottom:
                                          //                                 10),
                                          //                     child:
                                          //                         Image.asset(
                                          //                       "assets/images/timer.png",
                                          //                       color: Colors
                                          //                           .white,
                                          //                       height: 30,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 front: Container(
                                          //                   decoration:
                                          //                       BoxDecoration(
                                          //                     color: Color(
                                          //                         Hardcoded
                                          //                             .pink),
                                          //                     shape: BoxShape
                                          //                         .circle,
                                          //                   ),
                                          //                   child: Padding(
                                          //                     padding:
                                          //                         const EdgeInsets
                                          //                                 .only(
                                          //                             right: 10,
                                          //                             left: 8,
                                          //                             top: 8,
                                          //                             bottom:
                                          //                                 10),
                                          //                     child:
                                          //                         Image.asset(
                                          //                       "assets/images/timer.png",
                                          //                       color: Colors
                                          //                           .white,
                                          //                       height: 30,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       )
                                              : SizedBox(),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                  if (widget.duration || widget.endDate)
                    SizedBox(
                      height: 13,
                    ),
                  if (widget.duration || widget.endDate)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Duration: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black54),
                            ),
                            Text(
                              "${DateFormat('hh:mm aa').format(widget.rotation.startDate)} to ${DateFormat('hh:mm aa').format(widget.rotation.endDate)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'End date: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: Colors.black54),
                            ),
                            Text(
                              convertDate("${widget.rotation.endDate}"),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          if (widget.rotation.isExpired)
            CornerBanner(
              bannerPosition: CornerBannerPosition.topLeft,
              bannerColor: Colors.red,
              shadowColor: Colors.black.withOpacity(0.8),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Expired',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
