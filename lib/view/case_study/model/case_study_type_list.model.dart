import 'dart:convert';

CaseStudySettingTypeModel procedureCountDataModelFromJson(String str) =>
    CaseStudySettingTypeModel.fromJson(json.decode(str));

String procedureCountDataModelToJson(CaseStudySettingTypeModel data) =>
    json.encode(data.toJson());

class CaseStudySettingTypeModel {
  CaseStudySettingTypeModel({
    required this.data,
  });

  List<CaseStudySettingTypeData> data;

  factory CaseStudySettingTypeModel.fromJson(Map<String, dynamic> json) =>
      CaseStudySettingTypeModel(
        data: List<CaseStudySettingTypeData>.from(
            json["data"].map((x) => CaseStudySettingTypeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CaseStudySettingTypeData {
  CaseStudySettingTypeData({
    required this.caseId,
    required this.caseName,
    required this.caseType,
  });

  String caseId;
  String caseName;
  String caseType;

  factory CaseStudySettingTypeData.fromJson(Map<String, dynamic> json) =>
      CaseStudySettingTypeData(
        caseId: json["Id"],
        caseName: json["Name"],
        caseType: json["Type"],
      );

  Map<String, dynamic> toJson() => {
    "Id": caseId,
    "Name": caseName,
    "Type": caseType,
  };
}
