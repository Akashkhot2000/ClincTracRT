// To parse this JSON data, do
//
//     final incidentResponse = incidentResponseFromJson(jsonString);

import 'dart:convert';

import '../../../model/common_pager_model.dart';

IncidentResponse incidentResponseFromJson(String str) => IncidentResponse.fromJson(json.decode(str));

class IncidentResponse {
  IncidentResponse({
    required this.data,
    required this.pager,
  });

  List<IncidentData> data;
  Pager pager;

  factory IncidentResponse.fromJson(Map<String, dynamic> json) => IncidentResponse(
        data: List<IncidentData>.from(json["data"].map((x) => IncidentData.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class IncidentData {
  IncidentData({
    required this.incidentId,
    required this.incidentDate,
    required this.title,
    required this.rotationId,
    required this.rotationName,
    required this.clinicianName,
  });

  String incidentId;
  String incidentDate;
  String title;
  String rotationId;
  String rotationName;
  String clinicianName;

  factory IncidentData.fromJson(Map<String, dynamic> json) => IncidentData(
    incidentId: json["IncidentId"],
        incidentDate: json["IncidentDate"],
        title: json["Title"],
        rotationId: json["RotationId"],
        rotationName: json["RotationName"],
        clinicianName: json["ClinicianName"],
      );
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
