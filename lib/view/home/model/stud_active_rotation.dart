// To parse this JSON data, do
//
//     final ActiveRotationListModel = ActiveRotationListModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

ActiveRotationListModel ActiveRotationListModelFromJson(String str) =>
    ActiveRotationListModel.fromJson(json.decode(str));

String ActiveRotationListModelToJson(ActiveRotationListModel data) =>
    json.encode(data.toJson());

class ActiveRotationListModel {
  ActiveRotationListModel({
    required this.data,
  });

  ActiveRotaionListData data;

  factory ActiveRotationListModel.fromJson(Map<String, dynamic> json) =>
      ActiveRotationListModel(
        data: ActiveRotaionListData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class ActiveRotaionListData {
  ActiveRotaionListData({
    required this.pendingRotation,
    required this.isClockedIn,
    required this.rotationList,
  });

  bool isClockedIn;
  List<PendingRotation> pendingRotation;
  List<ActiveRotation> rotationList;

  factory ActiveRotaionListData.fromJson(Map<String, dynamic> json) =>
      ActiveRotaionListData(
        isClockedIn: json["isClockedIn"],
        pendingRotation: List<PendingRotation>.from(
            json["pendingRotation"].map((x) => PendingRotation.fromJson(x))),
        rotationList: List<ActiveRotation>.from(json["rotationList"]
            .map((x) => ActiveRotation.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "isClockedIn": isClockedIn,
        "rotationList": List<dynamic>.from(rotationList.map((x) => x.toJson())),
      };
}

class ActiveRotation {
  ActiveRotation({
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

  factory ActiveRotation.fromJson(Map<String, dynamic> json) {
    DateTime convertDateToUTC(String dateUtc) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
      var formattedTime = dateTime.toLocal();
      return formattedTime;
    }

    return ActiveRotation(
      rotationId: json["rotationId"],
      title: json["title"],
      startDate: convertDateToUTC(json["startDate"]),
      endDate: convertDateToUTC(json["endDate"]),
      hospitalTitle: json["hospitalTitle"],
      isClockIn: json["isClockIn"],
    );
  }
  Map<String, dynamic> toJson() => {
        "rotationId": rotationId,
        "title": title,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "hospitalTitle": hospitalTitle,
        "isClockIn": isClockIn,
      };
}

class PendingRotation {
  String rotationId;
  String rotationTitle;
  DateTime startDate;
  DateTime endDate;
  String hospitalTitle;
  String courseId;
  String courseTitle;
  int isClockIn;
  bool isExpired;

  PendingRotation({
    required this.rotationId,
    required this.rotationTitle,
    required this.startDate,
    required this.endDate,
    required this.hospitalTitle,
    required this.courseId,
    required this.courseTitle,
    required this.isClockIn,
    required this.isExpired,
  });

  factory PendingRotation.fromJson(Map<String, dynamic> json) =>
      PendingRotation(
        rotationId: json["rotationId"],
        rotationTitle: json["RotationTitle"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        hospitalTitle: json["hospitalTitle"],
        courseId: json["courseId"],
        courseTitle: json["courseTitle"],
        isClockIn: json["isClockIn"],
        isExpired: json["isExpired"],
      );

  Map<String, dynamic> toJson() => {
        "rotationId": rotationId,
        "RotationTitle": rotationTitle,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "hospitalTitle": hospitalTitle,
        "courseId": courseId,
        "courseTitle": courseTitle,
        "isClockIn": isClockIn,
        "isExpired": isExpired,
      };
}
