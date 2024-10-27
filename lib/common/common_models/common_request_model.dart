// To parse this JSON data, do
//
//     final dailyJournalList = dailyJournalListFromJson(jsonString);

import 'dart:convert';

String CommonRequestToJson(CommonRequest data) => json.encode(data.toJson());

class CommonRequest {
  CommonRequest({
    this.accessToken,
    this.userId,
    this.courseId,
    this.pageNo,
    this.isActive,
    this.RecordsPerPage,
    this.RotationId,
    this.SearchText,
    this.fromDate,
    this.title,
    this.statusType,
    this.fileName,
    this.type,
    this.todate,
    this.evaluationId,
    this.hospitalSiteId,
    this.isClockIn,
    this.userType,
    this.roleType,
    this.rankId,
    this.studentId,
    this.requestType,
    this.isAll,
    this.countryId,
  });

  String? accessToken;
  String? userId;
  String? courseId;
  String? pageNo;
  String? isActive;
  String? RecordsPerPage;
  String? RotationId;
  String? SearchText;
  String? title;
  String? fileName;
  String? type;
  String? statusType;
  String? fromDate;
  String? todate;
  String? evaluationId;
  String? hospitalSiteId;
  String? isClockIn;
  String? userType;
  String? roleType;
  String? rankId;
  String? studentId;
  String? requestType;
  String? isAll;
  String? countryId;

  Map<String, dynamic> toJson() => {
        "AccessToken": accessToken,
        "UserId": userId,
        // "CourseId": courseId,
        if (courseId != null) "CourseId": courseId,
        "PageNo": pageNo,
        // "IsActive": isActive,
        if (isActive != null) "IsActive": isActive,
        if (RecordsPerPage != null) "RecordsPerPage": RecordsPerPage,
        if (evaluationId != null) "EvaluationId": evaluationId,
        if (RotationId != null) "RotationId": RotationId,
        if (SearchText != null) "SearchText": SearchText,
        if (title != null) "Title": title,
        if (statusType != null) "StatusType": statusType,
        if (fileName != null) "FileName": fileName,
        if (type != null) "Type": type,
        if (fromDate != null) "FromDate": fromDate,
        if (todate != null) "Todate": todate,
        if (hospitalSiteId != null) "HospitalSiteId": hospitalSiteId,
        if (isClockIn != null) "isClockIn": isClockIn,
        if (userType != null) "UserType": userType,
        if (roleType != null) "RoleType": roleType,
        if (rankId != null) "RankId": rankId,
        if (studentId != null) "StudentId": studentId,
        if (requestType != null) "RequestType": requestType,
        if (isAll != null) "IsAll": isAll,
        if (countryId != null) "CountryId": countryId,

      };
}
