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
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
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

class ExceptionScreen extends StatefulWidget {
  UserLoginResponse userLoginResponse;
  RotationListStudentJournal rotationListJournal;
  AttendanceData attendanceData;

  // Rotation rotation;

  ExceptionScreen({
    super.key,
    required this.attendanceData,
    required this.userLoginResponse,
    // required this.rotation,
    required this.rotationListJournal,
  });

  @override
  State<ExceptionScreen> createState() => _ExceptionScreenState();
}

class _ExceptionScreenState extends State<ExceptionScreen> {
  RoundedLoadingButtonController cancel = RoundedLoadingButtonController();
  RoundedLoadingButtonController save = RoundedLoadingButtonController();
  TextEditingController checkInEditingController = TextEditingController();
  TextEditingController outInEditingController = TextEditingController();
  TextEditingController clockInTimeEditingController = TextEditingController();
  TextEditingController outOutTimeEditingController = TextEditingController();
  TextEditingController originalHrsEditingController = TextEditingController();
  TextEditingController expectionHrsEditingController =
      MaskedTextController(mask: '00:00');
  TextEditingController commentsEditingController = TextEditingController();
  final RegExp _timeRegex = RegExp(r'^[0-2]?[0-9]:[0-5][0-9]$');
  bool _isValid = true;
  bool isEnable = false;

