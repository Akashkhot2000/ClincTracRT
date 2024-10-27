// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:clinicaltrac/clinician/model/clinician_rotation_list_model.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/redux/action/rotations/set_rotation_list_action.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:super_banners/super_banners.dart';

class RotationContainerWidget extends StatefulWidget {
  RotationContainerWidget(
      {super.key,
        required this.color,
        required this.showClockIn,
        required this.duration,
        required this.endDate,
        this.containercolor,
        required this.activeStatus,
        required this.clinicianRotationDetailListData});

  ///color to paint on date circular Container
  final Color color;


  final bool showClockIn;
  final bool duration;
  final bool endDate;
  final Active_status activeStatus;

  Color? containercolor;
  final ClinicianRotationDetailListData clinicianRotationDetailListData;

  @override
  State<RotationContainerWidget> createState() => _RotationContainerWidgetState();
}

class _RotationContainerWidgetState extends State<RotationContainerWidget> {

  Position? objPosition;
  // bool isLoading = true;

  // void startTimer() {
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  DateTime convertDateToUTC(String dateUtc) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
    var formattedTime = dateTime.toLocal();
    return formattedTime;
  }

  // void stopTimer() {
  //   Timer(const Duration(seconds: 3), () {
  //     setState(() {
  //       isLoading = true;
  //     });
  //   });
  // }



  @override
  void initState() {
    // _showPermissionAlertDialog();
    store.dispatch(SetRotationsListAction(active_status: widget.activeStatus));
    super.initState();
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
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
                              "${DateFormat("dd").format(convertDateToUTC("${widget.clinicianRotationDetailListData.startDate!}"))}",
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
                              "${DateFormat("MMM").format(convertDateToUTC("${widget.clinicianRotationDetailListData.startDate!}"))}",
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
                                widget.clinicianRotationDetailListData.rotationName!,
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
                                      widget.clinicianRotationDetailListData.hospitalName!,
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
                                      widget.clinicianRotationDetailListData.courseName!,
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
                  // if (widget.duration || widget.endDate)
                  //   SizedBox(
                  //     height: 13,
                  //   ),
                  // if (widget.duration || widget.endDate)
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Text(
                  //             'Duration: ',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .titleLarge!
                  //                 .copyWith(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 10,
                  //                 color: Colors.black54),
                  //           ),
                  //           Text(
                  //             "${DateFormat('hh:mm aa').format(widget.rotation.startDate)} to ${DateFormat('hh:mm aa').format(widget.rotation.endDate)}",
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .titleLarge!
                  //                 .copyWith(
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 10,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Row(
                  //         children: [
                  //           Text(
                  //             'End date: ',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .titleLarge!
                  //                 .copyWith(
                  //                 fontWeight: FontWeight.w500,
                  //                 fontSize: 10,
                  //                 color: Colors.black54),
                  //           ),
                  //           Text(
                  //             convertDate("${widget.rotation.endDate}"),
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .titleLarge!
                  //                 .copyWith(
                  //               fontWeight: FontWeight.w500,
                  //               fontSize: 10,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
