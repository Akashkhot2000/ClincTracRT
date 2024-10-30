import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_textformfield.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/common/rounded_button.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/expectionmodel.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/attendance/models/attendance_response_model.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/home/vm_conector/home_screen_vm_conector.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:clinicaltrac/view/rotations/vm_conector.dart/rotation_list_vm_conector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ios_keyboard_action/ios_keyboard_action.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

class CreateExceptionScreen extends StatefulWidget {
  // UserLoginResponse userLoginResponse;
  // final AllRotationListModel rotationListModel;

  AllRotation allRotation;

  CreateExceptionScreen({
    super.key,
    // required this.userLoginResponse,
    // required this.rotationListModel,
    required this.allRotation,
  });

  @override
  State<CreateExceptionScreen> createState() => _CreateExceptionScreenState();
}

class _CreateExceptionScreenState extends State<CreateExceptionScreen> {
  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();
  TextEditingController checkInEditingController = TextEditingController();
  TextEditingController outInEditingController = TextEditingController();
  TextEditingController clockInTimeEditingController = TextEditingController();
  TextEditingController outOutTimeEditingController = TextEditingController();
  TextEditingController originalHrsEditingController = TextEditingController();
  TextEditingController expectionHrsEditingController =
      MaskedTextController(mask: '00:00');
  late TimeOfDay _startTime;

  // TextEditingController expectionHrsEditingController = TextEditingController();
  TextEditingController commentsEditingController = TextEditingController();
  final RegExp _timeRegex = RegExp(r'^[0-2]?[0-9]:[0-5][0-9]$');
  bool _isValid = true;
  DateTime clockOut = DateTime.now();
  DateTime clockIn = DateTime.now();
  DateTime? clockInTime;
  DateTime? clockOutTime;
  String timeDifference = '';

