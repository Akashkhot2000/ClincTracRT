// To parse this JSON data, do
//
//     final drInteractionList = drInteractionListFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

UserDrInteractionListModel drInteractionListFromJson(String str) =>
    UserDrInteractionListModel.fromJson(json.decode(str));

class UserDrInteractionListModel {
  UserDrInteractionListModel({
    required this.data,
    required this.pager,
  });

  UserDrInteractionData data;
  Pager pager;

  factory UserDrInteractionListModel.fromJson(Map<String, dynamic> json) =>
      UserDrInteractionListModel(
        data:UserDrInteractionData.fromJson(json["data"]),
        pager: Pager.fromJson(json["pager"]),
      );

}

class UserDrInteractionData {
  UserDrInteractionData({
     this.interactionDescriptionCount,
     this.interactionList,
  });

  String? interactionDescriptionCount;
  List<UserDrInteractionListData>? interactionList;

  factory UserDrInteractionData.fromJson(Map<String, dynamic> json) => UserDrInteractionData(
    interactionDescriptionCount: json["InteractionDescriptionCount"] != null ? json["InteractionDescriptionCount"] : null,
    interactionList:json["InteractionList"] != null ? List<UserDrInteractionListData>.from(json["InteractionList"]
        .map((x) => UserDrInteractionListData.fromJson(x as Map<String, dynamic>))) : null,
  );

}

class UserDrInteractionListData {
  UserDrInteractionListData({
     this.interactionId,
     this.interactionDate,
     this.studentId,
     this.studentFullName,
     this.clinicianId,
     this.clinicianFullName,
     this.rotationId,
     this.rotationName,
     this.hospitalsitesName,
     this.hospitalSiteUnitId,
     this.hospitalUnitName,
     this.timeSpent,
     this.pointsAwarded,
     this.drInteractionPoint,
     this.clinicianDate,
     this.schoolDate,
     this.studentResponse,
     this.clinicianResponse,
     this.schoolResponse,
     this.isExpire,
  });

  String? interactionId;
  String? interactionDate;
  String? studentId;
  String? studentFullName;
  String? clinicianId;
  String? clinicianFullName;
  String? rotationId;
  String? rotationName;
  String? hospitalsitesName;
  String? hospitalSiteUnitId;
  String? hospitalUnitName;
  String? timeSpent;
  String? pointsAwarded;
  String? drInteractionPoint;
  String? clinicianDate;
  String? schoolDate;
  String? studentResponse;
  String? clinicianResponse;
  String? schoolResponse;
  bool? isExpire;

  factory UserDrInteractionListData.fromJson(Map<String, dynamic> json) => UserDrInteractionListData(
    interactionId: json["InteractionId"] != null ? json["InteractionId"] : null,
    interactionDate: json["InteractionDate"] != null ? json["InteractionDate"] : null,
    studentId: json["StudentId"] != null ? json["StudentId"] : null ?? '',
    studentFullName: json["StudentFullName"] != null ? json["StudentFullName"] : null ?? '',
    clinicianId: json["ClinicianId"] != null ? json["ClinicianId"] : null ?? '',
    clinicianFullName: json["ClinicianFullName"] != null ? json["ClinicianFullName"] : null,
    rotationId: json["RotationId"] != null ? json["RotationId"] : null,
    rotationName: json["RotationName"] != null ? json["RotationName"] : null,
    hospitalsitesName: json["HospitalsitesName"] != null ? json["HospitalsitesName"] : null,
    hospitalSiteUnitId: json["HospitalSiteUnitId"] != null ? json["HospitalSiteUnitId"] : null,
    hospitalUnitName: json["HospitalUnitName"] != null ? json["HospitalUnitName"] : null,
    timeSpent: json["TimeSpent"] != null ? json["TimeSpent"] : null,
    pointsAwarded: json["PointsAwarded"] != null ? json["PointsAwarded"] : null,
    drInteractionPoint: json["DrInteractionPoint"] != null ? json["DrInteractionPoint"] : null,
    clinicianDate: json["ClinicianDate"] == null ? "" : json["ClinicianDate"],
    schoolDate: json["SchoolDate"] == null ? "" : json["SchoolDate"],
    studentResponse: json["StudentResponse"] != null ? json["StudentResponse"] : null,
    clinicianResponse: json["ClinicianResponse"] != null ? json["ClinicianResponse"] : null,
    schoolResponse: json["SchoolResponse"] != null ? json["SchoolResponse"] : null,
    isExpire: json["isExpire"] != null ? json["isExpire"] : null,
  );
}
