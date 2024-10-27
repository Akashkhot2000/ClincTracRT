// To parse this JSON data, do
//
//     final attendanceResponseDart = attendanceResponseDartFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

AnnouncementListModel attendanceResponseDartFromJson(String str) =>
    AnnouncementListModel.fromJson(json.decode(str));

class AnnouncementListModel {
  AnnouncementListModel({
    required this.data,
    required this.pager,
  });

  List<AnnouncementListData> data;
  Pager pager;

  factory AnnouncementListModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementListModel(
        data: List<AnnouncementListData>.from(
            json["data"].map((x) => AnnouncementListData.fromJson(x))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class AnnouncementListData {
  AnnouncementListData({
    required this.announcementId,
    required this.announcementTitle,
    required this.announcementDescription,
    required this.fromDate,
    required this.toDate,
  });

  String announcementId;
  String announcementTitle;
  String announcementDescription;
  DateTime? fromDate;
  DateTime? toDate;

  factory AnnouncementListData.fromJson(Map<String, dynamic> json) => AnnouncementListData(
    announcementId: json["AnnouncementId"],
    announcementTitle: json["AnnouncementTitle"],
    announcementDescription: json["AnnouncementDescription"],
    fromDate: json["FromDate"]!= ""
        ? DateTime.parse(json["FromDate"])
        : null,
    toDate: json["ToDate"] != ""
        ? DateTime.parse(json["ToDate"])
        : null,
  );
}