  DateTime convertDateToUTC(String dateUtc) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
    var formattedTime = dateTime.toLocal();
    return formattedTime;
  }

  String _timezone = DateTime.now().timeZoneName;

  Future<void> _initData() async {
    try {
      _timezone = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
    print("Local Timezone ${_timezone}");
    print("Rotation ID ${widget.allRotation.rotationId}");
    checkInEditingController.text = widget.allRotation.clockInDateTime != null
        ? DateFormat('MM-dd-yyyy').format(widget.allRotation.clockInDateTime!)
        : '';
    clockInTimeEditingController.text = widget.allRotation.clockInDateTime !=
            null
        ? DateFormat('hh:mm aa').format(
            convertDateToUTC(widget.allRotation.clockInDateTime!.toString()))
        : '';

    DateTime? times = widget.allRotation.clockInDateTime != null
        ? DateTime.parse(
            "${DateFormat('yyyy-MM-dd HH:mm:ss').format(convertDateToUTC(widget.allRotation.clockInDateTime!.toString()))}")
        : null;

    clockInTime = times;

    // outInEditingController.text = widget.attendanceData.clockOutDateTime != null
    //     ? DateFormat('MM-dd-yyyy')
    //         .format(widget.attendanceData.clockOutDateTime!)
    //     : '';
    // outOutTimeEditingController.text =
    //     widget.attendanceData.clockOutDateTime != null
    //         ? DateFormat('hh:mm').format(convertDateToUTC(
    //             widget.attendanceData.clockOutDateTime!.toString()))
    //         : '';
    // originalHrsEditingController.text = widget.allRotation.orignalhours;
    // expectionHrsEditingController.text = widget.attendanceData.approvedhours;
    // commentsEditingController.text = widget.attendanceData.comment;
  }

  Position? objPosition;

  Future<void> _showPermissionAlertDialog() async {
    // var status = Platform.isIOS
    //     ? await Permission.locationWhenInUse.serviceStatus.isEnabled
    //     : await Permission.location.serviceStatus.isEnabled;
    // print("perrr:-- ${status}");
    //
    // if (status == true) {
      var _status = await Permission.location.status;
    //   if (_status.isGranted) {
    //     await checkLocation();
    //   } else {
    //     Map<Permission, PermissionStatus> status = await [
    //       Permission.location,
    //     ].request();
    //     print("sskkkgg");
    //     print(status[Permission.location]);
    //   }
    if (_status.isDenied || _status.isPermanentlyDenied) {
    //   if (await Permission.location.isDenied || await Permission.location.isPermanentlyDenied) {
        /*Navigator.pop(context);
        openAppSettings();*/

        await showDialog(
          // barrierDismissible: false,
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
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Location Permission',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w900),
                          ),
                        ),
                        Expanded(
                            child: ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
                              Padding(
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
                            ])),
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
                                save.reset();
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
      /*if (await Permission.location.isPermanentlyDenied) {
        Navigator.pop(context);
        openAppSettings();
      }*/
    } else {
      await checkLocation();
    }
  }

  Future<void> checkLocation() async {
    var status = Platform.isIOS
        ? await Permission.locationWhenInUse.serviceStatus.isEnabled
        : await Permission.location.serviceStatus.isEnabled;
    print("perrr:-- ${status}");
    if (status == true) {
      var _status = await Permission.location.status;
      if (_status.isGranted) {
        await _getUserLocation();
      }
      else {
        Map<Permission, PermissionStatus> status = await [
          Permission.location,
        ].request();
        print("sskkkgg");
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
          save.reset();
        });
        // AppHelper.buildErrorSnackbar(context,'Location services are disabled, Please enable your location and try again.');
        _getUserLocation();

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
          _getUserLocation();
        }
      }
    }
  }
  // Future<void> checkLocation() async {
  //   var _status = await Permission.location.status;
  //   print("perrr:-- ${_status}");
  //   if (_status.isGranted) {
  //     await _getUserLocation();
  //   } else {
  //     // Navigator.pop(context);
  //     var _status = await Permission.location.status;
  //     print(_status);
  //     if (_status.isDenied) {
  //       // Navigator.pop(context);
  //       getLocationPermission();
  //     } else if (_status.isPermanentlyDenied) {
  //       openAppSettings();
  //     }
  //     // showUserTRAClocation();
  //   }
  // }

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
        _getUserLocation();
      }
    }
  }

  Future<void> _getUserLocation() async {
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      //setState(() => );
      setState(() {
        // position = position;
        objPosition = position;
      });
      // _getAddressFromLatLng(objPosition!);
      print("Location: ${objPosition}");
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //           objPosition!.longitude, objPosition!.latitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       objPosition =
  //           '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}'
  //               as Position?;
  //     });
  //   }).catchError((e) {
  //     debugPrint(e.toString());
  //   });
  // }

  void calculateTimeDifference() {
    if (clockInTime != null && clockOutTime != null) {
      DateTime clockIndate =
          DateFormat("MM-dd-yyyy").parse(checkInEditingController.text);
      DateTime clockOutdate =
          DateFormat("MM-dd-yyyy").parse(outInEditingController.text);
      DateTime dateTimeWithClockin = DateTime(
          clockIndate.year,
          clockIndate.month,
          clockIndate.day,
          clockInTime!.hour,
          clockInTime!.minute);
      DateTime dateTimeWithClockout = DateTime(
          clockOutdate.year,
          clockOutdate.month,
          clockOutdate.day,
          clockOutTime!.hour,
          clockOutTime!.minute);
      Duration difference =
          dateTimeWithClockout.difference(dateTimeWithClockin);
      // Duration difference = clockOutTime!.difference(clockInTime!);
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;
      setState(() {
        // TimeOfDay time = TimeOfDay(hour: hours, minute: minutes);
        // timeDifference ="${time.hour}:${time.minute}";
        timeDifference =
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      });
    } else {
      setState(() {
        timeDifference = 'fhgjhk';
      });
    }
    expectionHrsEditingController.text = timeDifference;
  }

  final clockinDateFocusNode = FocusNode();
  final clockoutDateFocusNode = FocusNode();
  final clockinTimeFocusNode = FocusNode();
  final clockoutTimeFocusNode = FocusNode();
  final origionalHourFocusNode = FocusNode();
  final exceptionHoursFocusNode = FocusNode();
  final commentFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Add Exception'),
      backgroundColor: Color(Hardcoded.white),
      bottomNavigationBar: NoInternet(
        child: BottomAppBar(
          height: globalHeight * 0.085,
          // color: Colors.amber,
          elevation: 0,
          child: CommonRoundedLoadingButton(
            controller: save,
            width: globalWidth * 0.9,
            title: 'Save',
            textcolor: Colors.white,
            onTap: () async {
              FocusScope.of(context).unfocus();
              if (expectionValidation()) {
                await _showPermissionAlertDialog().whenComplete(() async {
                  var status = Platform.isIOS
                      ? await Permission.locationWhenInUse.serviceStatus.isEnabled
                      : await Permission.location.serviceStatus.isEnabled;
                  if (status ||
                      await Permission
                          .location.isGranted) {saveExpectionOnnet();}else{
                    save.error();
                    Future.delayed(Duration(seconds: 1), () {
                      save.reset();setState(() {
                        AppHelper.buildErrorSnackbar(context,
                            'Location services are disabled, Please enable your location and try again.');
                      });
                    });
                  }
                });
              } else {
                save.error();
                Future.delayed(Duration(seconds: 2), () {
                  save.reset();
                });
              }
            },
            color: Color(Hardcoded.primaryGreen),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Color(0xFFEEEEEE),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              child: ScrollLoopAutoScroll(
                //for horizontal scrolling
                scrollDirection: Axis.horizontal,
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    // text: "Rotation Name :",
                    // style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    //     color: Color(0xFF999999),
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: 15),
                    // children: <TextSpan>[
                    //   TextSpan(
                    text: " ${widget.allRotation.rotationTitle}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                    // ),
                    // ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Material(
                        color: Colors.white,
                        child: CommonTextfield(
                          inputText: "Clock In Date",
                          iscalenderField: true,
                          autoFocus: false,
                          hintText: 'Clock In date',
                          textEditingController: checkInEditingController,
                          readOnly: true,
                          enabled: true,
                          onTap: () async {
                            var results = await showCalendarDatePicker2Dialog(
                              context: context,
                              value: [clockIn],
                              config:
                                  CalendarDatePicker2WithActionButtonsConfig(
                                      lastDate: DateTime.now(),
                                      selectedDayHighlightColor:
                                          Color(Hardcoded.primaryGreen)),
                              dialogSize: const Size(325, 400),
                              borderRadius: BorderRadius.circular(15),
                            );
                            if (results!.first!.compareTo(DateTime.now()) < 0 ||
                                results.first!.compareTo(DateTime.now()) == 0) {
                              setState(() {
                                clockIn = results.first!;
                                checkInEditingController.text =
                                    DateFormat('MM-dd-yyyy').format(clockIn);
                                calculateTimeDifference();
                                // log(checkInEditingController.text);
                              });
                            }
                          },
                          sufix: GestureDetector(
                            onTap: () async {
                              var results = await showCalendarDatePicker2Dialog(
                                context: context,
                                value: [clockIn],
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                        lastDate: DateTime.now(),
                                        selectedDayHighlightColor:
                                            Color(Hardcoded.primaryGreen)),
                                dialogSize: const Size(325, 400),
                                borderRadius: BorderRadius.circular(15),
                              );
                              if (results!.first!.compareTo(DateTime.now()) <
                                      0 ||
                                  results.first!.compareTo(DateTime.now()) ==
                                      0) {
                                setState(() {
                                  clockIn = results.first!;
                                  checkInEditingController.text =
                                      DateFormat('MM-dd-yyyy').format(clockIn);
                                  calculateTimeDifference();
                                  // log(checkInEditingController.text);
                                });
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(Hardcoded.primaryGreen),
                              child: SvgPicture.asset(
                                'assets/images/calendar.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.013,
                    ),
                    GestureDetector(
                      child: Material(
                        color: Colors.white,
                        child: CommonTextfield(
                          inputText: "Clock In Time",
                          iscalenderField: true,
                          autoFocus: false,
                          hintText: 'Clock In time',
                          textEditingController: TextEditingController(
                            text: clockInTime != null
                                ? DateFormat("h:mm a").format(clockInTime!)
                                : clockInTimeEditingController.text,
                          ),
                          // textEditingController: clockInTimeEditingController,
                          readOnly: true,
                          enabled: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await getTimePicker(true);
                            if (pickedTime != null) {
                              setState(() {
                                TimeOfDay time = TimeOfDay(
                                    hour: pickedTime.hour,
                                    minute: pickedTime.minute);
                                String formattedTime = formatTimeOfDay(time);
                                clockInTimeEditingController.text =
                                    formattedTime;
                              });
                            }
                          },
                          sufix: GestureDetector(
                            onTap: () async {
                              TimeOfDay? pickedTime = await getTimePicker(true);
                              if (pickedTime != null) {
                                setState(() {
                                  TimeOfDay time = TimeOfDay(
                                      hour: pickedTime.hour,
                                      minute: pickedTime.minute);
                                  String formattedTime = formatTimeOfDay(time);
                                  clockInTimeEditingController.text =
                                      formattedTime;
                                });
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(Hardcoded.primaryGreen),
                              child: SvgPicture.asset(
                                'assets/images/timeimage.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.013,
                    ),
                    GestureDetector(
                      child: Material(
                        color: Colors.white,
                        child: CommonTextfield(
                          inputText: "Clock Out Date",
                          iscalenderField: true,
                          autoFocus: false,
                          hintText: 'Clock Out date',
                          textEditingController: outInEditingController,
                          readOnly: true,
                          enabled: true,
                          onTap: () async {
                            var results = await showCalendarDatePicker2Dialog(
                              context: context,
                              value: [clockOut],
                              config:
                                  CalendarDatePicker2WithActionButtonsConfig(
                                      lastDate: DateTime.now(),
                                      selectedDayHighlightColor:
                                          Color(Hardcoded.primaryGreen)),
                              dialogSize: const Size(325, 400),
                              borderRadius: BorderRadius.circular(15),
                            );
                            if (results!.first!.compareTo(DateTime.now()) < 0 ||
                                results.first!.compareTo(DateTime.now()) == 0) {
                              setState(() {
                                clockOut = results.first!;
                                outInEditingController.text =
                                    DateFormat('MM-dd-yyyy').format(clockOut);
                                calculateTimeDifference();
                                // log(outInEditingController.text);
                              });
                            }
                          },
                          sufix: GestureDetector(
                            onTap: () async {
                              var results = await showCalendarDatePicker2Dialog(
                                context: context,
                                value: [clockOut],
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(
                                        lastDate: DateTime.now(),
                                        selectedDayHighlightColor:
                                            Color(Hardcoded.primaryGreen)),
                                dialogSize: const Size(325, 400),
                                borderRadius: BorderRadius.circular(15),
                              );
                              if (results!.first!.compareTo(DateTime.now()) <
                                      0 ||
                                  results.first!.compareTo(DateTime.now()) ==
                                      0) {
                                setState(() {
                                  clockOut = results.first!;
                                  outInEditingController.text =
                                      DateFormat('MM-dd-yyyy').format(clockOut);
                                  calculateTimeDifference();
                                  // log(outInEditingController.text);
                                });
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(Hardcoded.primaryGreen),
                              child: SvgPicture.asset(
                                'assets/images/calendar.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.013,
                    ),
                    GestureDetector(
                      child: Material(
                        color: Colors.white,
                        child: CommonTextfield(
                          inputText: "Clock Out Time",
                          iscalenderField: true,
                          autoFocus: false,
                          hintText: 'Clock Out time',
                          textEditingController: TextEditingController(
                            text: clockOutTime != null
                                ? DateFormat("h:mm a").format(clockOutTime!)
                                : outOutTimeEditingController.text,
                          ),
                          // textEditingController: outOutTimeEditingController,
                          readOnly: true,
                          enabled: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await getTimePicker(false);
                            if (pickedTime != null) {
                              setState(() {
                                TimeOfDay time = TimeOfDay(
                                    hour: pickedTime.hour,
                                    minute: pickedTime.minute);
                                String formattedTime = formatTimeOfDay(time);
                                outOutTimeEditingController.text =
                                    formattedTime;
                              });
                            }
                          },
                          sufix: GestureDetector(
                            onTap: () async {
                              TimeOfDay? pickedTime =
                                  await getTimePicker(false);
                              if (pickedTime != null) {
                                setState(() {
                                  TimeOfDay time = TimeOfDay(
                                      hour: pickedTime.hour,
                                      minute: pickedTime.minute);
                                  String formattedTime = formatTimeOfDay(time);
                                  outOutTimeEditingController.text =
                                      formattedTime;
                                });
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: Color(Hardcoded.primaryGreen),
                              child: SvgPicture.asset(
                                'assets/images/timeimage.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.013,
                    ),
                    Material(
                      color: Colors.white,
                      child: IOSKeyboardAction(
                        label: 'DONE',
                        focusNode: exceptionHoursFocusNode,
                        focusActionType: FocusActionType.done,
                        onTap: () {},
                        child: CommonTextfield(
                          focusNode: exceptionHoursFocusNode,
                          autoFocus: false,
                          inputText: "Exception Hours",
                          onTap: () async {},
                          onChanged: (value) {
                            setState(() {
                              _isValid = _timeRegex.hasMatch(value);
                            });
                            // log("adsfghjklkjhgfd ---------------${expectionHrsEditingController.text}");
                          },
                          hintText: 'HH:MM',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9:0-9]'))
                          ],
                          // inputFormatters: <TextInputFormatter>[timeMaskFormatter],
                          keyboardType: TextInputType.number,
                          textEditingController: expectionHrsEditingController,
                          sufix: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: globalWidth * 0.1,
                              // color: Colors.orange,
                              child: Center(
                                child: Text(
                                  "hours ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontSize: 14,
                                          color: Color(0xFF999999),
                                          fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.013,
                    ),
                    Material(
                      color: Colors.white,
                      child: IOSKeyboardAction(
                        label: 'DONE',
                        focusNode: commentFocusNode,
                        focusActionType: FocusActionType.done,
                        onTap: () {},
                        child: CommonTextfield(
                          autoFocus: false,
                          inputText: "Comments",
                          focusNode: commentFocusNode,
                          hintText: 'Enter comment',
                          textEditingController: commentsEditingController,
                          maxLines: 5,
                        ),
                      ),
                    ),
                    // CommonRoundedLoadingButton(
                    //   controller: save,
                    //   width: globalWidth * 0.9,
                    //   title: 'Save',
                    //   textcolor: Colors.white,
                    //   onTap: () {
                    //     FocusScope.of(context).unfocus();
                    //     if (expectionValidation()) {
                    //       saveExpectionOnnet();
                    //     }
                    //     save.reset();
                    //   },
                    //   color: Color(Hardcoded.primaryGreen),
                    // ),
                    SizedBox(
                      height: Platform.isIOS
                          ? globalHeight * 0.07
                          : globalHeight * 0.01,
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

  final MaskTextInputFormatter timeMaskFormatter =
      MaskTextInputFormatter(mask: '##:##', filter: {"#": RegExp(r'[0-9]')});

  bool expectionValidation() {
    if (checkInEditingController.text == null ||
        checkInEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select clock in date");
      return false;
    }
    if (clockInTimeEditingController.text == null ||
        clockInTimeEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select clock in time");
      return false;
    }
    if (outInEditingController.text == null ||
        outInEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select clock out date");
      return false;
    }
    if (outOutTimeEditingController.text == null ||
        outOutTimeEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select clock out time");
      return false;
    }
    // if (originalHrsEditingController.text == null ||
    //     originalHrsEditingController.text.isEmpty) {
    //   AppHelper.buildErrorSnackbar(context, "Please select original hours");
    //   return false;
    // }
    if (!_isValid) {
      AppHelper.buildErrorSnackbar(
          context, "Please add hours in (HH:MM) format");
      return false;
    }
    if (expectionHrsEditingController.text == null ||
        expectionHrsEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter exception hours");
      return false;
    }
    if (commentsEditingController.text == null ||
        commentsEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter comment");
      return false;
    }

    return true;
  }

  Future<void> saveExpectionOnnet() async {
    //if (objPosition == null) {

    //}

    DateTime clockOut =
        DateFormat("MM-dd-yyyy").parse(outInEditingController.text);

    String clockoutdate = DateFormat("yyyy-MM-dd").format(clockOut);

    DateTime clockIN =
        DateFormat("MM-dd-yyyy").parse(checkInEditingController.text);

    String clockindate = DateFormat("yyyy-MM-dd").format(clockIN);

    TimeOfDay _inTime =
        hours12To24(clockInTimeEditingController.text.toString());
    TimeOfDay _outTime =
        hours12To24(outOutTimeEditingController.text.toString());

    TimeOfDay timeIn = TimeOfDay(hour: _inTime.hour, minute: _inTime.minute);
    TimeOfDay timeOut = TimeOfDay(hour: _outTime.hour, minute: _outTime.minute);

    String inTime = "${timeIn.hour}:${timeIn.minute}";
    String outTime = "${timeOut.hour}:${timeOut.minute}";

    // log("${outOutTimeEditingController.text}");
    if (isCheckValidDate(clockIN, clockOut)) {
      if (isCheckValidTime(clockIN, clockOut)) {
        Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
        ExpectionModel expectionModel = ExpectionModel(
          userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
          attendanceId: widget.allRotation.attendanceId,
          clockInDate: clockindate.toString(),
          clockOutDate: clockoutdate.toString(),
          reason: commentsEditingController.text.toString(),
          clockInTime: inTime
              .toString()
              .replaceAll("AM", "")
              .replaceAll("PM", "")
              .trim(),
          clockOutTime: outTime
              .toString()
              .replaceAll("AM", "")
              .replaceAll("PM", "")
              .trim(),
          exceptionHours: expectionHrsEditingController.text,
          hospitalSiteId: widget.allRotation.hospitalId,
          lattitude: objPosition!.latitude.toString(),
          longitude: objPosition!.longitude.toString(),
          rotationId: widget.allRotation.rotationId,
          accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,
          isTimeZone: _timezone,
        );
        final DataService dataService = locator();
        final DataResponseModel dataResponseModel =
            await dataService.saveExpection(expectionModel);
        if (dataResponseModel.success) {
          save.success();
          Future.delayed(const Duration(seconds: 2), () {
            save.reset();
          }).then((value) {
            save.reset();
            Navigator.pushReplacementNamed(context, Routes.bodySwitcher,
                arguments: BodySwitcherData(
                  initialPage: Bottom_navigation_control.home,
                ));
            common_alert_pop(context, 'Successfully added\nException.',
                'assets/images/success_Icon.svg', () {
              Navigator.pop(context);
            });
          });
        } else {
          save.error();
          Future.delayed(const Duration(seconds: 1), () {
            save.reset();
          }).then((value) => AppHelper.buildErrorSnackbar(
              context, dataResponseModel.errorResponse.errorMessage));
        }
      } else {
        save.reset();
        AppHelper.buildErrorSnackbar(context,
            "Clock Out date must be greater than or equal to Clock In date");
      }
    } else {
      save.reset();
      AppHelper.buildErrorSnackbar(context,
          "Clock Out date must be greater than or equal to Clock In date");
    }
  }

  bool isCheckValidDate(DateTime clockinDates, DateTime clockoutDates) {
    bool isValid = false;
    if(clockoutDates.isAfter(clockinDates) || clockoutDates.isAtSameMomentAs(clockinDates)){
    // if (clockinDates.year <= clockoutDates.year) {
    //   if (clockinDates.month <= clockoutDates.month) {
    //     if (clockinDates.day <= clockoutDates.day) {
          isValid = true;
        }
    //   }
    // }
    return isValid;
  }

  bool isCheckValidTime(DateTime clockinTime, DateTime clockoutTime) {
    bool isValid = false;
    if (clockinTime.hour <= clockoutTime.hour) {
      if (clockinTime.minute <= clockoutTime.minute) {
        isValid = true;
      }
    }
    return isValid;
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  Future<TimeOfDay?> getTimePicker(bool isStartTime) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(Hardcoded.primaryGreen), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black, // button text color
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: false,
            ),
            child: child!,
          ),
        );
      },
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (timeOfDay != null) {
      setState(() {
        if (isStartTime) {
          clockInTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            timeOfDay.hour,
            timeOfDay.minute,
          );
        } else {
          clockOutTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            timeOfDay.hour,
            timeOfDay.minute,
          );
        }
        calculateTimeDifference();
      });
    }
    return timeOfDay;
  }

  TimeOfDay hours12To24(String text) {
    int hours = int.parse(text.split(":")[0].trim());
    int min =
        int.parse(text.split(":")[1].replaceAll("PM", "").replaceAll("AM", ""));
    String Am_Pm = text
        .split(":")[1]
        .substring(text.split(":")[1].length - 2, text.split(":")[1].length);
    if (Am_Pm.compareTo("PM") == 0) {
      if (hours != 12) {
        hours = hours + 12;
      }
    }
    if (Am_Pm.compareTo("AM") == 0) {
      if (hours == 12) {
        hours = 00;
      }
    }
    return TimeOfDay(hour: hours, minute: min);
    // return TimeOfDay.fromDateTime(DateTime(  hours, min));
  }
}
