// To parse this JSON data, do
//
//     final attendanceResponseDart = attendanceResponseDartFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

AttendanceResponseDart attendanceResponseDartFromJson(String str) =>
    AttendanceResponseDart.fromJson(json.decode(str));

class AttendanceResponseDart {
  AttendanceResponseDart({
    required this.data,
    required this.pager,
  });

  List<AttendanceData> data;
  Pager pager;

  factory AttendanceResponseDart.fromJson(Map<String, dynamic> json) =>
      AttendanceResponseDart(
        data: List<AttendanceData>.from(
            json["data"].map((x) => AttendanceData.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class AttendanceData {
  AttendanceData({
    required this.attendanceId,
    required this.rotationId,
    required this.rotationName,
    required this.courseName,
    required this.hospitalSiteId,
    required this.hospitalSiteName,
    this.clockInDateTime,
    this.clockOutDateTime,
    required this.orignalhours,
    required this.approvedhours,
    required this.clockInLongitude,
    required this.clockInLattitude,
    required this.clockOutLongitude,
    required this.clockOutLattitude,
    required this.notes,
    required this.comment,
    required this.status,
    required this.isException,
  });

  String attendanceId;
  String rotationId;
  String rotationName;
  String courseName;
  String hospitalSiteId;
  String hospitalSiteName;
  DateTime? clockInDateTime;
  DateTime? clockOutDateTime;
  String orignalhours;
  String approvedhours;
  String clockInLongitude;
  String clockInLattitude;
  String clockOutLongitude;
  String clockOutLattitude;
  String notes;
  String comment;
  bool status;
  bool isException;

  factory AttendanceData.fromJson(Map<String, dynamic> json) => AttendanceData(
        attendanceId: json["AttendanceId"],
        rotationId: json["rotationId"],
        rotationName: json["RotationName"],
        courseName: json["CourseName"],
        hospitalSiteId: json["HospitalSiteId"],
        hospitalSiteName: json["HospitalSiteName"],
        clockInDateTime: json["ClockInDateTime"] != ""
            ? DateTime.parse(json["ClockInDateTime"])
            : null,
        clockOutDateTime: json["ClockOutDateTime"] != ""
            ? DateTime.parse(json["ClockOutDateTime"])
            : null,
        orignalhours: json["Orignalhours"],
        approvedhours: json["Approvedhours"],
    clockInLongitude: json["ClockInLongitude"],
    clockInLattitude: json["ClockInLattitude"],
    clockOutLongitude: json["ClockOutLongitude"],
    clockOutLattitude: json["ClockOutLattitude"],
        notes: json["Notes"],
        comment:json["Comment"],
        status: json["status"],
        isException: json["IsException"],
      );
}
