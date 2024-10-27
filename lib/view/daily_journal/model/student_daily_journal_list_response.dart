import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

StudentRotationListResponse studentRotationListResponseFromJson(String str) =>
    StudentRotationListResponse.fromJson(json.decode(str));

class StudentRotationListResponse {
  StudentRotationListResponse({
    required this.data,
    this.pageInfo,
  });

  JournalData data;
  Pager? pageInfo;

  factory StudentRotationListResponse.fromJson(Map<String, dynamic> json) =>
      StudentRotationListResponse(
        data: JournalData.fromJson(json["data"]),
        pageInfo: Pager.fromJson(json["pager"]),
      );
}

class JournalData {
  JournalData({
    required this.journalDescriptionCount,
    required this.journalListData,
  });

  String journalDescriptionCount;
  List<JournalListData> journalListData;

  factory JournalData.fromJson(Map<String, dynamic> json) => JournalData(
    journalDescriptionCount: json["JournalDescriptionCount"],
    journalListData: List<JournalListData>.from(json["JournalList"]
        .map((x) => JournalListData.fromJson(x as Map<String, dynamic>))),
  );

// Map<String, dynamic> toJson() => {
//       "JournalDescriptionCount": journalDescriptionCount,
//       "JournalList": List<dynamic>.from(journalListData.map((x) => x.toJson())),
//     };
}

class JournalListData {
  JournalListData({
    required this.journalId,
    required this.rotationId,
    required this.rotationName,
    required this.hospitalSiteUnitId,
    required this.hospitalSiteunitName,
    required this.hospitalSiteId,
    required this.hospitalName,
    required this.journalDate,
    required this.schoolResponse,
    required this.clinicianResponse,
    required this.studentResponseForEdit,
    required this.schoolResponseForEdit,
    required this.clinicianResponseForEdit,
  });

  String journalId;
  String rotationId;
  String rotationName;
  String hospitalSiteUnitId;
  String hospitalSiteunitName;
  String hospitalSiteId;
  String hospitalName;
  DateTime journalDate;
  bool schoolResponse;
  bool clinicianResponse;
  String studentResponseForEdit;
  String schoolResponseForEdit;
  String clinicianResponseForEdit;

  factory JournalListData.fromJson(Map<String, dynamic> json) =>
      JournalListData(
        journalId: json["JournalId"],
        rotationId: json["RotationId"],
        rotationName: json["RotationName"],
        hospitalSiteUnitId: json["HospitalSiteUnitId"],
        hospitalSiteunitName: json["HospitalSiteunitName"],
        hospitalSiteId: json["HospitalSiteId"],
        hospitalName: json["HospitalName"],
        journalDate: DateTime.parse(json["JournalDate"]),
        schoolResponse: json["SchoolResponse"],
        clinicianResponse: json["ClinicianResponse"],
        studentResponseForEdit: json["StudentResponseForEdit"],
        schoolResponseForEdit: json["SchoolResponseForEdit"],
        clinicianResponseForEdit: json["ClinicianResponseForEdit"],
      );
}
