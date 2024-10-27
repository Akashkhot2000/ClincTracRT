import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/clinician/model/user_dr_interaction_list_model.dart';
import 'package:clinicaltrac/clinician/view/dr_interaction_module/edit_dr_interaction_screen.dart';
import 'package:clinicaltrac/clinician/view/dr_interaction_module/view_dr_interaction_dtails_screen.dart';
import 'package:clinicaltrac/common/common-pop_up.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/routes.dart';
import 'package:clinicaltrac/helper/app_helper.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/view/dr_intraction/vm_conector/add_view_dr_interaction_vm_conector.dart';
import 'package:clinicaltrac/view/dr_intraction/vm_conector/dr_interaction_detail_vm_connector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserDrInteractionContainerWidget extends StatefulWidget {
  UserDrInteractionContainerWidget({
    super.key,
    required this.color,
    required this.drInteractionListData,
    required this.isFromDashboard,
    required this.onTapDelete,
    required this.pullToRefresh,
    required this.interactionDecCount,
    // required this.onTap,
  });

  ///color to paint on date circular Container
  final Color color;

  final UserDrInteractionListData drInteractionListData;
  final String interactionDecCount;

  final bool isFromDashboard;
  final Function() onTapDelete;

  // final Function() onTap;
  Function pullToRefresh;

  @override
  State<UserDrInteractionContainerWidget> createState() =>
      _UserDrInteractionContainerWidgetState();
}

