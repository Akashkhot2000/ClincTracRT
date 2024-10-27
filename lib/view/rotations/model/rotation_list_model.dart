// To parse this JSON data, do
//
//     final rotationListModel = rotationListModelFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';
import 'package:intl/intl.dart';

RotationListModel rotationListModelFromJson(String str) =>
    RotationListModel.fromJson(json.decode(str));

String rotationListModelToJson(RotationListModel data) =>
    json.encode(data.toJson());

class RotationListModel {
  RotationListModel({
    required this.data,
    required this.pager,
  });

  RotaionListData data;
  Pager pager;

  factory RotationListModel.fromJson(Map<String, dynamic> json) =>
      RotationListModel(
        data: RotaionListData.fromJson(json["data"]),
        pager: Pager.fromJson(json['pager']),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "pager": pager.toJson(),
      };
}

class RotaionListData {
  RotaionListData({
     this.pendingRotation,
     this.isClockedIn,
     this.rotationList,
  });

  bool? isClockedIn;
  List<PendingRotation>? pendingRotation;
  List<Rotation>? rotationList;

  factory RotaionListData.fromJson(Map<String, dynamic> json) =>
      RotaionListData(
        pendingRotation: List<PendingRotation>.from(
            json["pendingRotation"].map((x) => PendingRotation.fromJson(x ))),
        isClockedIn: json["isClockedIn"],
        rotationList: List<Rotation>.from(
            json["rotationList"].map((x) => Rotation.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "isClockedIn": isClockedIn,
        "rotationList": List<dynamic>.from(rotationList!.map((x) => x.toJson())),
      };
}

class Rotation {
  Rotation({
    required this.rotationId,
    required this.rotationTitle,
    required this.startDate,
    required this.endDate,
    required this.hospitalTitle,
    required this.hospitalSiteId,
    required this.isHospitalSiteActive,
    required this.courseId,
    required this.courseTitle,
    required this.isClockIn,
    required this.attendanceId,
    required this.clockInDateTime,
    required this.isExpired,
    this.isSchedule,
  });

  String rotationId;
  String rotationTitle;
  DateTime startDate;
  DateTime endDate;
  String hospitalTitle;
  String hospitalSiteId;
  bool isHospitalSiteActive;
  String courseId;
  String courseTitle;
  int isClockIn;
  String attendanceId;
  DateTime? clockInDateTime;
  bool isExpired;
  String? isSchedule;

  factory Rotation.fromJson(Map<String, dynamic> json) {
    DateTime convertDateToUTC(String dateUtc) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
      var formattedTime = dateTime.toLocal();
      return formattedTime;
    }

    return Rotation(
      rotationId: json["rotationId"],
      rotationTitle: json["RotationTitle"],
      startDate: convertDateToUTC(json["startDate"]),
      endDate: convertDateToUTC(json["endDate"]),
      hospitalTitle: json["hospitalTitle"],
      hospitalSiteId: json["hospitalSiteId"],
      isHospitalSiteActive: json["isHospitalSiteActive"],
      courseId: json["courseId"],
      courseTitle: json["courseTitle"],
      isClockIn: json["isClockIn"],
      attendanceId: json["attendanceId"],
      clockInDateTime:json["clockInDateTime"] != ""
          ? DateTime.parse(json["clockInDateTime"])
          : null,
      isExpired: json["isExpired"],
      isSchedule: json["isSchedule"],
    );
  }

  Map<String, dynamic> toJson() => {
        "rotationId": rotationId,
        "RotationTitle": rotationTitle,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "hospitalTitle": hospitalTitle,
        "hospitalSiteId": hospitalSiteId,
        "isHospitalSiteActive": isHospitalSiteActive,
        "courseId": courseId,
        "courseTitle": courseTitle,
        "isClockIn": isClockIn,
        "attendanceId": attendanceId,
        "clockInDateTime": clockInDateTime,
        "isExpired": isExpired,
        "isSchedule": isSchedule,
      };
}

class PendingRotation {
  String rotationId;
  String rotationTitle;
  DateTime startDate;
  DateTime endDate;
  String hospitalTitle;
  String courseId;
  String courseTitle;
  int isClockIn;
  String attendanceId;
  DateTime? clockInDateTime;
  bool isExpired;

  PendingRotation({
    required this.rotationId,
    required this.rotationTitle,
    required this.startDate,
    required this.endDate,
    required this.hospitalTitle,
    required this.courseId,
    required this.courseTitle,
    required this.isClockIn,
    required this.attendanceId,
    required this.clockInDateTime,
    required this.isExpired,
  });

  factory PendingRotation.fromJson(Map<String, dynamic> json) =>
      PendingRotation(
        rotationId: json["rotationId"],
        rotationTitle: json["RotationTitle"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        hospitalTitle: json["hospitalTitle"],
        courseId: json["courseId"],
        courseTitle: json["courseTitle"],
        isClockIn: json["isClockIn"],
        attendanceId: json["attendanceId"],
        clockInDateTime:json["clockInDateTime"] != ""
            ? DateTime.parse(json["clockInDateTime"])
            : null,
        isExpired: json["isExpired"],
      );

  Map<String, dynamic> toJson() => {
        "rotationId": rotationId,
        "RotationTitle": rotationTitle,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "hospitalTitle": hospitalTitle,
        "courseId": courseId,
        "courseTitle": courseTitle,
    "isClockIn": isClockIn,
    "attendanceId": attendanceId,
    "clockInDateTime": clockInDateTime,
        "isExpired": isExpired,
      };
}
