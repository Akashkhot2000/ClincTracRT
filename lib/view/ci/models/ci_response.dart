import 'dart:convert';

import '../../../model/common_pager_model.dart';

CIResponse CIResponseFromJson(String str) =>
    CIResponse.fromJson(json.decode(str));

class CIResponse {
  CIResponse({
    required this.data,
    required this.pager,
  });

  List<CIData> data;
  Pager pager;

  factory CIResponse.fromJson(Map<String, dynamic> json) => CIResponse(
        data: List<CIData>.from(json["data"].map((x) => CIData.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class CIData {
  CIData({
    required this.rotationName,
    required this.rotationId,
    required this.evaluationId,
    required this.firstName,
    required this.lastName,
    required this.evaluationDate,
    required this.OverallRating,
  });

  String rotationName;
  String rotationId;
  String evaluationId;
  String firstName;
  String lastName;
  String evaluationDate;
  String OverallRating;

  factory CIData.fromJson(Map<String, dynamic> json) => CIData(
        rotationName: json["RotationName"],
        rotationId: json["RotationId"],
        evaluationId: json["EvaluationId"],
        firstName: json["ClinicianFirstName"],
        lastName: json["ClinicianLastName"],
        evaluationDate: json["EvaluationDate"],
        OverallRating: json["CIEvalutionScore"] ?? "",
      );
}
