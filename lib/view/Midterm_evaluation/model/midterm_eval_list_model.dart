// To parse this JSON data, do
//
//     final midtermEvalList = midtermEvalListFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

MidtermEvalList midtermEvalListFromJson(String str) =>
    MidtermEvalList.fromJson(json.decode(str));

String midtermEvalListToJson(MidtermEvalList data) =>
    json.encode(data.toJson());

class MidtermEvalList {
  List<MidtermEval> data;
  Pager pager;

  MidtermEvalList({
    required this.data,
    required this.pager,
  });

  factory MidtermEvalList.fromJson(Map<String, dynamic> json) =>
      MidtermEvalList(
        data: List<MidtermEval>.from(
            json["data"].map((x) => MidtermEval.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pager": pager.toJson(),
      };
}

class MidtermEval {
  String evaluationId;
  String rotationId;
  String rotationName;
  String evaluationDate;
  DateTime? dateOfStudentSignature;
  DateTime? dateOfInstructorSignature;
  String? status;
  PreceptorDetails? preceptorDetails;

  MidtermEval({
    required this.rotationId,
    required this.evaluationId,
    required this.rotationName,
    required this.evaluationDate,
    required this.dateOfStudentSignature,
    required this.dateOfInstructorSignature,
    this.status,
    this.preceptorDetails,
  });

  factory MidtermEval.fromJson(Map<String, dynamic> json) => MidtermEval(
        evaluationId: json["EvaluationId"] != null ? json["EvaluationId"] : '',
        rotationId: json["RotationId"] != null ? json["RotationId"] : '',
        rotationName: json["RotationName"] != null ? json["RotationName"] : '',
        evaluationDate: json["evaluationDate"],
        dateOfStudentSignature: json["DateOfStudentSignature"] == ""
            ? null
            : DateTime.parse(json["DateOfStudentSignature"]),
        dateOfInstructorSignature: json["DateOfInstructorSignature"] != ''
            ? DateTime.parse(json["DateOfInstructorSignature"])
            : null,
        status: json["Status"],
        preceptorDetails: json['PreceptorDetails'] != null
            ? PreceptorDetails.fromJson(json['PreceptorDetails'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "EvaluationId": evaluationId,
        "RotationId": rotationId,
        "RotationName": rotationName,
        "evaluationDate": evaluationDate,
        "DateOfStudentSignature": dateOfStudentSignature!.toIso8601String(),
        "DateOfInstructorSignature":
            dateOfInstructorSignature!.toIso8601String(),
        "Status": status,
        "PreceptorDetails": preceptorDetails,
      };
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
