// To parse this JSON data, do
//
//     final siteEvalListData = siteEvalListDataFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

SiteEvalListData siteEvalListDataFromJson(String str) =>
    SiteEvalListData.fromJson(json.decode(str));

String siteEvalListDataToJson(SiteEvalListData data) =>
    json.encode(data.toJson());

class SiteEvalListData {
  List<SiteEvaluation> data;
  Pager pager;

  SiteEvalListData({
    required this.data,
    required this.pager,
  });

  factory SiteEvalListData.fromJson(Map<String, dynamic> json) =>
      SiteEvalListData(
        data: List<SiteEvaluation>.from(
            json["data"].map((x) => SiteEvaluation.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pager": pager.toJson(),
      };
}

class SiteEvaluation {
  String rotationName;
  String rotationId;
  String evaluationId;
  String firstName;
  String lastName;
  String hospitalTitle;
  String hospitalSitesUnit;
  String evaluationDate;
  String evaluationScore;

  SiteEvaluation({
    required this.rotationName,
    required this.rotationId,
    required this.evaluationId,
    required this.firstName,
    required this.lastName,
    required this.hospitalTitle,
    required this.hospitalSitesUnit,
    required this.evaluationDate,
    required this.evaluationScore,
  });

  factory SiteEvaluation.fromJson(Map<String, dynamic> json) => SiteEvaluation(
        rotationName: json["RotationName"],
        rotationId: json["RotationId"],
        evaluationId: json["EvaluationId"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        hospitalTitle: json["HospitalTitle"],
        hospitalSitesUnit: json["HospitalSitesUnit"],
        evaluationDate: json["EvaluationDate"],
        evaluationScore: json["EvaluationScore"],
      );

  Map<String, dynamic> toJson() => {
        "RotationName": rotationName,
        "RotationId": rotationId,
        "EvaluationId": evaluationId,
        "FirstName": firstName,
        "LastName": lastName,
        "HospitalTitle": hospitalTitle,
        "HospitalSitesUnit": hospitalSitesUnit,
        "EvaluationDate": evaluationDate,
        "EvaluationScore": evaluationScore,
      };
}
