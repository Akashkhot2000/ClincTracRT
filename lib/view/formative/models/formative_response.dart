import 'dart:convert';

import '../../../model/common_pager_model.dart';

FormativeResponse FormativeResponseFromJson(String str) =>
    FormativeResponse.fromJson(json.decode(str));

class FormativeResponse {
  FormativeResponse({
    required this.data,
    required this.pager,
  });

  List<FormativeData> data;
  Pager pager;

  factory FormativeResponse.fromJson(Map<String, dynamic> json) =>
      FormativeResponse(
        data: List<FormativeData>.from(
            json["data"].map((x) => FormativeData.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class FormativeData {
  FormativeData({
    required this.id,
    required this.rotationId,
    required this.rotationName,
    required this.firstName,
    required this.lastName,
    required this.evaluationDate,
    this.dateOfStudentSignature,
    this.dateOfInstructorSignature,
    this.status,
    this.preceptorDetails,
  });

  String id;
  String rotationId;
  String rotationName;
  String firstName;
  String lastName;
  String evaluationDate;
  DateTime? dateOfStudentSignature;
  DateTime? dateOfInstructorSignature;
  String? status;
  PreceptorDetails? preceptorDetails;

  factory FormativeData.fromJson(Map<String, dynamic> json) => FormativeData(
        id: json['EvaluationId'],
        rotationId: json['RotationId'],
        rotationName: json['RotationName'],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        evaluationDate: json["EvaluationDate"],
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
}

class PreceptorDetails {
  String preceptorId;
  String preceptorName;
  String preceptorMobile;
  bool isPreceptorStatus;

  PreceptorDetails(
      {required this.preceptorId,
      required this.preceptorName,
      required this.preceptorMobile,
      required this.isPreceptorStatus});

  factory PreceptorDetails.fromJson(Map<String, dynamic> json) =>
      PreceptorDetails(
        preceptorId: json['PreceptorId'] ?? "",
        preceptorName: json['PreceptorName'] ?? "",
        preceptorMobile: json['PreceptorMobile'] ?? "",
        isPreceptorStatus: json['IsPreceptorStatus'] ?? false,
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
