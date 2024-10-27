// To parse this JSON data, do

import 'dart:convert';

RotationForEvalListModel rotationForEvalDataListFromJson(String str) => RotationForEvalListModel.fromJson(json.decode(str));

String rotationForEvalDataListToJson(RotationForEvalListModel data) => json.encode(data.toJson());

class RotationForEvalListModel {
  RotationForEvalListModel({
    required this.data,
  });

  List<RotationForEvalListData> data;

  factory RotationForEvalListModel.fromJson(Map<String, dynamic> json) => RotationForEvalListModel(
    data: List<RotationForEvalListData>.from(json["data"].map((x) => RotationForEvalListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RotationForEvalListData {
  RotationForEvalListData({
     this.rotationId,
     this.title,
     this.startDate,
     this.endDate,
     this.hospitalId,
     this.hospitalTitle,
     this.courseId,
     this.courseTitle,
     this.isActiveHospitalsite,
  });

  String? rotationId;
  String? title;
  String? startDate;
  String? endDate;
  String? hospitalId;
  String? hospitalTitle;
  String? courseId;
  String? courseTitle;
  int? isActiveHospitalsite;

  factory RotationForEvalListData.fromJson(Map<String, dynamic> json) => RotationForEvalListData(
    rotationId: json["RotationId"],
    title: json["Title"],
    startDate: json["StartDate"],
    endDate: json["EndDate"],
    hospitalId: json["HospitalId"],
    hospitalTitle: json["HospitalTitle"],
    courseId: json["CourseId"],
    courseTitle: json["CourseTitle"],
    isActiveHospitalsite: json["isActiveHospitalsite"],
  );

  Map<String, dynamic> toJson() => {
    "RotationId": rotationId,
    "Title": title,
    "StartDate": startDate,
    "EndDate": endDate,
    "HospitalId": hospitalId,
    "HospitalTitle": hospitalTitle,
    "CourseId": courseId,
    "CourseTitle": courseTitle,
    "isActiveHospitalsite": isActiveHospitalsite,
  };
}
