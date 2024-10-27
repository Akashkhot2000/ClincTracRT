import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

StudentPendingViewAttenListModel dailyJournalListResponseFromJson(
        String str) =>
    StudentPendingViewAttenListModel.fromJson(json.decode(str));

class StudentPendingViewAttenListModel {
  StudentPendingViewAttenListModel({
    this.data,
    this.pager,
  });

  List<StudentPendingViewAttendanceListData>? data;
  Pager? pager;

  factory StudentPendingViewAttenListModel.fromJson(
          Map<String, dynamic> json) =>
      StudentPendingViewAttenListModel(
        data: List<StudentPendingViewAttendanceListData>.from(json["data"].map(
            (x) => StudentPendingViewAttendanceListData.fromJson(
                x as Map<String, dynamic>))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class StudentPendingViewAttendanceListData {
  StudentPendingViewAttendanceListData({
    this.attendanceId,
    this.rotationId,
    this.rotationName,
    this.hospitalSiteId,
    this.hospitalName,
    this.studentFullName,
    this.studentId,
    this.courseName,
    this.clockInDateTime,
    this.clockOutDateTime,
    this.originalHours,
    this.approvedhours,
    this.clockInLongitude,
    this.clockInLattitude,
    this.clockOutLongitude,
    this.clockOutLattitude,
    this.notes,
    this.comment,
    this.status,
    this.isException,
  });

  String? attendanceId;
  String? rotationId;
  String? rotationName;
  String? studentFullName;
  String? studentId;
  String? courseName;
  String? hospitalSiteId;
  String? hospitalName;
  String? clockInDateTime;
  String? clockOutDateTime;
  String? originalHours;
  String? approvedhours;
  String? clockInLongitude;
  String? clockInLattitude;
  String? clockOutLongitude;
  String? clockOutLattitude;
  String? notes;
  String? comment;
  bool? status;
  bool? isException;

  factory StudentPendingViewAttendanceListData.fromJson(
          Map<String, dynamic> json) =>
      StudentPendingViewAttendanceListData(
        attendanceId:
            json["AttendanceId"] != null ? json["AttendanceId"] : null,
        rotationId: json["RotationId"] != null ? json["RotationId"] : null,
        rotationName:
            json["RotationName"] != null ? json["RotationName"] : null,
        hospitalSiteId:
            json["HospitalSiteId"] != null ? json["HospitalSiteId"] : null,
        hospitalName:
            json["HospitalName"] != null ? json["HospitalName"] : null,
        studentFullName:
            json["StudentFullName"] != null ? json["StudentFullName"] : null,
        studentId: json["StudentId"] != null ? json["StudentId"] : null,
        courseName: json["CourseName"] != null ? json["CourseName"] : null,
        clockInDateTime:
            json["ClockInDateTime"] != null ? json["ClockInDateTime"] : null,
        clockOutDateTime:
            json["ClockOutDateTime"] != null ? json["ClockOutDateTime"] : null,
        originalHours:
            json["Orignalhours"] != null ? json["Orignalhours"] : null,
        approvedhours:
            json["Approvedhours"] != null ? json["Approvedhours"] : null,
        clockInLongitude:
            json["ClockInLongitude"] != null ? json["ClockInLongitude"] : null,
        clockInLattitude:
            json["ClockInLattitude"] != null ? json["ClockInLattitude"] : null,
        clockOutLongitude: json["ClockOutLongitude"] != null
            ? json["ClockOutLongitude"]
            : null,
        clockOutLattitude: json["ClockOutLattitude"] != null
            ? json["ClockOutLattitude"]
            : null,
        notes: json["Notes"] != null ? json["Notes"] : null,
        comment: json["Comment"] != null ? json["Comment"] : null,
        status: json["status"] != null ? json["status"] : null,
        isException: json["IsException"] != null ? json["IsException"] : null,
      );
}
