import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

StudentDetailListModel dailyJournalListResponseFromJson(String str) =>
    StudentDetailListModel.fromJson(json.decode(str));

class StudentDetailListModel {
  StudentDetailListModel({
    this.data,
    this.pager,
  });

  List<StudentDetailListData>? data;
  Pager? pager;

  factory StudentDetailListModel.fromJson(Map<String, dynamic> json) =>
      StudentDetailListModel(
        data: List<StudentDetailListData>.from(json["data"].map((x) => StudentDetailListData.fromJson(x as Map<String, dynamic>))),
        pager: Pager.fromJson(json["pager"]),
      );
}

class StudentDetailListData {
  StudentDetailListData({
    this.studentId,
    this.rotationId,
    this.rotationName,
    this.studentName,
    this.rankId,
    this.rank,
    this.email,
    this.phoneNo,
    this.profilePic,
  });

  String? studentId;
  String? rotationId;
  String? rotationName;
  String? studentName;
  String? rankId;
  String? rank;
  String? email;
  String? phoneNo;
  String? profilePic;

  factory StudentDetailListData.fromJson(Map<String, dynamic> json) =>
      StudentDetailListData(
        studentId: json["StudentId"] != null ? json["StudentId"] : null,
        rotationId: json["RotationId"] != null ? json["RotationId"] : null,
        rotationName: json["RotationName"] != null ? json["RotationName"] : null,
        studentName: json["StudentName"] != null ? json["StudentName"] : null,
        rankId: json["RankId"] != null ? json["RankId"] : null,
        rank: json["Rank"] != null ? json["Rank"] : null,
        email: json["Email"] != null ? json["Email"] : null,
        phoneNo: json["Phone"] != null ? json["Phone"] : null,
        profilePic: json["ProfilePic"] != null ? json["ProfilePic"] : null,
      );
}