class _UserDrInteractionContainerWidgetState
    extends State<UserDrInteractionContainerWidget> {
  String status = 'Clock In';

// late SlidableController slidableController;

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

  bool panelClosed = true;

  DateTime convertDateToUTC(String dateUtc) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
    var formattedTime = dateTime.toLocal();
    return formattedTime;
  }

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return '${formattedDate} ';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // log(panelClosed.toString() + "panelClose");

    // log(widget.drIntraction.interactionDate.toString() + "date");
    return Padding(
      padding: const EdgeInsets.only(bottom: 2, top: 6, right: 15, left: 15),
      child: Container(
        margin: EdgeInsets.all(0.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.5, .5],
            begin: Alignment.center,
            end: Alignment.topLeft,
            colors: [
              Color(Hardcoded.blue),
              panelClosed
                  ? Color(Hardcoded.blue)
                  : Colors.transparent, // top Right part
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Builder(builder: (ctx) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 8,
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    offset: const Offset(0, 3))
              ],
              borderRadius: BorderRadius.circular(15),
              color: Color(Hardcoded.white),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 0.076.sh,
                            width: 0.12.sw,
                            decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.2),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.all(6.91),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${DateFormat("dd").format(convertDateToUTC("${widget.drInteractionListData.interactionDate!}"))}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.sp,
                                            color: widget.color),
                                  ),
                                  Text(
                                    "${DateFormat("MMM").format(convertDateToUTC("${widget.drInteractionListData.interactionDate!}"))}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            color: widget.color),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.drInteractionListData.studentFullName!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.sp,
                                      ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: new TextSpan(
                                    text: 'Clinician : ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Colors.black54),
                                    children: <TextSpan>[
                                      new TextSpan(
                                        text: widget.drInteractionListData
                                            .clinicianFullName!,
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
                                ),
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: new TextSpan(
                                    text: 'Rotation : ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Colors.black54),
                                    children: <TextSpan>[
                                      new TextSpan(
                                        text: widget.drInteractionListData
                                            .rotationName!,
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
                                ),
                              ],
                            ),
                          ),
                          if (widget
                              .drInteractionListData.pointsAwarded!.isNotEmpty)
                            Container(
                              height: 0.076.sh,
                              width: 0.15.sw,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, left: 8, right: 8, bottom: 1),
                                child: Column(
                                  children: [
                                    Text(
                                      'Points',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Color(Hardcoded.black),
                                          ),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    FittedBox(
                                      child: Text(
                                        widget.drInteractionListData
                                                    .pointsAwarded!.length >
                                                3
                                            ? widget.drInteractionListData
                                                .pointsAwarded!
                                                .substring(0, 4)
                                            : widget.drInteractionListData
                                                .pointsAwarded!
                                                .substring(
                                                    0,
                                                    widget.drInteractionListData
                                                        .pointsAwarded!.length),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.sp,
                                              color: Color(Hardcoded.black),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 0.142.sw),
                        child: RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: new TextSpan(
                            text: 'Hospital site units : ',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.sp,
                                    color: Colors.black54),
                            children: <TextSpan>[
                              new TextSpan(
                                text:
                                    widget.drInteractionListData.rotationName!,
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
                        ),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: new TextSpan(
                                    text: 'Time spent : ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Colors.black54),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            "${widget.drInteractionListData.timeSpent!}",
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
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Clinician Signature : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11.sp,
                                              color: Colors.black54),
                                    ),
                                    if (widget
                                        .drInteractionListData.clinicianDate
                                        .toString()
                                        .isNotEmpty)
                                      Text(
                                        "${dateConvert("${widget.drInteractionListData.clinicianDate!}")}",
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
                              ]),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: new TextSpan(
                                  text: 'Clinician response : ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp,
                                          color: Colors.black54),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: widget.drInteractionListData
                                              .clinicianResponse!.isNotEmpty
                                          ? "Yes"
                                          : "No",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: widget
                                                    .drInteractionListData
                                                    .clinicianResponse!
                                                    .isNotEmpty
                                                ? Color(0xFF1FBC2F)
                                                : Color(0xFFFF746A),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'School Signature : ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                            color: Colors.black54),
                                  ),
                                  if (widget.drInteractionListData.schoolDate
                                      .toString()
                                      .isNotEmpty)
                                    Text(
                                      "${dateConvert("${widget.drInteractionListData.schoolDate!}")}",
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
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  height: globalHeight * 0.055,
                  decoration: BoxDecoration(
                    color: const Color(0x1413AD5D),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 0,
                      right: 0,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: (widget
                              .drInteractionListData.clinicianDate!.isEmpty)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                GestureDetector(
                                  // onTap: widget.onTap;
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditDrInteractionScreen(
                                          userDrInteractionListData:
                                              widget.drInteractionListData,
                                          interactionId: widget
                                              .drInteractionListData
                                              .interactionId!,
                                          interactionDecCount:
                                              widget.interactionDecCount,
                                        ),
                                      ),
                                    );
                                    await widget.pullToRefresh();
                                  },
                                  child: Container(
                                    width: globalWidth * 0.4,
                                    color: Colors.transparent,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: globalWidth * 0.02,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: globalWidth * 0.02,
                                              ),
                                              child: SvgPicture.asset(
                                                  "assets/images/Edit.svg"),
                                            ),
                                            Text(
                                              "Edit",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: Color(0xFF01A750),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ViewDrInteractionDetailScreen(
                                            userDrInteractionListData:
                                                widget.drInteractionListData,
                                            interactionId: widget
                                                .drInteractionListData
                                                .interactionId!,
                                          )),
                                );
                              },
                              child: Container(
                                width: globalWidth * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: globalWidth * 0.02,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: 5,
                                          ),
                                          child: SvgPicture.asset(
                                              "assets/images/eye.svg"),
                                        ),
                                        Text(
                                          "View",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Color(0xFF01A750),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                )
                // : Container(),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class customMotion extends StatefulWidget {
  customMotion(
      {Key? key,
      required this.onOpen,
      required this.onClose,
      required this.motionWidget})
      : super(key: key);

  final Function onOpen;
  final Function onClose;
  final Widget motionWidget;

  @override
  _customMotionState createState() => _customMotionState();
}

class _customMotionState extends State<customMotion> {
  late SlidableController controller;
  late void Function() myListener;
  bool isClosed = true;

  void animationListener() {
    // log(controller.ratio.toString());
    if ((controller.ratio < -0.4 || controller.ratio == 0)) {
      isClosed = true;
      widget.onClose();
    }

    if ((controller.ratio != 0)) {
      isClosed = false;
      widget.onOpen();
    }
  }

  @override
  void dispose() {
    controller.animation.removeListener(myListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = Slidable.of(context)!;
    myListener = animationListener;

    controller.animation.addListener(myListener);

    return widget.motionWidget;
  }
}
