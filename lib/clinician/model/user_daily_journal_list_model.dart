import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

DailyJournalListModel dailyJournalListResponseFromJson(String str) =>
    DailyJournalListModel.fromJson(json.decode(str));

class DailyJournalListModel {
  DailyJournalListModel({
     this.data,
    this.pager,
  });

  JournalData? data;
  Pager? pager;

  factory DailyJournalListModel.fromJson(Map<String, dynamic> json) =>
      DailyJournalListModel(
        data: JournalData.fromJson(json["data"]),
        pager: Pager.fromJson(json["pager"]),
      );
}

class JournalData {
  JournalData({
     this.journalDescriptionCount,
     this.journalListData,
  });

  String? journalDescriptionCount;
  List<JournalListData>? journalListData;

  factory JournalData.fromJson(Map<String, dynamic> json) => JournalData(
    journalDescriptionCount: json["JournalDescriptionCount"] != null ? json["JournalDescriptionCount"] : null,
    journalListData:  json["JournalList"] != null ?List<JournalListData>.from(json["JournalList"].map((x) => JournalListData.fromJson(x as Map<String, dynamic>))) : null,
  );

// Map<String, dynamic> toJson() => {
//       "JournalDescriptionCount": journalDescriptionCount,
//       "JournalList": List<dynamic>.from(journalListData.map((x) => x.toJson())),
//     };
}

class JournalListData {
  JournalListData({
     this.journalId,
     this.rotationId,
     this.rotationName,
     this.studentFullName,
     this.hospitalSiteUnitId,
     this.hospitalSiteunitName,
     this.hospitalSiteId,
     this.hospitalName,
     this.journalDate,
     this.schoolResponse,
     this.clinicianResponse,
     this.studentResponseForEdit,
     this.schoolResponseForEdit,
     this.clinicianResponseForEdit,
  });

  String? journalId;
  String? rotationId;
  String? rotationName;
  String? studentFullName;
  String? hospitalSiteUnitId;
  String? hospitalSiteunitName;
  String? hospitalSiteId;
  String? hospitalName;
  String? journalDate;
  bool? schoolResponse;
  bool? clinicianResponse;
  String? studentResponseForEdit;
  String? schoolResponseForEdit;
  String? clinicianResponseForEdit;

  factory JournalListData.fromJson(Map<String, dynamic> json) =>
      JournalListData(
        journalId: json["JournalId"] != null ? json["JournalId"] : null,
        rotationId: json["RotationId"] != null ? json["RotationId"] : null,
        rotationName: json["RotationName"] != null ? json["RotationName"] : null,
        studentFullName: json["StudentFullName"] != null ? json["StudentFullName"] : null,
        hospitalSiteUnitId: json["HospitalSiteUnitId"] != null ? json["HospitalSiteUnitId"] : null,
        hospitalSiteunitName: json["HospitalSiteunitName"] != null ? json["HospitalSiteunitName"] : null,
        hospitalSiteId: json["HospitalSiteId"] != null ? json["HospitalSiteId"] : null,
        hospitalName: json["HospitalName"] != null ? json["HospitalName"] : null,
        journalDate: json["JournalDate"] != null ? json["JournalDate"] : null,
        schoolResponse: json["SchoolResponse"] != null ? json["SchoolResponse"] : null,
        clinicianResponse: json["ClinicianResponse"] != null ? json["ClinicianResponse"] : null,
        studentResponseForEdit: json["StudentResponseForEdit"] != null ? json["StudentResponseForEdit"] : null,
        schoolResponseForEdit: json["SchoolResponseForEdit"] != null ? json["SchoolResponseForEdit"] : null,
        clinicianResponseForEdit: json["ClinicianResponseForEdit"] != null ? json["ClinicianResponseForEdit"] : null,
      );
}
