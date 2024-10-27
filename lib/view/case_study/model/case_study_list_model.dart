// To parse this JSON data, do
//
//     final rotationListModel = rotationListModelFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';
import 'package:intl/intl.dart';

CaseStudyListModel rotationListModelFromJson(String str) =>
    CaseStudyListModel.fromJson(json.decode(str));

// String rotationListModelToJson(CaseStudyListModel data) => json.encode(data.toJson());

class CaseStudyListModel {
  CaseStudyListModel({
    required this.data,
    required this.pager,
  });

  List<CaseStudyListModelData> data;
  Pager pager;

  factory CaseStudyListModel.fromJson(Map<String, dynamic> json) =>
      CaseStudyListModel(
        // data: CaseStudyListModelData.fromJson(json["data"]),
        data: List<CaseStudyListModelData>.from(json["data"].map((x) => CaseStudyListModelData.fromJson(x as Map<String, dynamic>))),
        pager: Pager.fromJson(json['pager']),
      );

  // Map<String, dynamic> toJson() => {
  //   "data": data.toJson(),
  //   "pager": pager.toJson(),
  // };
}

class CaseStudyListModelData {
  CaseStudyListModelData({
    required this.isSelectedTab,
    required this.caseStudyList,
  });

  String isSelectedTab;
  List<CaseStudy> caseStudyList;

  factory CaseStudyListModelData.fromJson(Map<String, dynamic> json) =>
      CaseStudyListModelData(
        isSelectedTab: json["isSelectedTab"],
        caseStudyList: List<CaseStudy>.from(
            json["caseStudyList"].map((x) => CaseStudy.fromJson(x as Map<String, dynamic>))),
      );

  // Map<String, dynamic> toJson() => {
  //   "isSelectedTab": isSelectedTab,
  //   "caseStudyList": List<dynamic>.from(caseStudyList.map((x) => x.toJson())),
  // };
}

class CaseStudy {
  CaseStudy({
    required this.caseStudyId,
    required this.rotationId,
    required this.rotationName,
    required this.chiefComplaintAdmitDiagnosis,
    required this.caseStudyDate,
    // required this.endDate,
    required this.type,
    required this.typeName,
    required this.school,
    required this.clinician,
    required this.status,
  });

  String caseStudyId;
  String rotationId;
  String rotationName;
  String chiefComplaintAdmitDiagnosis;
  String caseStudyDate;
  // DateTime endDate;
  String type;
  String typeName;
  String school;
  String clinician;
  String status;

  factory CaseStudy.fromJson(Map<String, dynamic> json) {
    DateTime convertDateToUTC(String dateUtc) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
      var formattedTime = dateTime.toLocal();
      return formattedTime;
    }

    return CaseStudy(
      caseStudyId: json["CaseStudyId"],
      rotationId: json["RotationId"],
      rotationName: json["RotationName"],
      chiefComplaintAdmitDiagnosis: json["ChiefComplaint/Admitting Diagnosis"],
      caseStudyDate: json["CaseStudyDate"],
      // endDate: convertDateToUTC(json["endDate"]),
      type: json["Type"],
      typeName: json["TypeName"],
      school: json["School"],
      clinician: json["Clinician"],
      status: json["Status"],
    );
  }

  // Map<String, dynamic> toJson() => {
  //   "CaseStudyId": caseStudyId,
  //   "RotationId": rotationId,
  //   "RotationName": rotationName,
  //   "ChiefComplaint/Admitting Diagnosis": chiefComplaintAdmitDiagnosis,
  //   "CaseStudyDate": caseStudyDate.toIso8601String(),
  //   // "endDate": endDate.toIso8601String(),
  //   "Type": type,
  //   "School": school,
  //   "Clinician": clinician,
  // };
}
