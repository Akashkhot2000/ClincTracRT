
import 'package:clinicaltrac/clinician/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class UniDrInteractionContainer extends StatefulWidget {
  UniDrInteractionContainer({
    super.key,
    required this.color,
    required this.drIntraction,
    required this.isFromDashboard,
    required this.onTapDelete,
    required this.pullToRefresh,
    required this.interactionDecCount,
    // required this.onTap,
  });

  ///color to paint on date circular Container
  final Color color;

  final ClinicianInteractionList drIntraction;
  final String interactionDecCount;

  final bool isFromDashboard;
  final Function() onTapDelete;

  // final Function() onTap;
  Function pullToRefresh;

  @override
  State<UniDrInteractionContainer> createState() => _UniDrInteractionContainerState();
}

class _UniDrInteractionContainerState extends State<UniDrInteractionContainer> {
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

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
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
      padding: const EdgeInsets.only(bottom: 6, top: 6, right: 15, left: 15),
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
          return
              // Slidable(
              // key: UniqueKey(),
              // // The end action pane is the one at the right or the bottom side.
              // endActionPane: ActionPane(
              //   extentRatio: 0.4,
              //   motion: ScrollMotion(),
              //   children: [
              //     //edit
              //     if ((widget.drIntraction.schoolDate.isEmpty &&
              //             widget.drIntraction.clinicianDate.isEmpty) ||
              //         (widget.drIntraction.clinicianDate.isEmpty &&
              //             widget.drIntraction.schoolDate.isNotEmpty))
              //       Expanded(
              //         child: GestureDetector(
              //           onTap: () {
              //             setState(() {});
              //             Navigator.pushNamed(
              //               context,
              //               Routes.addDrInteractionScreen,
              //               arguments: AddViewDrIntgeractionData(
              //                   rotationId: widget.drIntraction.rotationId,
              //                   rotationTitle: widget.drIntraction.rotationName,
              //                   drIntractionAction: DrIntractionAction.edit,
              //                   drIntraction: widget.drIntraction,
              //                   isFromDashboard: widget.isFromDashboard),
              //             );
              //           },
              //           child: Container(
              //             color: Color(Hardcoded.blue),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Container(
              //                   child: SvgPicture.asset(
              //                     'assets/images/edit_d.svg',
              //                   ),
              //                 ),
              //                 Text(
              //                   "Edit",
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .titleLarge!
              //                       .copyWith(
              //                         fontWeight: FontWeight.w500,
              //                         fontSize: 14,
              //                         color: Color(Hardcoded.white),
              //                       ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //
              //     /// View
              //     if ((widget.drIntraction.clinicianDate.isNotEmpty &&
              //             widget.drIntraction.schoolDate.isEmpty) ||
              //         (widget.drIntraction.schoolDate.isNotEmpty &&
              //             widget.drIntraction.clinicianDate.isNotEmpty))
              //       Expanded(
              //         child: GestureDetector(
              //           onTap: () {
              //             setState(() {});
              //             // Slidable.of(context)!.close(
              //             //     duration: Duration(milliseconds: 1),
              //             //     curve: Curves.bounceIn);
              //             Navigator.pushNamed(
              //               context,
              //               Routes.addDrInteractionScreen,
              //               arguments: AddViewDrIntgeractionData(
              //                   rotationId: widget.drIntraction.rotationId,
              //                   rotationTitle: widget.drIntraction.rotationName,
              //                   isFromDashboard: widget.isFromDashboard,
              //                   drIntractionAction: DrIntractionAction.view,
              //                   drIntraction: widget.drIntraction),
              //             );
              //           },
              //           child: Container(
              //             decoration: BoxDecoration(
              //               color: Color(Hardcoded.blue),
              //             ),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Container(
              //                   child: SvgPicture.asset(
              //                     'assets/images/view_d.svg',
              //                   ),
              //                 ),
              //                 Text(
              //                   "View",
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .titleLarge!
              //                       .copyWith(
              //                         fontWeight: FontWeight.w500,
              //                         fontSize: 14,
              //                         color: Color(Hardcoded.white),
              //                       ),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //
              //     /// Delete
              //     //   Expanded(
              //     //     child: GestureDetector(
              //     //       onTap: () {
              //     //         Navigator.pushNamed(context, Routes.addDrInteractionScreen,
              //     //             arguments: AddViewDrIntgeractionData(
              //     //                 drIntractionAction: DrIntractionAction.edit,
              //     //                 drIntraction: null));
              //     //       },
              //     //       child: Container(
              //     //         decoration: BoxDecoration(
              //     //             color: Color(Hardcoded.blue),
              //     //             boxShadow: [
              //     //               BoxShadow(
              //     //                   blurRadius: 8,
              //     //                   color: Colors.grey.withOpacity(0.3),
              //     //                   spreadRadius: 1,
              //     //                   offset: const Offset(0, 3))
              //     //             ],
              //     //             borderRadius: BorderRadius.only(
              //     //               topRight: Radius.circular(20),
              //     //               bottomRight: Radius.circular(20),
              //     //             )),
              //     //         child: Column(
              //     //           mainAxisAlignment: MainAxisAlignment.center,
              //     //           children: [
              //     //             Container(
              //     //               child: SvgPicture.asset(
              //     //                 'assets/images/delete_d.svg',
              //     //               ),
              //     //             ),
              //     //             Text(
              //     //               "Delete",
              //     //               style:
              //     //                   Theme.of(context).textTheme.titleLarge!.copyWith(
              //     //                         fontWeight: FontWeight.w500,
              //     //                         fontSize: 14,
              //     //                         color: Color(Hardcoded.white),
              //     //                       ),
              //     //             )
              //     //           ],
              //     //         ),
              //     //       ),
              //     //     ),
              //     //   ),
              //   ],
              // ),
              // child:
              GestureDetector(
            onTap: () {
              //          if (slidableController.ratio==0)
              //   Slidable.of(context).openEndActionPane();
              // else
              //   Slidable.of(context).close();
            },
            child: Container(
              // padding: const EdgeInsets.all(15.0),
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
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: globalHeight * 0.076,
                              width: globalWidth * 0.12,
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
                                      widget.drIntraction.interactionDate!.day
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 19,
                                              color: widget.color),
                                    ),
                                    Text(
                                      getMonthString(widget
                                          .drIntraction.interactionDate!.month),
                                      //getMonthString(0303030),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13,
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
                                    widget.drIntraction.clinicianFullName??"",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Site unit : ',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Colors.black54),
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.drIntraction.hospitalUnitName??"",
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Time spent : ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: Colors.black54),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${widget.drIntraction.timeSpent} Minutes",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (widget.drIntraction.pointsAwarded!=null && widget.drIntraction.pointsAwarded!.isNotEmpty)
                              Container(
                                height: 70,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                              fontSize: 12,
                                              color: Color(Hardcoded.black),
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          // double.parse(widget.drIntraction.pointsAwarded).toStringAsFixed(1),
                                            widget.drIntraction.pointsAwarded!=null && widget.drIntraction.pointsAwarded!
                                                      .length >
                                                  3
                                              ? widget
                                                  .drIntraction.pointsAwarded!
                                                  .substring(0, 4)
                                              : widget
                                                  .drIntraction.pointsAwarded!
                                                  .substring(
                                                      0,
                                                      widget
                                                          .drIntraction
                                                          .pointsAwarded!
                                                          .length),
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 23,
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
                        const SizedBox(
                          height: 13,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'School Signature : ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          color: Colors.black54),
                                ),
                                if (widget.drIntraction.schoolDate
                                    .toString()
                                    .isNotEmpty)
                                  Text(
                                    convertDate(widget.drIntraction.schoolDate
                                        .toString()),
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
                            const SizedBox(
                              height: 10,
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
                                          fontSize: 10,
                                          color: Colors.black54),
                                ),
                                if (widget.drIntraction.clinicianDate
                                    .toString()
                                    .isNotEmpty)
                                  Text(
                                    convertDate(widget
                                        .drIntraction.clinicianDate
                                        .toString()),
                                    textAlign: TextAlign.center,
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
                        ),
                      ],
                    ),
                  ),
                  // (!widget.drIntraction.schoolDate.isNotEmpty && !widget.drIntraction.clinicianDate.isNotEmpty)
                  //     ?
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
                        child: (widget.drIntraction.clinicianDate!=null && widget.drIntraction.clinicianDate!.isEmpty)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  GestureDetector(
                                    // onTap: widget.onTap;
                                    // onTap: () async {
                                    //   Navigator.pushNamed(
                                    //     context,
                                    //     Routes.addDrInteractionScreen,
                                    //     arguments: AddViewDrIntgeractionData(
                                    //         rotationID:
                                    //             widget.drIntraction.rotationId,
                                    //         interactionDecCount:
                                    //             widget.interactionDecCount,
                                    //         rotationTitle: widget
                                    //             .drIntraction.rotationName,
                                    //         hospitalTitle: widget
                                    //             .drIntraction.hospitalsitesName,
                                    //         drIntractionAction:
                                    //             DrIntractionAction.edit,
                                    //         drIntraction: widget.drIntraction,
                                    //         isFromDashboard:
                                    //             widget.isFromDashboard),
                                    //   );
                                    //   await widget.pullToRefresh();
                                    // },
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        // left: globalWidth * 0.05,
                                        right: globalWidth * 0.01,
                                      ),
                                      child: VerticalDivider(
                                        thickness: 1,
                                      )),
                                  GestureDetector(
                                    onTap: widget.onTapDelete,
                                    child: Container(
                                      width: globalWidth * 0.4,
                                      color: Colors.transparent,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: globalWidth * 0.001,
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
                                                  'assets/images/trash1.svg',
                                                ),
                                              ),
                                              Text(
                                                "Delete",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      color: Color(0xFFFA0202),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                            // Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         crossAxisAlignment: CrossAxisAlignment.stretch,
                            //         children: [
                            //           GestureDetector(
                            //             onTap: () {
                            //               setState(() {});
                            //               Navigator.pushNamed(
                            //                 context,
                            //                 Routes.addDrInteractionScreen,
                            //                 arguments: AddViewDrIntgeractionData(
                            //                     rotationId:
                            //                         widget.drIntraction.rotationId,
                            //                     rotationTitle: widget
                            //                         .drIntraction.rotationName,
                            //                     drIntractionAction:
                            //                         DrIntractionAction.edit,
                            //                     drIntraction: widget.drIntraction,
                            //                     isFromDashboard:
                            //                         widget.isFromDashboard),
                            //               );
                            //             },
                            //             child: Container(
                            //               width: globalWidth * 0.9,
                            //               decoration: BoxDecoration(
                            //                 color: Colors.transparent,
                            //                 shape: BoxShape.rectangle,
                            //                 borderRadius: BorderRadius.only(
                            //                   bottomRight: Radius.circular(10.0),
                            //                   bottomLeft: Radius.circular(10.0),
                            //                 ),
                            //               ),
                            //               child: Align(
                            //                 alignment: Alignment.center,
                            //                 child: Padding(
                            //                   padding: EdgeInsets.only(
                            //                     right: globalWidth * 0.02,
                            //                   ),
                            //                   child: Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.center,
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.center,
                            //                     children: [
                            //                       Padding(
                            //                         padding: EdgeInsets.only(
                            //                           right: globalWidth * 0.02,
                            //                         ),
                            //                         child: SvgPicture.asset(
                            //                             "assets/images/Edit.svg"),
                            //                       ),
                            //                       Text(
                            //                         "Edit",
                            //                         style: Theme.of(context)
                            //                             .textTheme
                            //                             .bodyMedium!
                            //                             .copyWith(
                            //                               color: Color(0xFF01A750),
                            //                               fontSize: 13,
                            //                               fontWeight:
                            //                                   FontWeight.w500,
                            //                             ),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       )
                            : GestureDetector(
                                onTap: () {
                                  // Navigator.pushNamed(
                                  //   context,
                                  //   Routes.drInteractionDetailScreen,
                                  //   arguments: DrInteractionDetailData(
                                  //       rotationId:
                                  //           widget.drIntraction.rotationId,
                                  //       rotationTitle:
                                  //           widget.drIntraction.rotationName,
                                  //       isFromDashboard: widget.isFromDashboard,
                                  //       drIntractionAction:
                                  //           DrIntractionAction.view,
                                  //       drIntraction: widget.drIntraction),
                                  // );
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
            ),
            // ),
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
