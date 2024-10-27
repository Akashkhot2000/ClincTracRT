// To parse this JSON data, do
//
//     final courseListModel = courseListModelFromJson(jsonString);

import 'dart:convert';

CourseListModel courseListModelFromJson(String str) =>
    CourseListModel.fromJson(json.decode(str));

String courseListModelToJson(CourseListModel data) =>
    json.encode(data.toJson());

class CourseListModel {
  CourseListModel({
    required this.data,
  });

  List<CourseData> data;

  factory CourseListModel.fromJson(Map<String, dynamic> json) =>
      CourseListModel(
        data: List<CourseData>.from(
            json["data"].map((x) => CourseData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CourseData {
  CourseData({
     this.courseId,
     this.title,
  });

  String? courseId;
  String? title;

  factory CourseData.fromJson(Map<String, dynamic> json) => CourseData(
        courseId: json["courseId"] != null ? json["courseId"] : null,
    title: json["courseTitle"] != "" ? json["courseTitle"] : "",
      );

  Map<String, dynamic> toJson() => {
        "courseId": courseId,
        "courseTitle": title,
      };
}
