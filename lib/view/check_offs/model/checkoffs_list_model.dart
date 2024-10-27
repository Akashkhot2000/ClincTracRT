
import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

StudentCheckoffsListModel studentCheckoffsListModelFromJson(String str) => StudentCheckoffsListModel.fromJson(json.decode(str));

class StudentCheckoffsListModel {
  StudentCheckoffsListModel({
    required this.data,
    required this.pager,
  });

  List<CheckoffsListData> data;
  Pager pager;

  factory StudentCheckoffsListModel.fromJson(Map<String, dynamic> json) => StudentCheckoffsListModel(
    data: List<CheckoffsListData>.from(json["data"].map((x) => CheckoffsListData.fromJson(x))),
    pager: Pager.fromJson(json["pager"]),
  );
}

class CheckoffsListData {
  CheckoffsListData({
    required this.checkoffId,
    required this.rotationId,
    required this.rotationName,
    required this.checkoffDateTime,
    required this.clinicianName,
    required this.courseName,
    required this.topicId,
    required this.topicTitle,
    required this.studentEvaluationDate,
    required this.checkoffType,
    required this.studentCheckoffScore,
    required this.usafCheckoffScore,
    required this.selectedStudentScore,
    required this.selectedPreceptor,
    required this.selectedLab,
    required this.selectedClinical,
    this.clinicianComment,
    this.studentComment,
    required this.status,
    required this.preceptorDetails
  });

  String checkoffId;
  String rotationId;
  String rotationName;
  DateTime checkoffDateTime;
  String clinicianName;
  String courseName;
  String topicId;
  String topicTitle;
  String studentEvaluationDate;
  String checkoffType;
  String studentCheckoffScore;
  String usafCheckoffScore;
  String selectedStudentScore;
  String selectedPreceptor;
  String selectedLab;
  String selectedClinical;
  String? clinicianComment;
  String? studentComment;
  String status;
  PreceptorDetails? preceptorDetails;

  factory CheckoffsListData.fromJson(Map<String, dynamic> json) => CheckoffsListData(
    checkoffId: json['CheckoffId']??"",
    rotationId: json['RotationId']??"",
    rotationName: json['RotationName']??"",
    checkoffDateTime: DateTime.parse(json['CheckoffDateTime']??""),
    clinicianName: json['ClinicianName']??"",
    courseName: json['CourseName']??"",
    topicId: json['TopicId']??"",
    topicTitle: json['TopicTitle']??"",
    studentEvaluationDate: json['StudentEvaluationDate']??"",
    checkoffType: json['CheckoffType'],
    studentCheckoffScore: json['StudentCheckoffScore']??"",
    usafCheckoffScore: json['UsafCheckoffScore']??"",
    selectedStudentScore: json['SelectedStudentScore']??"",
    selectedPreceptor: json['SelectedPreceptor']??"",
    selectedLab: json['SelectedLab']??"",
    selectedClinical: json['SelectedClinical']??"",
    clinicianComment: json['ClinicianComment']??"",
    studentComment: json['StudentComment']??"",
    status: json['Status']??"",
    preceptorDetails: json['PreceptorDetails'] != null ? PreceptorDetails.fromJson(json['PreceptorDetails']) : null,
  );
}

class PreceptorDetails {
  String preceptorId;
  String preceptorName;
  String preceptorMobile;
  bool isPreceptorStatus;

  PreceptorDetails(
      {
        required this.preceptorId,
        required this.preceptorName,
      required this.preceptorMobile,
      required this.isPreceptorStatus});

  factory PreceptorDetails.fromJson(Map<String, dynamic> json) => PreceptorDetails(
    preceptorId: json['PreceptorId']??"",
        preceptorName: json['PreceptorName']??"",
        preceptorMobile: json['PreceptorMobile']??"",
        isPreceptorStatus: json['IsPreceptorStatus']??false,
      );

  Map<String, dynamic> toJson() => {
        "PreceptorId": preceptorId,
        "PreceptorName": preceptorName,
        "PreceptorMobile": preceptorMobile,
        "IsPreceptorStatus": isPreceptorStatus,
      };
}
