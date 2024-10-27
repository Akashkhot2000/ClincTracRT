import 'dart:convert';

import '../../../model/common_pager_model.dart';

SummativeResponse SummativeResponseFromJson(String str) =>
    SummativeResponse.fromJson(json.decode(str));

class SummativeResponse {
  SummativeResponse({
    required this.data,
    required this.pager,
  });

  List<SummativeData> data;
  Pager pager;

  factory SummativeResponse.fromJson(Map<String, dynamic> json) =>
      SummativeResponse(
        data: List<SummativeData>.from(
            json["data"].map((x) => SummativeData.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class SummativeData {
  SummativeData({
    required this.evaluationId,
    required this.rotationId,
    required this.rotationName,
    required this.firstName,
    required this.lastName,
    required this.evaluationDate,
    this.dateOfStudentSignature,
    required this.EvalTotal,
    required this.OverallRating,
    this.status,
    this.preceptorDetails,
  });

  String evaluationId;
  String rotationId;
  String rotationName;
  String firstName;
  String lastName;
  String evaluationDate;
  DateTime? dateOfStudentSignature;
  String EvalTotal;
  String OverallRating;
  String? status;
  PreceptorDetails? preceptorDetails;

  factory SummativeData.fromJson(Map<String, dynamic> json) => SummativeData(
        evaluationId: json["EvaluationId"],
        rotationId: json["RotationId"]?? null,
        rotationName: json["RotationName"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        evaluationDate: json["EvaluationDate"],
        dateOfStudentSignature: json["DateOfStudentSignature"] == ""
            ? null
            : DateTime.parse(json["DateOfStudentSignature"]),
        EvalTotal: json["EvalTotal"] ?? "",
        OverallRating: json["OverallRating"] ?? "",
        status: json["Status"],
        preceptorDetails: json['PreceptorDetails'] != null
            ? PreceptorDetails.fromJson(json['PreceptorDetails'])
            : null,
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
