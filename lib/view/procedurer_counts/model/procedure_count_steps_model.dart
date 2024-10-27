import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

ProcedureCountStepsModel procedureCountStepsModelFromJson(String str) =>
    ProcedureCountStepsModel.fromJson(json.decode(str));

String procedureCountStepsModelToJson(ProcedureCountStepsModel data) =>
    json.encode(data.toJson());

class ProcedureCountStepsModel {
  ProcedureCountStepsModel({
    required this.data,
    required this.pager,
  });

  List<ProcedureCountStepsData> data;
  Pager pager;

  factory ProcedureCountStepsModel.fromJson(Map<String, dynamic> json) =>
      ProcedureCountStepsModel(
        data: List<ProcedureCountStepsData>.from(
            json["data"].map((x) => ProcedureCountStepsData.fromJson(x))),
        pager: Pager.fromJson(json['pager']),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pager": pager.toJson(),
  };
}

class ProcedureCountStepsData {
  ProcedureCountStepsData({
    required this.sortOrder,
    required this.title,
  });

  String sortOrder;
  String title;

  factory ProcedureCountStepsData.fromJson(Map<String, dynamic> json) =>
      ProcedureCountStepsData(
        sortOrder: json["SortOrder"],
        title: json["Title"],
      );

  Map<String, dynamic> toJson() => {
    "SortOrder": sortOrder,
    "Title": title,
  };
}
