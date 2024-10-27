import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

MedicalTerminologyModel medicalTerminologyModelFromJson(String str) => MedicalTerminologyModel.fromJson(json.decode(str));

class MedicalTerminologyModel {
  MedicalTerminologyModel({
    required this.data,
    required this.pager,
  });

  List<MedicalTerminology> data;
  Pager pager;

  factory MedicalTerminologyModel.fromJson(Map<String, dynamic> json) =>
      MedicalTerminologyModel(
        data: List<MedicalTerminology>.from(
            json["data"].map((x) => MedicalTerminology.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class MedicalTerminology {
  MedicalTerminology({
    required this.mtId,
    required this.title,
    required this.smallTitle,
    required this.description,
    required this.filePath,
  });

  String mtId;
  String title;
  String smallTitle;
  String description;
  String filePath;

  factory MedicalTerminology.fromJson(Map<String, dynamic> json) =>
      MedicalTerminology(
        mtId: json["Id"],
        title: json["Title"],
        smallTitle: json["SmallTitle"],
        description: json["Description"],
        filePath: json["FilePath"],
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
//     pageNumber: json["PageNumber"],
//     recordsPerPage: int.parse(json["RecordsPerPage"].toString()),
//     totalRecords: json["TotalRecords"],
//   );
// }

// import 'dart:convert';
//
// import 'package:clinicaltrac/model/common_pager_model.dart';
//
// MedicalTerminologyModel medicalTerminologyModelFromJson(String str) => MedicalTerminologyModel.fromJson(json.decode(str));
//
// String medicalTerminologyModelToJson(MedicalTerminologyModel data) => json.encode(data.toJson());
//
// class MedicalTerminologyModel {
//   MedicalTerminologyModel({
//     required this.data,
//     required this.pager,
//   });
//
//   List<MedicalTerminology> data;
//   Pager pager;
//
//   factory MedicalTerminologyModel.fromJson(Map<String, dynamic> json) => MedicalTerminologyModel(
//         data: List<MedicalTerminology>.from(json["data"].map((x) => MedicalTerminology.fromJson(x))),
//         pager: Pager.fromJson(json['pager']),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//         "pager": pager.toJson(),
//       };
// }
//
// class MedicalTerminology {
//   MedicalTerminology({
//     required this.mtId,
//     required this.title,
//     required this.smallTitle,
//     required this.description,
//     required this.filePath,
//   });
//
//   String mtId;
//   String title;
//   String smallTitle;
//   String description;
//   String filePath;
//
//   factory MedicalTerminology.fromJson(Map<String, dynamic> json) => MedicalTerminology(
//         mtId: json["Id"],
//         title: json["Title"],
//         smallTitle: json["SmallTitle"],
//         description: json["Description"],
//         filePath: json["FilePath"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "Id": mtId,
//         "Title": title,
//         "SmallTitle": smallTitle,
//         "Description": description,
//         "FilePath": filePath,
//       };
// }
//
// // class Pager {
// //   String? pageNumber;
// //   String? recordsPerPage;
// //   String? totalRecords;
// //
// //   Pager({this.pageNumber, this.recordsPerPage, this.totalRecords});
// //
// //   factory Pager.fromJson(Map<String, dynamic> json) => Pager(
// //         pageNumber: json['PageNumber'].toString(),
// //         recordsPerPage: json['RecordsPerPage'].toString(),
// //         totalRecords: json['TotalRecords'].toString(),
// //       );
// //
// //   Map<String, dynamic> toJson() => {
// //         'PageNumber': pageNumber,
// //         'RecordsPerPage': recordsPerPage,
// //         'TotalRecords': totalRecords,
// //       };
// // }
