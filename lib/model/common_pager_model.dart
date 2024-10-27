import 'dart:convert';

PagerModel medicalTerminologyModelFromJson(String str) => PagerModel.fromJson(json.decode(str));

String medicalTerminologyModelToJson(PagerModel data) => json.encode(data.toJson());

class PagerModel {
  PagerModel({
    required this.pager,
  });

  Pager pager;

  factory PagerModel.fromJson(Map<String, dynamic> json) => PagerModel(
    pager: Pager.fromJson(json['pager']),
  );

  Map<String, dynamic> toJson() => {
    "pager": pager.toJson(),
  };
}

class Pager {
  String? pageNumber;
  String? recordsPerPage;
  String? totalRecords;

  Pager({this.pageNumber, this.recordsPerPage, this.totalRecords});

  factory Pager.fromJson(Map<String, dynamic> json) => Pager(
    pageNumber: json['PageNumber'].toString(),
    recordsPerPage: json['RecordsPerPage'].toString(),
    totalRecords: json['TotalRecords'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'PageNumber': pageNumber,
    'RecordsPerPage': recordsPerPage,
    'TotalRecords': totalRecords,
  };
}
