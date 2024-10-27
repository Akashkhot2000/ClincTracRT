// To parse this JSON data, do
//
//     final gridData = gridDataFromJson(jsonString);

import 'dart:convert';

List<GridData> gridDataFromJson(String str) => List<GridData>.from(json.decode(str).map((x) => GridData.fromJson(x as Map<String, dynamic>)));

String gridDataToJson(List<GridData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GridData {
    GridData({
        required this.color,
        required this.iconPath,

        required this.title,
    });

    String color;
    String iconPath;

    String title;

    factory GridData.fromJson(Map<String, dynamic> json) => GridData(
        color: json["color"],
        iconPath: json["icon_path"],

        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "color": color,
        "icon_path": iconPath,

        "title": title,
    };
}
