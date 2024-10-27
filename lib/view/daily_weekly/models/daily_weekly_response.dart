import 'dart:convert';

import '../../../model/common_pager_model.dart';

DailyWeeklyResponse DailyWeeklyResponseFromJson(String str) =>
    DailyWeeklyResponse.fromJson(json.decode(str));

class DailyWeeklyResponse {
  DailyWeeklyResponse({
    required this.data,
     this.pager,
  });

  List<DailyWeeklyData> data;
  Pager? pager;

  factory DailyWeeklyResponse.fromJson(Map<String, dynamic> json) =>
      DailyWeeklyResponse(
        data: List<DailyWeeklyData>.from(
            json["data"].map((x) => DailyWeeklyData.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class DailyWeeklyData {
  String? evaluationId;
  String? rotationId;
  String? rotatioName;
  DateTime? evaluationDate;
  DateTime? dateOfStudentSignature;
  DateTime? dateOfInstructorSignature;
  String? avgAtten;
  String? avgStudentPrep;
  String? avgProfess;
  String? avgKnow;
  String? avgPsych;
  String? avgOrg;
  String? avgTotal;
  String? status;
  PreceptorDetails? preceptorDetails;

  DailyWeeklyData({
    this.evaluationId,
    this.rotationId,
    this.rotatioName,
    this.evaluationDate,
    this.dateOfStudentSignature,
    this.dateOfInstructorSignature,
    this.avgAtten,
    this.avgStudentPrep,
    this.avgProfess,
    this.avgKnow,
    this.avgPsych,
    this.avgOrg,
    this.avgTotal,
    this.status,
    this.preceptorDetails,
  });

  factory DailyWeeklyData.fromJson(Map<String, dynamic> json) =>
      DailyWeeklyData(
        evaluationId: json["EvaluationId"],
        rotationId: json["RotationId"],
        rotatioName: json["RotatioName"],
        evaluationDate: DateTime.parse(json["EvaluationDate"]),
        dateOfStudentSignature: json["DateOfStudentSignature"] != ""
            ? DateTime.parse(json["DateOfStudentSignature"])
            : null,
        dateOfInstructorSignature: json["DateOfInstructorSignature"] != ""
            ? DateTime.parse(json["DateOfInstructorSignature"])
            : null,
        avgAtten: json["AvgAtten"],
        avgStudentPrep: json["AvgStudentPrep"],
        avgProfess: json["AvgProfess"],
        avgKnow: json["AvgKnow"],
        avgPsych: json["AvgPsych"],
        avgOrg: json["AvgOrg"],
        avgTotal: json["AvgTotal"],
        status: json["Status"],
        preceptorDetails: json['PreceptorDetails'] != null ? PreceptorDetails.fromJson(json['PreceptorDetails']) : null,
      );
}

class PreceptorDetails {
  String preceptorId;
  String preceptorName;
  String preceptorMobile;
  bool isPreceptorStatus;

  PreceptorDetails(
      {
        required this.preceptorId,
        required this.preceptorName,
        required this.preceptorMobile,
        required this.isPreceptorStatus});

  factory PreceptorDetails.fromJson(Map<String, dynamic> json) => PreceptorDetails(
    preceptorId: json['PreceptorId']??"",
    preceptorName: json['PreceptorName']??"",
    preceptorMobile: json['PreceptorMobile']??"",
    isPreceptorStatus: json['IsPreceptorStatus']??false,
  );

  Map<String, dynamic> toJson() => {
    "PreceptorId": preceptorId,
    "PreceptorName": preceptorName,
    "PreceptorMobile": preceptorMobile,
    "IsPreceptorStatus": isPreceptorStatus,
  };
}
// class Pager {
//   Pager({
//     required this.pageNumber,
//     required this.recordsPerPage,
//     required this.totalRecords,
//   });
//
//   String pageNumber;
//   int recordsPerPage;
//   int totalRecords;
//
//   factory Pager.fromJson(Map<String, dynamic> json) => Pager(
//         pageNumber: json["PageNumber"],
//         recordsPerPage: int.parse(json["RecordsPerPage"].toString()),
//         totalRecords: json["TotalRecords"],
//       );
// }

