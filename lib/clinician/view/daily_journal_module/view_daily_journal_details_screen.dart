import 'dart:developer';

import 'package:clinicaltrac/clinician/model/user_daily_journal_list_model.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewDailyJournalDetailScreen extends StatefulWidget {
  JournalListData journalListData;

  final String journalId;

  ViewDailyJournalDetailScreen({
    Key? key,
    required this.journalId,
    // required this.user,
    required this.journalListData,
    // required this.Viewtype
  }) : super(key: key);

  @override
  State<ViewDailyJournalDetailScreen> createState() =>
      _ViewDailyJournalDetailScreenState();
}

class _ViewDailyJournalDetailScreenState
    extends State<ViewDailyJournalDetailScreen> {
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
            "View Daily Journal",
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
                      "Journal Date : ${widget.journalListData.journalDate! != "" ? dateConvert("${widget.journalListData.journalDate!}") : ''}",
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
                                  "${widget.journalListData.rotationName}",
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
                                  "${widget.journalListData.hospitalSiteunitName}",
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
                            "${widget.journalListData.hospitalName}",
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
                      "Student Journal Entry : ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    widget.journalListData.studentResponseForEdit!.isEmpty
                        ? Container()
                        : Text(
                            "${widget.journalListData.studentResponseForEdit}",
                            maxLines: widget
                                .journalListData.studentResponseForEdit!.length,
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
                      !widget.journalListData.clinicianResponse!
                          ? "Waiting for clinician response"
                          : "${widget.journalListData.clinicianResponseForEdit}",
                      maxLines: !widget.journalListData.clinicianResponse!
                          ? 1
                          : widget
                              .journalListData.clinicianResponseForEdit!.length,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: !widget.journalListData.clinicianResponse!
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
                      !widget.journalListData.schoolResponse!
                          ? "Waiting for school response"
                          : "${widget.journalListData.schoolResponseForEdit}",
                      maxLines: !widget.journalListData.schoolResponse!
                          ? 1
                          : widget
                              .journalListData.schoolResponseForEdit!.length,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: !widget.journalListData.schoolResponse!
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
