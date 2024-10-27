import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

StudentProcedureListModel procedureCountDataModelFromJson(String str) =>
    StudentProcedureListModel.fromJson(json.decode(str));

String procedureCountDataModelToJson(StudentProcedureListModel data) =>
    json.encode(data.toJson());

class StudentProcedureListModel {
  StudentProcedureListModel({
    required this.data,
    required this.pager,
  });

  List<StudentProcedureListData> data;
  Pager pager;

  factory StudentProcedureListModel.fromJson(Map<String, dynamic> json) =>
      StudentProcedureListModel(
        data: List<StudentProcedureListData>.from(
            json["data"].map((x) => StudentProcedureListData.fromJson(x))),
        pager: Pager.fromJson(json['pager']),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pager": pager.toJson(),
  };
}

class StudentProcedureListData {
  StudentProcedureListData({
    required this.pcTopicId,
    required this.proceCountCode,
    required this.title,
  });

  String pcTopicId;
  String proceCountCode;
  String title;

  factory StudentProcedureListData.fromJson(Map<String, dynamic> json) =>
      StudentProcedureListData(
        pcTopicId: json["ProcedureCountTopicId"],
        proceCountCode: json["ProcedureCountsCode"],
        title: json["Title"],
      );

  Map<String, dynamic> toJson() => {
    "ProcedureCountTopicId": pcTopicId,
    "ProcedureCountsCode": proceCountCode,
    "Title": title,
  };
}
