// To parse this JSON data, do
//
//     final courseListModel = courseListModelFromJson(jsonString);

import 'dart:convert';

RankDropdownListModel rankDropdownListModelFromJson(String str) =>
    RankDropdownListModel.fromJson(json.decode(str));

String rankDropdownListModelToJson(RankDropdownListModel data) =>
    json.encode(data.toJson());

class RankDropdownListModel {
  RankDropdownListModel({
    required this.data,
  });

  List<RankDropdownData> data;

  factory RankDropdownListModel.fromJson(Map<String, dynamic> json) =>
      RankDropdownListModel(
        data: List<RankDropdownData>.from(
            json["data"].map((x) => RankDropdownData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RankDropdownData {
  RankDropdownData({
    this.rankId,
    this.title,
  });

  String? rankId;
  String? title;

  factory RankDropdownData.fromJson(Map<String, dynamic> json) => RankDropdownData(
    rankId: json["RankId"] != null ? json["RankId"] : null,
    title: json["RankName"] != "" ? json["RankName"] : "",
  );

  Map<String, dynamic> toJson() => {
    "RankId": rankId,
    "RankName": title,
  };
}