  DateTime clockOut = DateTime.now();
  DateTime clockIn = DateTime.now();

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
    print("Attendance ID ${widget.attendanceData.attendanceId}");
    checkInEditingController.text = widget.attendanceData.clockInDateTime !=
            null
        ? DateFormat('MM-dd-yyyy').format(
            convertDateToUTC(widget.attendanceData.clockInDateTime!.toString()))
        : '';
    clockInTimeEditingController.text = widget.attendanceData.clockInDateTime !=
            null
        ? DateFormat('hh:mm aa').format(
            convertDateToUTC(widget.attendanceData.clockInDateTime!.toString()))
        : '';
    outInEditingController.text = widget.attendanceData.clockOutDateTime != null
        ? DateFormat('MM-dd-yyyy').format(convertDateToUTC(
            widget.attendanceData.clockOutDateTime!.toString()))
        : '';
    outOutTimeEditingController.text =
        widget.attendanceData.clockOutDateTime != null
            ? DateFormat('hh:mm aa').format(convertDateToUTC(
                widget.attendanceData.clockOutDateTime!.toString()))
            : '';
    originalHrsEditingController.text = widget.attendanceData.orignalhours;
    expectionHrsEditingController.text = widget.attendanceData.approvedhours;
    commentsEditingController.text = widget.attendanceData.comment;
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
        // AppHelper.buildErrorSnackbar(context, 'Location services are disabled, Please enable your location and try again.');
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
  //       Navigator.pop(context);
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
      appBar: CommonAppBar(
          title: widget.attendanceData.isException == false
              ? 'Add Exception'
              : 'Edit Exception'),
      backgroundColor: Color(Hardcoded.white),
      bottomNavigationBar: BottomAppBar(
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
    if (widget.attendanceData.clockOutLattitude.isEmpty) {  await _showPermissionAlertDialog().whenComplete(() async {
      var status = Platform.isIOS
          ? await Permission.locationWhenInUse.serviceStatus.isEnabled
          : await Permission.location.serviceStatus.isEnabled;
      if (status ||
          await Permission
              .location.isGranted) {saveExpectionOnnet();}else{
                  save.error();
                  Future.delayed(Duration(seconds: 2), () {
                    save.reset();setState(() {
                      AppHelper.buildErrorSnackbar(context,
                          'Location services are disabled, Please enable your location and try again.');
                    });
                  });
                }
              });
            }else{
      saveExpectionOnnet();
    }} else {
              save.error();
              Future.delayed(Duration(seconds: 2), () {
                save.reset();
              });
            }


        },
          color: Color(Hardcoded.primaryGreen),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
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
                    enabled: false,
                    onTap: () {},
                    sufix: GestureDetector(
                      onTap: () {},
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
                    textEditingController: clockInTimeEditingController,
                    readOnly: true,
                    enabled: false,
                    onTap: () {},
                    sufix: GestureDetector(
                      onTap: () {},
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
                    enabled: outInEditingController.text == '' ? true : false,
                    onTap: () async {
                      var results = await showCalendarDatePicker2Dialog(
                        context: context,
                        value: [clockOut],
                        config: CalendarDatePicker2WithActionButtonsConfig(
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
                          // log(outInEditingController.text);
                        });
                      }
                      // else {
                      //   AppHelper.buildErrorSnackbar(context,
                      //       "from Date cannot be greater than to Date");
                      // }
                    },
                    sufix: GestureDetector(
                      onTap: () async {
                        var results = await showCalendarDatePicker2Dialog(
                          context: context,
                          value: [clockOut],
                          config: CalendarDatePicker2WithActionButtonsConfig(
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
                            // log( outInEditingController.text);
                          });
                        }
                        // else {
                        //   AppHelper.buildErrorSnackbar(context,
                        //       "from Date cannot be greater than to Date");
                        // }
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
                    textEditingController: outOutTimeEditingController,
                    readOnly: true,
                    enabled:
                        outOutTimeEditingController.text == '' ? true : false,
                    onTap: () async {
                      TimeOfDay? pickedTime = await getTimePicker();
                      if (pickedTime != null) {
                        setState(() {
                          TimeOfDay time = TimeOfDay(
                              hour: pickedTime.hour, minute: pickedTime.minute);
                          String formattedTime = formatTimeOfDay(time);
                          outOutTimeEditingController.text = formattedTime;
                        });
                      }
                      // else {
                      //   AppHelper.buildErrorSnackbar(
                      //       context, "Please add clock out time");
                      // }
                    },
                    sufix: GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await getTimePicker();
                        if (pickedTime != null) {
                          setState(() {
                            TimeOfDay time = TimeOfDay(
                                hour: pickedTime.hour,
                                minute: pickedTime.minute);
                            String formattedTime = formatTimeOfDay(time);
                            outOutTimeEditingController.text = formattedTime;
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
              widget.attendanceData.clockOutDateTime == null
                  ? Container()
                  : SizedBox(
                      height: globalHeight * 0.013,
                    ),
              widget.attendanceData.clockOutDateTime == null
                  ? Container()
                  : CommonTextfield(
                      autoFocus: false,
                      inputText: "Original Hours",
                      hintText: 'HH:MM',
                      iscalenderField: true,
                      enabled: false,
                      readOnly: true,
                      textEditingController: originalHrsEditingController,
                      onTap: () async {
                        TimeOfDay? pickedTime = await getTimePicker();
                        if (pickedTime != null) {
                          setState(() {
                            originalHrsEditingController.text = pickedTime
                                .format(context); //set the value of text field.
                          });
                        }
                        // else {
                        //   AppHelper.buildErrorSnackbar(
                        //       context, "Original hours is not selected");
                        //   print("Original hours is not selected");
                        // }
                      },
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
                    onTap: () async {
                      // TimeOfDay? pickedTime = await getTimePicker();
                      // if (pickedTime != null) {
                      //   setState(() {
                      //     List<String> list =
                      //         pickedTime.format(context).toString().split(" ");
                      //     expectionHrsEditingController.text = list[0];
                      //   });
                      // }
                      // else {
                      //   AppHelper.buildErrorSnackbar(
                      //       context, "Exception hours is not selected");
                      //   print("Exception hours is not selected");
                      // }
                    },
                    onChanged: (value) {
                      setState(() {
                        _isValid = _timeRegex.hasMatch(value);
                      });
                    },
                    hintText: 'HH:MM',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9:0-9]'))
                    ],
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
              // SizedBox(
              //   height: globalHeight * 0.02,
              // ),
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
                height:
                    Platform.isIOS ? globalHeight * 0.07 : globalHeight * 0.01,
              ),
            ],
          ),
        ),
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
    if (originalHrsEditingController.text == null ||
        originalHrsEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select original hours");
      return false;
    }
    if (!_isValid) {
      AppHelper.buildErrorSnackbar(
          context, "Please add hours in (HH:MM) format");
      return false;
    }
    if (expectionHrsEditingController.text == null ||
        expectionHrsEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please select exception hours");
      return false;
    }
    if (commentsEditingController.text == null ||
        commentsEditingController.text.isEmpty) {
      AppHelper.buildErrorSnackbar(context, "Please enter comment");
      return false;
    }

    return true;
  }

  // String showStartEndTimeFromDate(TimeOfDay input,int workHr, int addHr) {
  //   TimeOfDay tmpTime = TimeOfDay(hour: workHr, m: addHr,
  //       (input.hour + input.minute),);
  //   //tmpTime.add(const Duration(hours: 3));
  //   String tmp = DateFormat('hh:mm').format(tmpTime);
  //   return tmp;
  // }
  Future<void> saveExpectionOnnet() async {
    // if (widget.attendanceData.clockOutLattitude.isEmpty) {
    //   //if (objPosition == null) {
    //   await _showPermissionAlertDialog();
    //   //}
    // }
    try {
      DateTime clockOut =
          DateTime.parse(outInEditingController.text.toString());
    } catch (e) {
      print(e);
    }

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
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    if (isCheckValidDate(clockIN, clockOut)) {
      // if (isCheckValidTime(clockIN, clockOut)) {
      ExpectionModel expectionModel = ExpectionModel(
        userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
        clockInDate: clockindate.toString(),
        clockOutDate: clockoutdate.toString(),
        // + outOutTimeEditingController.text.toString(),
        reason: commentsEditingController.text.toString(),
        clockInTime:
            inTime.toString().replaceAll("AM", "").replaceAll("PM", "").trim(),
        clockOutTime:
            outTime.toString().replaceAll("AM", "").replaceAll("PM", "").trim(),
        attendanceId: widget.attendanceData.attendanceId,
        exceptionHours: expectionHrsEditingController.text,
        hospitalSiteId: widget.attendanceData.hospitalSiteId,
        lattitude: widget.attendanceData.clockOutLattitude.isEmpty
            ? objPosition!.latitude.toString()
            : widget.attendanceData.clockOutLattitude.toString(),
        longitude: widget.attendanceData.clockOutLongitude.isEmpty
            ? objPosition!.longitude.toString()
            : widget.attendanceData.clockOutLongitude.toString(),
        rotationId: widget.attendanceData.rotationId,
        accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,
        isTimeZone: _timezone,
      );
      final DataService dataService = locator();
      final DataResponseModel dataResponseModel =
          await dataService.saveExpection(expectionModel);
      if (dataResponseModel.success) {
        save.success();
        // Future.delayed(const Duration(seconds: 1), () {}).then((value) {AppHelper.buildErrorSnackbar(context, dataResponseModel.message);
        Future.delayed(const Duration(seconds: 2), () {
          save.reset();
        }).then((value) {
          Navigator.pop(context);
          common_alert_pop(
              context,
              // widget.attendanceData.clockOutDateTime == null &&
                      widget.attendanceData.isException == false
                  ? 'Successfully added\nException.'
                  : 'Successfully updated\nException.',
              'assets/images/success_Icon.svg', () {
            Navigator.pop(context);
          });
          // Navigator.pushNamed(
          //   context,
          //   Routes.attendanceScreen,
          // );
          // });
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
  }

  bool isCheckValidDate(DateTime clockinDates, DateTime clockoutDates) {
    bool isValid = false;
    if(clockoutDates.isAfter(clockinDates) || clockoutDates.isAtSameMomentAs(clockinDates)){
              isValid = true;
            }

    return isValid;
  }

  // Future<TimeOfDay?> getTimePicker()  async {
  //   TimeOfDay? timeOfDay = await showTimePicker(
  //       context: context,
  //       builder: (BuildContext context, child) {
  //         return Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: ColorScheme.light(
  //               primary: Color(Hardcoded.primaryGreen), // <-- SEE HERE
  //               onPrimary: Colors.white, // <-- SEE HERE
  //               surface: Colors.white,
  //               onSurface: Colors.black, // <-- SEE HERE
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 primary: Colors.black, // button text color
  //               ),
  //             ),
  //           ),
  //           child: child ?? Container(),
  //         );
  //       },
  //       initialTime: TimeOfDay(hour: 12, minute: 00),
  //       );
  //   return timeOfDay;
  //   }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }

  Future<TimeOfDay?> getTimePicker() async {
    TimeOfDay? timeOfDay = await showTimePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(Hardcoded.primaryGreen), // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              surface: Colors.white,
              onSurface: Colors.black, // <-- SEE HERE
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
