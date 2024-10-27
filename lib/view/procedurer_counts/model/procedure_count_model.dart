import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

ProcedureCountModel procedureCountDataModelFromJson(String str) =>
    ProcedureCountModel.fromJson(json.decode(str));

String procedureCountDataModelToJson(ProcedureCountModel data) =>
    json.encode(data.toJson());

class ProcedureCountModel {
  ProcedureCountModel({
    required this.data,
    required this.pager,
  });

  List<ProcedureCountData> data;
  Pager pager;

  factory ProcedureCountModel.fromJson(Map<String, dynamic> json) =>
      ProcedureCountModel(
        data: List<ProcedureCountData>.from(
            json["data"].map((x) => ProcedureCountData.fromJson(x))),
        pager: Pager.fromJson(json['pager']),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "pager": pager.toJson(),
      };
}

class ProcedureCountData {
  ProcedureCountData({
    required this.pcId,
    required this.title,
    required this.totProceCateCount,
  });

  String pcId;
  String title;
  String totProceCateCount;

  factory ProcedureCountData.fromJson(Map<String, dynamic> json) =>
      ProcedureCountData(
        pcId: json["ProcedureCategoryId"],
        title: json["Title"],
        totProceCateCount: json["TotalProcedureCategoryCount"],
      );

  Map<String, dynamic> toJson() => {
        "ProcedureCategoryId": pcId,
        "Title": title,
        "TotalProcedureCategoryCount": totProceCateCount,
      };
}
