// To parse this JSON data, do
//
//     final userDashBoardModel = userDashBoardModelFromJson(jsonString);

import 'dart:convert';

UserDashBoardModel userDashBoardModelFromJson(String str) => UserDashBoardModel.fromJson(json.decode(str));

String userDashBoardModelToJson(UserDashBoardModel data) => json.encode(data.toJson());

class UserDashBoardModel {
    UserDashBoardModel({
        required this.data,
    });

    DashBoardData data;

    factory UserDashBoardModel.fromJson(Map<String, dynamic> json) => UserDashBoardModel(
        data: DashBoardData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class DashBoardData {
    DashBoardData({
        required this.interactionCount,
        required this.checkoffCount,
        required this.journalCount,
        required this.procedureCount,
        required this.incidentCount,
        required this.attendanceCount,
        required this.interactionAvgCount,
        required this.journalAvgCount,
        required this.procedureAvgCount,
        required this.attendanceAvgCount,
        required this.loggedUserDetails,
    });

    String interactionCount;
    String checkoffCount;
    String journalCount;
    String procedureCount;
    String incidentCount;
    String attendanceCount;
    int interactionAvgCount;
    int journalAvgCount;
    int procedureAvgCount;
    double attendanceAvgCount;
    List<LoggedUserDetail> loggedUserDetails;

    factory DashBoardData.fromJson(Map<String, dynamic> json) => DashBoardData(
        interactionCount: json["InteractionCount"],
        checkoffCount: json["CheckoffCount"],
        journalCount: json["JournalCount"],
        procedureCount: json["ProcedureCount"],
        incidentCount: json["IncidentCount"],
        attendanceCount: json["AttendanceCount"],
        interactionAvgCount: json["InteractionAvgCount"],
        journalAvgCount: json["JournalAvgCount"],
        procedureAvgCount: json["ProcedureAvgCount"],
        attendanceAvgCount: json["AttendanceAvgCount"]?.toDouble(),
        loggedUserDetails: List<LoggedUserDetail>.from(json["LoggedUserDetails"].map((x) => LoggedUserDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "InteractionCount": interactionCount,
        "CheckoffCount": checkoffCount,
        "JournalCount": journalCount,
        "ProcedureCount": procedureCount,
        "IncidentCount": incidentCount,
        "AttendanceCount": attendanceCount,
        "InteractionAvgCount": interactionAvgCount,
        "JournalAvgCount": journalAvgCount,
        "ProcedureAvgCount": procedureAvgCount,
        "AttendanceAvgCount": attendanceAvgCount,
        "LoggedUserDetails": List<dynamic>.from(loggedUserDetails.map((x) => x.toJson())),
    };
}

class LoggedUserDetail {
    LoggedUserDetail({
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

    factory LoggedUserDetail.fromJson(Map<String, dynamic> json) => LoggedUserDetail(
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
