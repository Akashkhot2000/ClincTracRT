// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:clinicaltrac/clinician/model/clinician_rotation_list_model.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/ActiveRotationStatus.dart';
import 'package:clinicaltrac/redux/action/rotations/active_rotation_status_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_acive_inactive_status.dart';
import 'package:clinicaltrac/redux/action/rotations/set_clockIn_clockout_action.dart';
import 'package:clinicaltrac/redux/action/rotations/set_rotation_list_action.dart';
import 'package:clinicaltrac/view/body_switcher/vm_conector/body_switcher_vm_conector.dart';
import 'package:clinicaltrac/view/rotations/model/rotation_list_model.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

// import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_banners/super_banners.dart';

class RotationListWidget extends StatefulWidget {
  RotationListWidget({
    super.key,
    required this.color,
    // required this.showClockIn,
    required this.duration,
    required this.endDate,
    required this.rotation,
    this.containercolor,
    required this.activeStatus,
    // required this.pendingRotationList,
    // required this.rotationListModel
  });

  ///color to paint on date circular Container
  final Color color;

  final ClinicianRotationDetailListData rotation;

  // final bool showClockIn;
  final bool duration;
  final bool endDate;
  final String activeStatus;

  Color? containercolor;

  // final RotationListModel rotationListModel;

// final PendingRotation pendingRotationList;
//   final List<PendingRotation> pendingRotationList;

  @override
  State<RotationListWidget> createState() => _RotationListWidgetState();
}

class _RotationListWidgetState extends State<RotationListWidget> {
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
    setState(() {
      isLoading = false;
    });
  }

  void stopTimer() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
// String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  DateTime convertDateToUTC(String dateUtc) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
    var formattedTime = dateTime.toLocal();
    return formattedTime;
  }

  String timeConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    String formattedTime = DateFormat('hh:mm aa').format(now);
    return '${formattedTime}';
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
                              "${DateFormat("dd").format(convertDateToUTC("${widget.rotation.startDate!}"))}",
                              // "${convertDate("${widget.rotation.startDate!}")}",
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
                              "${DateFormat("MMM").format(convertDateToUTC("${widget.rotation.startDate!}"))}",
                              // getMonthString(widget.rotation.startDate!),
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
                                widget.rotation.rotationName!,
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
                                      widget.rotation.hospitalName!,
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
                                      widget.rotation.courseName!,
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
                    ],
                  ),
                  if (widget.duration || widget.endDate)
                    SizedBox(
                      height: 13,
                    ),
                  if (widget.duration || widget.endDate)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: new TextSpan(
                            text: 'Duration: ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Colors.black54),
                            children: <TextSpan>[
                              new TextSpan(
                                text:
                                    "${timeConvert("${widget.rotation.startDate!}")} to ${timeConvert("${widget.rotation.endDate!}")}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                              ),
                              // new TextSpan(text: ' world!'),
                            ],
                          ),
                        ),
                        RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: new TextSpan(
                            text: 'End date: ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Colors.black54),
                            children: <TextSpan>[
                              new TextSpan(
                                text: convertDate("${widget.rotation.endDate}"),
                                // maxLines: 2,
                                // overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                              ),
                              // new TextSpan(text: ' world!'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: new TextSpan(
                            text: 'Assigned students: ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Colors.black54),
                            children: <TextSpan>[
                              new TextSpan(
                                text: "${widget.rotation.studentCount!}",
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
                        ),
                      ),
                      SizedBox(
                        width: globalWidth * 0.09,
                      ),
                      Expanded(
                        child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: new TextSpan(
                            text: 'Location: ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Colors.black54),
                            children: <TextSpan>[
                              new TextSpan(
                                text: "${widget.rotation.location}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                    ),
                              ),
                              // new TextSpan(text: ' world!'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // SizedBox(
              //     height: 2,
              //   ),
            ),
          ),
          // if (widget.rotation.)
          //   CornerBanner(
          //     bannerPosition: CornerBannerPosition.topLeft,
          //     bannerColor: Colors.red,
          //     shadowColor: Colors.black.withOpacity(0.8),
          //     elevation: 5,
          //     child: Padding(
          //       padding: const EdgeInsets.all(2.0),
          //       child: Text(
          //         'Expired',
          //         style: Theme.of(context).textTheme.titleLarge!.copyWith(
          //               fontWeight: FontWeight.w600,
          //               fontSize: 9,
          //               color: Colors.white,
          //             ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
