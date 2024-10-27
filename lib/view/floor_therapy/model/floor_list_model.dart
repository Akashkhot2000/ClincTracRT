
import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';

FloorTherapyListModel studentCheckoffsListModelFromJson(String str) => FloorTherapyListModel.fromJson(json.decode(str));

class FloorTherapyListModel {
  FloorTherapyListModel({
    required this.data,
    required this.pager,
  });

  List<FloorTherapyListData> data;
  Pager pager;

  factory FloorTherapyListModel.fromJson(Map<String, dynamic> json) => FloorTherapyListModel(
    data: List<FloorTherapyListData>.from(json["data"].map((x) => FloorTherapyListData.fromJson(x as Map<String, dynamic>))),
    pager: Pager.fromJson(json["pager"]),
  );
}

class FloorTherapyListData {
  FloorTherapyListData({
    required this.evaluationId,
    required this.evaluationDate,
    required this.rotationId,
    required this.rotationName,
    required this.preceptorName,
    required this.dateOfStudentSignature,
    required this.hospitalSiteId,
    required this.hospitalSite,
    required this.course,
    required this.type,
    required this.score,
    required this.status,
    required this.preceptorDetails
  });

  String evaluationId;
  String evaluationDate;
  String rotationId;
  String rotationName;
  String preceptorName;
  DateTime? dateOfStudentSignature;
  String hospitalSiteId;
  String hospitalSite;
  String course;
  String type;
  String score;
  String status;
  PreceptorDetails? preceptorDetails;

  factory FloorTherapyListData.fromJson(Map<String, dynamic> json) => FloorTherapyListData(
    evaluationId: json['EvaluationId']??"",
    evaluationDate: json['EvaluationDate']??"",
    rotationId: json['RotationId']??"",
    rotationName: json['RotationName']??"",
    preceptorName: json['PreceptorName']??"",
    dateOfStudentSignature: json['DateOfStudentSignature'] != "" ? DateTime.parse(json['DateOfStudentSignature']) : null,
    hospitalSiteId: json['HospitalSiteId']??"",
    hospitalSite: json['HospitalSite']??"",
    course: json['Course'],
    type: json['Type']??"",
    score: json['Score']??"",
    status: json['Status'],
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
