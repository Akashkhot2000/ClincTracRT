// To parse this JSON data, do
//
//     final StudDashboardModel = StudDashboardModelFromJson(jsonString);

import 'dart:convert';

StudDashboardModel StudDashboardModelFromJson(String str) => StudDashboardModel.fromJson(json.decode(str));

String StudDashboardModelToJson(StudDashboardModel data) => json.encode(data.toJson());

class StudDashboardModel {
  StudDashboardModel({
    required this.data,
  });

  StudDashboardListData data;

  factory StudDashboardModel.fromJson(Map<String, dynamic> json) => StudDashboardModel(
    data: StudDashboardListData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class StudDashboardListData {
  StudDashboardListData({
    required this.interactionCount,
    required this.checkoffCount,
    required this.journalCount,
    required this.procedureCount,
    required this.incidentCount,
    required this.attendanceCount,
    // required this.interactionAvgCount,
    // required this.journalAvgCount,
    // required this.procedureAvgCount,
    // required this.attendanceAvgCount,
    required this.loggedUserDetails,
  });

  String interactionCount;
  String checkoffCount;
  String journalCount;
  String procedureCount;
  String incidentCount;
  String attendanceCount;
  // int interactionAvgCount;
  // int journalAvgCount;
  // int procedureAvgCount;
  // double attendanceAvgCount;
  LoggedUserDetails loggedUserDetails;

  factory StudDashboardListData.fromJson(Map<String, dynamic> json) => StudDashboardListData(
    interactionCount: json["InteractionCount"],
    checkoffCount: json["CheckoffCount"],
    journalCount: json["JournalCount"],
    procedureCount: json["ProcedureCount"],
    incidentCount: json["IncidentCount"],
    attendanceCount: json["AttendanceCount"],
    // interactionAvgCount: json["InteractionAvgCount"],
    // journalAvgCount: json["JournalAvgCount"],
    // procedureAvgCount: json["ProcedureAvgCount"],
    // attendanceAvgCount: json["AttendanceAvgCount"]?.toDouble(),
    loggedUserDetails: LoggedUserDetails.fromJson(json["LoggedUserDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "InteractionCount": interactionCount,
    "CheckoffCount": checkoffCount,
    "JournalCount": journalCount,
    "ProcedureCount": procedureCount,
    "IncidentCount": incidentCount,
    "AttendanceCount": attendanceCount,
    // "InteractionAvgCount": interactionAvgCount,
    // "JournalAvgCount": journalAvgCount,
    // "ProcedureAvgCount": procedureAvgCount,
    // "AttendanceAvgCount": attendanceAvgCount,
    "LoggedUserDetails": loggedUserDetails.toJson(),
  };
}

class LoggedUserDetails {
  LoggedUserDetails({
    required this.loggedUserFirstName,
    required this.loggedUserMiddleName,
    required this.loggedUserLastName,
    required this.loggedUserEmail,
    required this.loggedUserProfile,
    required this.loggedUserSchoolName,
    required this.loggedUserSchoolImagePath,
  });

  String loggedUserFirstName;
  String loggedUserMiddleName;
  String loggedUserLastName;
  String loggedUserEmail;
  String loggedUserProfile;
  String loggedUserSchoolName;
  String loggedUserSchoolImagePath;

  factory LoggedUserDetails.fromJson(Map<String, dynamic> json) => LoggedUserDetails(
    loggedUserFirstName: json["LoggedUserFirstName"],
    loggedUserMiddleName: json["LoggedUserMiddleName"],
    loggedUserLastName: json["LoggedUserLastName"],
    loggedUserEmail: json["LoggedUserEmail"],
    loggedUserProfile: json["LoggedUserProfile"],
    loggedUserSchoolName: json["LoggedUserSchoolName"],
    loggedUserSchoolImagePath: json["LoggedUserSchoolImagePath"],
  );

  Map<String, dynamic> toJson() => {
    "LoggedUserFirstName": loggedUserFirstName,
    "LoggedUserMiddleName": loggedUserMiddleName,
    "LoggedUserLastName": loggedUserLastName,
    "LoggedUserEmail": loggedUserEmail,
    "LoggedUserProfile": loggedUserProfile,
    "LoggedUserSchoolName": loggedUserSchoolName,
    "LoggedUserSchoolImagePath": loggedUserSchoolImagePath,
  };
}
