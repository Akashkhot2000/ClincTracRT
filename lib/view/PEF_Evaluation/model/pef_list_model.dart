// To parse this JSON data, do
//
//     final rotationListModel = rotationListModelFromJson(jsonString);

import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../model/common_pager_model.dart';

PEFListModel procedureCountDetailsModelFromJson(String str) =>
    PEFListModel.fromJson(json.decode(str));

String procedureCountDetailsModelToJson(PEFListModel data) =>
    json.encode(data.toJson());

class PEFListModel {
  PEFListModel({
    required this.data,
    required this.pager,
  });

  List<PEFListData> data;
  Pager pager;

  factory PEFListModel.fromJson(Map<String, dynamic> json) => PEFListModel(
        data: List<PEFListData>.from(json["data"]
            .map((x) => PEFListData.fromJson(x as Map<String, dynamic>))),
        pager: Pager.fromJson(json["pager"]),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pager": pager.toJson(),
  };
}

class PEFListData {
  PEFListData({
    required this.evaluationId,
    required this.rotationId,
    required this.evaluationDate,
    required this.dateOfStudentSignature,
    required this.rotationName,
    required this.hospitalSiteId,
    required this.hospitalSite,
    required this.course,
    required this.type,
    required this.score,
    required this.pefStatus,
    required this.status,
  });

  String evaluationId;
  String rotationId;
  String? evaluationDate;
  DateTime? dateOfStudentSignature;
  String rotationName;
  String hospitalSiteId;
  String hospitalSite;
  String course;
  String type;
  String score;
  String pefStatus;
  String status;

  factory PEFListData.fromJson(Map<String, dynamic> json) => PEFListData(
      evaluationId: json["EvaluationId"],
      rotationId: json["RotationId"],
      evaluationDate:json["EvaluationDate"]!= "" ? json["EvaluationDate"] : null,
          // != "" ? json["EvaluationDate"] : null,
      dateOfStudentSignature: json["DateOfStudentSignature"] != "" ? DateTime.parse(json["DateOfStudentSignature"]) : null,
      rotationName: json["RotationName"],
      hospitalSiteId: json["HospitalSiteId"],
      hospitalSite: json["HospitalSite"],
      course: json["Course"],
      type: json["Type"],
      score: json["Score"],
      pefStatus: json["PefStatus"],
      status: json["Status"],
    );
Map<String, dynamic> toJson() => {
  "EvaluationId": evaluationId,
  "RotationId": rotationId,
  "EvaluationDate": evaluationDate!,
  "DateOfStudentSignature": dateOfStudentSignature!.toIso8601String(),
  "RotationName": rotationName,
  "HospitalSiteId": hospitalSiteId,
  "HospitalSite": hospitalSite,
  "Course": course,
  "Type": type,
  "Score": score,
  "PefStatus": pefStatus,
  "Status": status,
};
}
