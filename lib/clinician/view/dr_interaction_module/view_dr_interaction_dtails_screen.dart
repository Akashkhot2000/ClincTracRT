import 'dart:developer';

import 'package:clinicaltrac/clinician/model/user_daily_journal_list_model.dart';
import 'package:clinicaltrac/clinician/model/user_dr_interaction_list_model.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewDrInteractionDetailScreen extends StatefulWidget {
  UserDrInteractionListData userDrInteractionListData;

  final String interactionId;

  ViewDrInteractionDetailScreen({
    Key? key,
    required this.interactionId,
    // required this.user,
    required this.userDrInteractionListData,
    // required this.Viewtype
  }) : super(key: key);

  @override
  State<ViewDrInteractionDetailScreen> createState() =>
      _ViewDrInteractionDetailScreenState();
}

class _ViewDrInteractionDetailScreenState
    extends State<ViewDrInteractionDetailScreen> {
  List<String> rotations = [];
  bool isDataLoading = true;

  @override
  void initState() {
    super.initState();
  }

  String dateConvert(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    return '${formattedDate} ';
  }

  @override
  Widget build(BuildContext context) {
    return NoInternet(
      child: Scaffold(
        appBar: CommonAppBar(
          titles: Text(
            "View Dr. Interaction",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Visibility(
            visible: isDataLoading,
            replacement: common_loader(),
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Interaction Date : ${widget.userDrInteractionListData.interactionDate! != "" ? dateConvert("${widget.userDrInteractionListData.interactionDate!}") : ''}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: globalHeight * 0.01),
                    SizedBox(
                      width: globalWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Clinician",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              SizedBox(
                                width: globalWidth * 0.4,
                                child: Text(
                                  "${widget.userDrInteractionListData.clinicianFullName}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hospital Site Unit",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              SizedBox(
                                width: globalWidth * 0.4,
                                child: Text(
                                  "${widget.userDrInteractionListData.hospitalUnitName}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: globalHeight * 0.01),
                    SizedBox(
                      width: globalWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rotation",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              SizedBox(
                                width: globalWidth * 0.4,
                                child: Text(
                                  "${widget.userDrInteractionListData.rotationName}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Clinician Sign Date",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              SizedBox(
                                width: globalWidth * 0.4,
                                child: Text(
                                  "${dateConvert("${widget.userDrInteractionListData.clinicianDate!}")}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: globalHeight * 0.01),
                    SizedBox(
                      width: globalWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Time Spent",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              SizedBox(
                                width: globalWidth * 0.4,
                                child: Text(
                                  "${widget.userDrInteractionListData.timeSpent}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Points Awarded",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF868998)),
                              ),
                              SizedBox(
                                width: globalWidth * 0.4,
                                child: Text(
                                  "${widget.userDrInteractionListData.pointsAwarded}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.01,
                    ),
                    // Row(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hospital Site",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF868998)),
                        ),
                        SizedBox(
                          width: globalWidth * 0.9,
                          child: Text(
                            "${widget.userDrInteractionListData.hospitalsitesName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Text(
                      "Student Response : ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    widget.userDrInteractionListData.studentResponse!.isEmpty
                        ? Container()
                        : Text(
                      "${widget.userDrInteractionListData.studentResponse}",
                      maxLines: widget
                          .userDrInteractionListData.studentResponse!.length,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Text(
                      "Clinician Response : ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.userDrInteractionListData.clinicianResponse!.isEmpty
                          ? "Waiting for clinician response"
                          : "${widget.userDrInteractionListData.clinicianResponse}",
                      maxLines: widget.userDrInteractionListData.clinicianResponse!.isEmpty
                          ? 1
                          : widget
                          .userDrInteractionListData.clinicianResponse!.length,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.userDrInteractionListData.clinicianResponse!.isEmpty
                            ? Color(0xFF868998)
                            : Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Text(
                      "School Response : ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.userDrInteractionListData.schoolResponse!.isEmpty
                          ? "Waiting for school response"
                          : "${widget.userDrInteractionListData.studentResponse}",
                      maxLines: widget.userDrInteractionListData.schoolResponse!.isEmpty
                          ? 1
                          : widget
                          .userDrInteractionListData.studentResponse!.length,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.userDrInteractionListData.schoolResponse!.isEmpty
                            ? Color(0xFF868998)
                            : Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.02,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
