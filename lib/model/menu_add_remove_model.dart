import 'dart:convert';

MenuAddRemoveModel medicalTerminologyModelFromJson(String str) =>
    MenuAddRemoveModel.fromJson(json.decode(str));

String medicalTerminologyModelToJson(MenuAddRemoveModel data) =>
    json.encode(data.toJson());

class MenuAddRemoveModel {
  MenuAddRemoveModel({
    required this.data,
  });

  MenuAddRemoveData data;

  factory MenuAddRemoveModel.fromJson(Map<String, dynamic> json) =>
      MenuAddRemoveModel(
        data: MenuAddRemoveData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class MenuAddRemoveData {
  bool attendance;
  bool caseStudy;
  bool incident;
  bool briefcase;
  bool exception;
  bool medicalTerminology;
  bool drInteraction;
  bool dailyJournal;
  bool formative;
  bool dailyWeekly;
  bool midterm;
  bool summative;
  bool masteryEvaluation;
  bool cIEvaluation;
  bool pEvaluation;
  bool siteEvaluation;
  bool volunterEvaluation;
  bool floorTherapyAndICU;
  bool pEFEvaluation;
  bool equipmentList;
  bool chat;
  bool help;

  MenuAddRemoveData({
    required this.attendance,
    required this.caseStudy,
    required this.incident,
    required this.briefcase,
    required this.exception,
    required this.medicalTerminology,
    required this.drInteraction,
    required this.dailyJournal,
    required this.formative,
    required this.dailyWeekly,
    required this.midterm,
    required this.summative,
    required this.masteryEvaluation,
    required this.cIEvaluation,
    required this.pEvaluation,
    required this.siteEvaluation,
    required this.volunterEvaluation,
    required this.floorTherapyAndICU,
    required this.pEFEvaluation,
    required this.equipmentList,
    required this.chat,
    required this.help,
  });

  factory MenuAddRemoveData.fromJson(Map<String, dynamic> json) =>
      MenuAddRemoveData(
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
