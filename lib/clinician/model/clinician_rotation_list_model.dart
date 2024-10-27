import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

ClinicianRotationListModel dailyJournalListResponseFromJson(String str) =>
    ClinicianRotationListModel.fromJson(json.decode(str));

class ClinicianRotationListModel {
  ClinicianRotationListModel({
    this.data,
    this.pager,
  });

  List<ClinicianRotationDetailListData>? data;
  Pager? pager;

  factory ClinicianRotationListModel.fromJson(Map<String, dynamic> json) =>
      ClinicianRotationListModel(
        data: List<ClinicianRotationDetailListData>.from(json["data"].map((x) => ClinicianRotationDetailListData.fromJson(x as Map<String, dynamic>))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class ClinicianRotationDetailListData {
  ClinicianRotationDetailListData({
    this.journalId,
    this.rotationId,
    this.rotationName,
    this.hospitalSiteId,
    this.hospitalName,
    this.courseId,
    this.courseName,
    this.location,
    this.startDate,
    this.endDate,
    this.duration,
    this.studentCount,


  });

  String? journalId;
  String? rotationId;
  String? rotationName;
  String? courseId;
  String? courseName;
  String? hospitalSiteId;
  String? hospitalName;
  String? location;
  String? startDate;
  String? endDate;
  String? duration;
  String? studentCount;

  factory ClinicianRotationDetailListData.fromJson(Map<String, dynamic> json) =>
      ClinicianRotationDetailListData(
        rotationId: json["RotationId"] != null ? json["RotationId"] : null,
        rotationName: json["RotationName"] != null ? json["RotationName"] : null,
        hospitalSiteId: json["HospitalSiteId"] != null ? json["HospitalSiteId"] : null,
        hospitalName: json["HospitalName"] != null ? json["HospitalName"] : null,
        courseId: json["CourseId"] != null ? json["CourseId"] : null,
        courseName: json["CourseName"] != null ? json["CourseName"] : null,
        location: json["Location"] != null ? json["Location"] : null,
        startDate: json["StartDate"] != null ? json["StartDate"] : null,
        endDate: json["EndDate"] != null ? json["EndDate"] : null,
        duration: json["Duration"] != null ? json["Duration"] : null,
        studentCount: json["StudentCount"] != null ? json["StudentCount"] : null,


      );
}
