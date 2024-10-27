// To parse this JSON data, do
//
//     final courseListModel = courseListModelFromJson(jsonString);

import 'dart:convert';

StudentDropdownListModel studentDropdownListModelFromJson(String str) =>
    StudentDropdownListModel.fromJson(json.decode(str));

String studentDropdownListModelToJson(StudentDropdownListModel data) =>
    json.encode(data.toJson());

class StudentDropdownListModel {
  StudentDropdownListModel({
    required this.data,
  });

  List<StudentDropdownData> data;

  factory StudentDropdownListModel.fromJson(Map<String, dynamic> json) =>
      StudentDropdownListModel(
        data: List<StudentDropdownData>.from(
            json["data"].map((x) => StudentDropdownData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class StudentDropdownData {
  StudentDropdownData({
    this.studentId,
    this.title,
  });

  String? studentId;
  String? title;

  factory StudentDropdownData.fromJson(Map<String, dynamic> json) => StudentDropdownData(
    studentId: json["StudentId"] != null ? json["StudentId"] : null,
    title: json["StudentName"] != "" ? json["StudentName"] : "",
  );

  Map<String, dynamic> toJson() => {
    "StudentId": studentId,
    "StudentName": title,
  };
}
