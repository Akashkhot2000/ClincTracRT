// To parse this JSON data, do
//
//     final userActiveRotationListModel = userActiveRotationListModelFromJson(jsonString);

import 'dart:convert';

UserActiveRotationListModel userActiveRotationListModelFromJson(String str) => UserActiveRotationListModel.fromJson(json.decode(str));

String userActiveRotationListModelToJson(UserActiveRotationListModel data) => json.encode(data.toJson());

class UserActiveRotationListModel {
    UserActiveRotationListModel({
        required this.data,
    });

    UserActiveRotationListData data;

    factory UserActiveRotationListModel.fromJson(Map<String, dynamic> json) => UserActiveRotationListModel(
        data: UserActiveRotationListData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class UserActiveRotationListData {
    UserActiveRotationListData({
        required this.isClockedIn,
        required this.rotationList,
    });

    bool isClockedIn;
    List<Rotation> rotationList;

    factory UserActiveRotationListData.fromJson(Map<String, dynamic> json) => UserActiveRotationListData(
        isClockedIn: json["isClockedIn"],
        rotationList: List<Rotation>.from(json["rotationList"].map((x) => Rotation.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isClockedIn": isClockedIn,
        "rotationList": List<dynamic>.from(rotationList.map((x) => x.toJson())),
    };
}

class Rotation {
    Rotation({
        required this.rotationId,
        required this.title,
        required this.startDate,
        required this.endDate,
        required this.hospitalTitle,
        required this.isClockIn,
    });

    String rotationId;
    String title;
    DateTime startDate;
    DateTime endDate;
    String hospitalTitle;
    int isClockIn;

    factory Rotation.fromJson(Map<String, dynamic> json) => Rotation(
        rotationId: json["rotationId"],
        title: json["title"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        hospitalTitle: json["hospitalTitle"],
        isClockIn: json["isClockIn"],
    );

    Map<String, dynamic> toJson() => {
        "rotationId": rotationId,
        "title": title,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "hospitalTitle": hospitalTitle,
        "isClockIn": isClockIn,
    };
}
