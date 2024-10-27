import 'package:clinicaltrac/common/common_app_bar.dart';
import 'package:clinicaltrac/common/common_loader.dart';
import 'package:clinicaltrac/common/enums.dart';
import 'package:clinicaltrac/common/nointernetwidget.dart';
import 'package:clinicaltrac/main.dart';
import 'package:clinicaltrac/model/hospital_unit_list.dart';
import 'package:clinicaltrac/model/roatation_list.dart';
import 'package:clinicaltrac/view/dr_intraction/model/clinician_list_data.dart';
import 'package:clinicaltrac/view/dr_intraction/model/dr_interaction_list_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrInteractionDetailScreen extends StatefulWidget {
   DrInteractionDetailScreen({Key? key, required this.drIntractionAction,
    this.drIntraction,
    required this.clinicianDataList,
    required this.hospitalUnitListResponseDart,
    required this.rotationListStudentJournal,
    required this.isFromDashboard,
    required this.rotationID,
    required this.rotationTitle}) : super(key: key);

  final DrIntractionAction drIntractionAction;
  final ClinicianDataList clinicianDataList;
  UniDrInteractionList? drIntraction;
  final HospitalUnitListResponseDart hospitalUnitListResponseDart;
  final RotationListStudentJournal rotationListStudentJournal;
  final bool isFromDashboard;
  final String rotationTitle;
  final String rotationID;
  @override
  State<DrInteractionDetailScreen> createState() => _DrInteractionDetailScreenState();
}

class _DrInteractionDetailScreenState extends State<DrInteractionDetailScreen> {
  String convertDate(String input) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime now = dateFormat.parse(input);
    String formattedDate = DateFormat('MMM dd, yyyy').format(now);
    // String formattedTime = DateFormat('hh:mm aa').format(now);
    return formattedDate;
  }
  @override
  Widget build(BuildContext context) {
    return  NoInternet(
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
          // child: Visibility(
          //   visible: !isDataLoading,
          //   replacement: common_loader(),
            child: Container(
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Interaction Date :  ${DateFormat('MMM dd, yyyy').format(widget.drIntraction!.interactionDate)}",
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
                                  "${widget.drIntraction!.clinicianFullName}",
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
                                  "${widget.drIntraction!.rotationName}",
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
                                  "${widget.drIntraction!.hospitalUnitName}",
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
                                  "${widget.drIntraction!.timeSpent}",
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
                            ],),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: globalHeight * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(
                            "Clinician Sign Date",
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w500,
                                color: Color(
                                    0xFF868998)),
                          ),
                         Text(
                           widget.drIntraction!.clinicianDate.isNotEmpty ? "${convertDate(widget.drIntraction!.clinicianDate)}" :'',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w500,),
                          ),
                        ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "School Sign Date",
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
                              widget.drIntraction!.schoolDate.isNotEmpty ? "${convertDate(widget.drIntraction!.schoolDate)}" :'',
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
                    widget.drIntraction!.studentResponse.isEmpty ? Container() : Text(
                      "${widget.drIntraction!.studentResponse}",
                      maxLines: widget.drIntraction!.studentResponse.isEmpty ? 1 : widget.drIntraction!.studentResponse.length,
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
                      widget.drIntraction!.clinicianResponse.isEmpty
                          ? "Waiting for clinician response"
                          : "${widget.drIntraction!.clinicianResponse}",
                      maxLines: widget.drIntraction!.clinicianResponse.isEmpty ? 1: widget.drIntraction!.clinicianResponse.length,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.drIntraction!.clinicianResponse.isEmpty
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
                      widget.drIntraction!.schoolResponse.isEmpty
                          ? "Waiting for school response"
                          : "${widget.drIntraction!.schoolResponse}",
                      maxLines: widget.drIntraction!.schoolResponse.isEmpty ? 1 : widget.drIntraction!.schoolResponse.length,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: widget.drIntraction!.schoolResponse.isEmpty
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
      // ),
    );
  }
}
