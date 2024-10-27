// To parse this JSON data, do
//
//     final drInteractionList = drInteractionListFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

StudentDrInteractionData drInteractionListFromJson(String str) =>
    StudentDrInteractionData.fromJson(json.decode(str));

// String drInteractionListToJson(StudentDrInteractionData data) =>
//     json.encode(data.toJson());

class StudentDrInteractionData {
  StudentDrInteractionData({
    required this.data,
    required this.pager,
  });

  DrInteractionData data;
  Pager pager;

  factory StudentDrInteractionData.fromJson(Map<String, dynamic> json) =>
      StudentDrInteractionData(
        data:DrInteractionData.fromJson(json["data"]),
        pager: Pager.fromJson(json["pager"]),
      );

  // Map<String, dynamic> toJson() => {
  //       "data": List<dynamic>.from(data.map((x) => x.toJson())),
  //       "pager": List<dynamic>.from(data.map((x) => x.toJson())),
  //     };
}

class DrInteractionData {
  DrInteractionData({
    required this.interactionDescriptionCount,
    required this.interactionList,
  });

  String interactionDescriptionCount;
  List<UniDrInteractionList> interactionList;

  factory DrInteractionData.fromJson(Map<String, dynamic> json) => DrInteractionData(
    interactionDescriptionCount: json["InteractionDescriptionCount"],
    interactionList: List<UniDrInteractionList>.from(json["InteractionList"]
        .map((x) => UniDrInteractionList.fromJson(x as Map<String, dynamic>))),
  );

}

class UniDrInteractionList {
  UniDrInteractionList({
    required this.interactionId,
    required this.interactionDate,
    required this.clinicianId,
    required this.clinicianFullName,
    required this.rotationId,
    required this.rotationName,
    required this.hospitalsitesName,
    required this.hospitalSiteUnitId,
    required this.hospitalUnitName,
    required this.timeSpent,
    required this.pointsAwarded,
    required this.drInteractionPoint,
    required this.clinicianDate,
    required this.schoolDate,
    required this.studentResponse,
    required this.clinicianResponse,
    required this.schoolResponse,
    required this.isExpire,
  });

  String interactionId;
  DateTime interactionDate;
  String clinicianId;
  String clinicianFullName;
  String rotationId;
  String rotationName;
  String hospitalsitesName;
  String hospitalSiteUnitId;
  String hospitalUnitName;
  String timeSpent;
  String pointsAwarded;
  String drInteractionPoint;
  String clinicianDate;
  String schoolDate;
  String studentResponse;
  String clinicianResponse;
  String schoolResponse;
  bool isExpire;

  factory UniDrInteractionList.fromJson(Map<String, dynamic> json) => UniDrInteractionList(
        interactionId: json["InteractionId"],
        interactionDate: DateTime.parse(json["InteractionDate"]),
        clinicianId: json["ClinicianId"] ?? '',
        clinicianFullName: json["ClinicianFullName"],
        rotationId: json["RotationId"],
        rotationName: json["RotationName"],
        hospitalsitesName: json["HospitalsitesName"],
        hospitalSiteUnitId: json["HospitalSiteUnitId"],
        hospitalUnitName: json["HospitalUnitName"],
        timeSpent: json["TimeSpent"],
        pointsAwarded: json["PointsAwarded"],
        drInteractionPoint: json["DrInteractionPoint"],
        clinicianDate:
            json["ClinicianDate"] == null ? "" : json["ClinicianDate"],
        schoolDate: json["SchoolDate"] == null ? "" : json["SchoolDate"],
        studentResponse: json["StudentResponse"],
        clinicianResponse: json["ClinicianResponse"],
        schoolResponse: json["SchoolResponse"],
        isExpire: json["isExpire"],
      );

  Map<String, dynamic> toJson() => {
        "InteractionId": interactionId,
        "InteractionDate":
            "${interactionDate.year.toString().padLeft(4, '0')}-${interactionDate.month.toString().padLeft(2, '0')}-${interactionDate.day.toString().padLeft(2, '0')}",
        "ClinicianId": clinicianId,
        "ClinicianFullName": clinicianFullName,
        "RotationId": rotationId,
        "RotationName": rotationName,
        "HospitalsitesName": hospitalsitesName,
        "HospitalSiteUnitId": hospitalSiteUnitId,
        "HospitalUnitName": hospitalUnitName,
        "TimeSpent": timeSpent,
        "PointsAwarded": pointsAwarded,
        "DrInteractionPoint": drInteractionPoint,
        "ClinicianDate": clinicianDate,
        "SchoolDate": schoolDate,
        "StudentResponse": studentResponse,
        "ClinicianResponse": clinicianResponse,
        "SchoolResponse": schoolResponse,
        "isExpire": isExpire,
      };
}
