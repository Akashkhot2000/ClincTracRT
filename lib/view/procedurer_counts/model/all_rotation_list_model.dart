// To parse this JSON data, do
//
//     final AllAllRotaionListModel = AllAllRotaionListModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../model/common_pager_model.dart';

AllRotationListModel AllRotationListModelFromJson(String str) =>
    AllRotationListModel.fromJson(json.decode(str));

class AllRotationListModel {
  AllRotationListModel({
    required this.data,
    required this.pager,
  });

  List<AllRotation> data;
  Pager pager;

  factory AllRotationListModel.fromJson(Map<String, dynamic> json) =>
      AllRotationListModel(
        data: List<AllRotation>.from(
            json["data"].map((x) => AllRotation.fromJson(x))),
        pager: Pager.fromJson(json['pager']),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pager": pager.toJson(),
      };
}

class AllRotation {
  AllRotation({
    required this.rotationId,
    required this.rotationTitle,
    required this.startDate,
    required this.endDate,
    required this.hospitalTitle,
    required this.hospitalId,
    required this.courseId,
    required this.courseTitle,
    required this.isClockIn,
    required this.attendanceId,
    required this.clockInDateTime,
  });

  String rotationId;
  String rotationTitle;
  DateTime startDate;
  DateTime endDate;
  String hospitalId;
  String hospitalTitle;
  String courseId;
  String courseTitle;
  int isClockIn;
  String attendanceId;
  DateTime? clockInDateTime;

  factory AllRotation.fromJson(Map<String, dynamic> json) {
    DateTime convertDateToUTC(String dateUtc) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
      var formattedTime = dateTime.toLocal();
      return formattedTime;
    }

    return AllRotation(
      rotationId: json["RotationId"],
      rotationTitle: json["Title"],
      startDate: convertDateToUTC(json["StartDate"]),
      endDate: convertDateToUTC(json["EndDate"]),
      hospitalId: json["HospitalId"],
      hospitalTitle: json["HospitalTitle"],
      courseId: json["CourseId"],
      courseTitle: json["CourseTitle"],
      isClockIn: json["IsClockIn"],
      attendanceId: json["AttendanceId"],
      clockInDateTime: json["ClockInDateTime"] != ""
          ? DateTime.parse(json["ClockInDateTime"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "RotationId": rotationId,
        "Title": rotationTitle,
        "StartDate": startDate.toIso8601String(),
        "EndDate": endDate.toIso8601String(),
        "HospitalId": hospitalId,
        "HospitalTitle": hospitalTitle,
        "CourseId": courseId,
        "CourseTitle": courseTitle,
        "IsClockIn": isClockIn,
        "AttendanceId": attendanceId,
        "ClockInDateTime": clockInDateTime,
      };
}
