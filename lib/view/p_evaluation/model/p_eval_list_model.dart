// To parse this JSON data, do
//
//     final siteEvalListData = siteEvalListDataFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

PEvalListData siteEvalListDataFromJson(String str) =>
    PEvalListData.fromJson(json.decode(str));

String siteEvalListDataToJson(PEvalListData data) =>
    json.encode(data.toJson());

class PEvalListData {
  List<PEvaluationData> data;
  Pager pager;

  PEvalListData({
    required this.data,
    required this.pager,
  });

  factory PEvalListData.fromJson(Map<String, dynamic> json) =>
      PEvalListData(
        data: List<PEvaluationData>.from(
            json["data"].map((x) => PEvaluationData.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pager": pager.toJson(),
  };
}

class PEvaluationData {
  String rotationId;
  String evaluationId;
  String evaluationDate;
  String rotationName;
  String hospitalSiteId;
  String hospitalSites;
  String course;
  String totalAvg;

  PEvaluationData({
    required this.rotationId,
    required this.evaluationId,
    required this.evaluationDate,
    required this.rotationName,
    required this.hospitalSiteId,
    required this.hospitalSites,
    required this.course,
    required this.totalAvg,
  });

  factory PEvaluationData.fromJson(Map<String, dynamic> json) => PEvaluationData(
    rotationId: json["RotationId"],
    evaluationId: json["EvaluationId"],
    evaluationDate: json["EvaluationDate"],
    rotationName: json["RotationName"],
    hospitalSiteId: json["HospitalSiteId"],
    hospitalSites: json["HospitalSite"],
    course: json["Course"],
    totalAvg: json["TotalAvg"],
  );

  Map<String, dynamic> toJson() => {
    "RotationId": rotationId,
    "EvaluationId": evaluationId,
    "EvaluationDate": evaluationDate,
    "RotationName": rotationName,
    "HospitalSiteId": hospitalSiteId,
    "HospitalSite": hospitalSites,
    "Course": course,
    "TotalAvg": totalAvg,
  };
}

