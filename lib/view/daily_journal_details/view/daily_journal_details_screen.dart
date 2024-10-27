import 'dart:developer';

import 'package:clinicaltrac/api/data_locator.dart';
import 'package:clinicaltrac/api/data_service.dart';
import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/hardcoded.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/hive/user_login_response_hive.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/app_constant.dart';
import 'package:clinicaltrac/model/data_response_model.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_details_response.dart';
import 'package:clinicaltrac/view/daily_journal_details/model/journal_model.dart';
import 'package:clinicaltrac/view/login/login_bottom_screen.dart';
import 'package:clinicaltrac/view/login/model/user_login_response_data.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class DailyJournalDetailScreen extends StatefulWidget {
  DailyJournalDetailsResponse detailsData;

  final String JournalId;
  final UserLoginResponse user;

  // final String accessTocken;
  // final DailyJournalViewType Viewtype;

  DailyJournalDetailScreen(
      {Key? key,
      required this.JournalId,
      required this.user,
      required this.detailsData,
      // required this.Viewtype
      })
      : super(key: key);

  @override
  State<DailyJournalDetailScreen> createState() =>
      _DailyJournalDetailScreenState();
}

class _DailyJournalDetailScreenState extends State<DailyJournalDetailScreen> {
  List<String> rotations = [];
  bool isDataLoading = true;

  // DailyJournalDetailsResponse dailyJournalDetailsResponse = DailyJournalDetailsResponse();
  @override
  void initState() {
    setValue();
    super.initState();
  }

  void setValue() async {
    setState(() {
      isDataLoading = false;
    });
    Box<UserLoginResponseHive>? box = Boxes.getUserInfo();
    // switch (widget.Viewtype) {
    //   case DailyJournalViewType.view:
        JournalDetailsRequest journalDetailsRequest = JournalDetailsRequest(
            accessToken:  box.get(Hardcoded.hiveBoxKey)!.accessToken,
            userId:  box.get(Hardcoded.hiveBoxKey)!.loggedUserId,
            journalId: widget.JournalId);
        final DataService dataService = locator();
        DataResponseModel dataResponseModel =
            await dataService.getDailyJournalDetails(journalDetailsRequest);
        DailyJournalDetailsResponse response =
            DailyJournalDetailsResponse.fromJson(dataResponseModel.data);
        setState(() {
          widget.detailsData.data = response.data;
        });
        setState(() {
          isDataLoading = false;
        });
        // break;
        // setState(() {
        //   isDataLoading = false;
        // });
    // }
  }

  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }

  String convertDateToUTC(String dateUtc) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
    String formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
    var formattedTime = formattedDate;
    return formattedTime;
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
              visible: !isDataLoading,
              replacement: common_loader(),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Journal Date : ${widget.detailsData.data.journalDate.isNotEmpty ? convertDateToUTC(widget.detailsData.data.journalDate) : ''}",
                        // "Journal Date :  ${convertDate(widget.detailsData.data.journalDate)}",
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
                                    "${widget.detailsData.data.rotationName}",
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
                                    "${widget.detailsData.data.hospitalSiteunitName}",
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
                              "${widget.detailsData.data.hospitalName}",
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
                          // ],),
                          // Column(children: [
                          //   Text(
                          //     "Rotation",
                          //     maxLines: 1,
                          //     overflow:
                          //     TextOverflow.ellipsis,
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodyMedium!
                          //         .copyWith(
                          //         fontSize: 12,
                          //         fontWeight:
                          //         FontWeight.w500,
                          //         color: Color(
                          //             0xFF868998)),
                          //   ),
                          //   Text(
                          //     "${widget.detailsData.data.rotationName}",
                          //     maxLines: 1,
                          //     overflow:
                          //     TextOverflow.ellipsis,
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodyMedium!
                          //         .copyWith(
                          //       fontSize: 12,
                          //       fontWeight:
                          //       FontWeight.w500,),
                          //   ),
                          // ],),
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
                      widget.detailsData.data.studentResponseForEdit.isEmpty? Container():Text(
                        "${widget.detailsData.data.studentResponseForEdit}",
                        maxLines: widget.detailsData.data.studentResponseForEdit.length,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                        !widget.detailsData.data.clinicianResponse
                            ? "Waiting for clinician response"
                            : "${widget.detailsData.data.clinicianResponseForEdit}",
                        maxLines: !widget.detailsData.data.clinicianResponse ? 1
                            : widget.detailsData.data.clinicianResponseForEdit.length,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: !widget.detailsData.data.clinicianResponse
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
                        !widget.detailsData.data.schoolResponse
                            ? "Waiting for school response"
                            : "${widget.detailsData.data.schoolResponseForEdit}",
                        maxLines:  !widget.detailsData.data.schoolResponse
                            ? 1 : widget.detailsData.data.schoolResponseForEdit.length,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: !widget.detailsData.data.schoolResponse
                                  ? Color(0xFF868998)
                                  : Colors.black,
                            ),
                      ),
                      SizedBox(height: globalHeight * 0.02,)
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
