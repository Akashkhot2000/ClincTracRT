import 'dart:ui';

import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/view/procedurer_counts/model/all_rotation_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AllRotationContainer extends StatefulWidget {
  AllRotationContainer({
    super.key,
    required this.color,
    required this.duration,
    required this.endDate,
    required this.allRotation,
    this.containercolor,
  });

  ///color to paint on date circular Container
  final Color color;
  final AllRotation allRotation;
  final bool duration;
  final bool endDate;
  Color? containercolor;

  @override
  State<AllRotationContainer> createState() => _AllRotationContainerState();
}

class _AllRotationContainerState extends State<AllRotationContainer> {
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

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.all(15.0),
              child:
              Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                    children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height:globalHeight * 0.077,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: widget.containercolor == null
                              ? widget.color.withOpacity(0.2)
                              : widget.color,
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${widget.allRotation.startDate.day}",
                              // '14',
                              textAlign:
                              TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                fontWeight:
                                FontWeight.w600,
                                fontSize: 20,
                                color: widget.containercolor == null
                                    ? widget.color
                                    : Colors.white,
                              ),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            Text(
                              getMonthString(widget.allRotation.startDate.month),
                              textAlign:
                              TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                fontWeight:
                                FontWeight.w700,
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
                                widget.allRotation.rotationTitle,
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
                                      widget.allRotation.hospitalTitle,
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
                                      widget.allRotation.courseTitle,
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
                  ),],
                  ),),
                  SvgPicture.asset("assets/images/right_arrow.svg"),
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
                  //                     fontWeight: FontWeight.w500,
                  //                     fontSize: 10,
                  //                     color: Colors.black54),
                  //           ),
                  //           Text(
                  //             "${DateFormat('hh:mm aa').format(widget.allRotation.startDate)} to ${DateFormat('hh:mm aa').format(widget.allRotation.endDate)}",
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .titleLarge!
                  //                 .copyWith(
                  //                   fontWeight: FontWeight.w500,
                  //                   fontSize: 10,
                  //                 ),
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
                  //                     fontWeight: FontWeight.w500,
                  //                     fontSize: 10,
                  //                     color: Colors.black54),
                  //           ),
                  //           Text(
                  //             convertDate("${widget.allRotation.endDate} "),
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .titleLarge!
                  //                 .copyWith(
                  //                   fontWeight: FontWeight.w500,
                  //                   fontSize: 10,
                  //                 ),
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
