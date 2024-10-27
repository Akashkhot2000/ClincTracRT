// To parse this JSON data, do

import 'dart:convert';

CourseTopicListModel courseTopicDataListFromJson(String str) => CourseTopicListModel.fromJson(json.decode(str));

String courseTopicDataListToJson(CourseTopicListModel data) => json.encode(data.toJson());

class CourseTopicListModel {
  CourseTopicListModel({
     this.data,
  });

  List<CourseTopicListData>? data = <CourseTopicListData>[];

  factory CourseTopicListModel.fromJson(Map<String, dynamic> json) => CourseTopicListModel(
    data: List<CourseTopicListData>.from(json["data"].map((x) => CourseTopicListData.fromJson(x as Map<String, dynamic>))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CourseTopicListData {
  CourseTopicListData({
     this.topicId,
     this.title,
  });

  String? topicId;
  String? title;

  factory CourseTopicListData.fromJson(Map<String, dynamic> json) => CourseTopicListData(
    topicId: json["TopicId"],
    title: json["Title"],
  );

  Map<String, dynamic> toJson() => {
    "TopicId": topicId,
    "Title": title,
  };
}
