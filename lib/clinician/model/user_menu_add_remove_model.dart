import 'dart:convert';

UserMenuAddRemoveModel medicalTerminologyModelFromJson(String str) =>
    UserMenuAddRemoveModel.fromJson(json.decode(str));

String medicalTerminologyModelToJson(UserMenuAddRemoveModel data) =>
    json.encode(data.toJson());

class UserMenuAddRemoveModel {
  UserMenuAddRemoveModel({
     this.data,
  });

  UserMenuAddRemoveData? data;

  factory UserMenuAddRemoveModel.fromJson(Map<String, dynamic> json) =>
      UserMenuAddRemoveModel(
        data: UserMenuAddRemoveData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class UserMenuAddRemoveData {
  bool? attendance;
  bool? caseStudy;
  bool? incident;
  bool? briefcase;
  bool? exception;
  bool? medicalTerminology;
  bool? drInteraction;
  bool? dailyJournal;
  bool? formative;
  bool? dailyWeekly;
  bool? midterm;
  bool? summative;
  bool? masteryEvaluation;
  bool? cIEvaluation;
  bool? pEvaluation;
  bool? siteEvaluation;
  bool? volunterEvaluation;
  bool? floorTherapyAndICU;
  bool? pEFEvaluation;
  bool? equipmentList;
  bool? chat;
  bool? help;

  UserMenuAddRemoveData({
     this.attendance,
     this.caseStudy,
     this.incident,
     this.briefcase,
     this.exception,
     this.medicalTerminology,
     this.drInteraction,
     this.dailyJournal,
     this.formative,
     this.dailyWeekly,
     this.midterm,
     this.summative,
     this.masteryEvaluation,
     this.cIEvaluation,
     this.pEvaluation,
     this.siteEvaluation,
     this.volunterEvaluation,
     this.floorTherapyAndICU,
     this.pEFEvaluation,
     this.equipmentList,
     this.chat,
     this.help,
  });

  factory UserMenuAddRemoveData.fromJson(Map<String, dynamic> json) =>
      UserMenuAddRemoveData(
        attendance: json['Attendance'],
        caseStudy: json['Case Study'],
        incident: json['Incident'],
        briefcase: json['Briefcase'],
        exception: json['Exception'],
        medicalTerminology: json['Medical Terminology'],
        drInteraction: json['Dr. Interaction'],
        dailyJournal: json['Daily Journal'],
        formative: json['Formative'],
        dailyWeekly: json['Daily/Weekly'],
        midterm: json['Midterm'],
        summative: json['Summative'],
        masteryEvaluation: json['Mastery Evaluation'],
        cIEvaluation: json['CI Evaluation'],
        pEvaluation: json['P Evaluation'],
        siteEvaluation: json['Site Evaluation'],
        volunterEvaluation: json['Volunter Evaluation'],
        floorTherapyAndICU: json['Floor Therapy And ICU'],
        pEFEvaluation: json['PEF Evaluation'],
        equipmentList: json['Equipment List'],
        chat: json['Chat'],
        help: json['Help'],
      );

  Map<String, dynamic> toJson() => {
    "Attendance": attendance,
    "Case Study": caseStudy,
    "Incident": incident,
    "Briefcase": briefcase,
    "Exception": exception,
    "Medical Terminology": medicalTerminology,
    "Dr. Interaction": drInteraction,
    "Daily Journal": dailyJournal,
    "Formative": formative,
    "Daily/Weekly": dailyWeekly,
    "Midterm": midterm,
    "Summative": summative,
    "Mastery Evaluation": masteryEvaluation,
    "CI Evaluation": cIEvaluation,
    "P Evaluation": pEvaluation,
    "Site Evaluation": siteEvaluation,
    "Volunter Evaluation": volunterEvaluation,
    "Floor Therapy And ICU": floorTherapyAndICU,
    "PEF Evaluation": pEFEvaluation,
    "Equipment List": equipmentList,
    "Chat": chat,
    "Help": help,
  };
}
