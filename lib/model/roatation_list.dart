// To parse this JSON data, do
//
//     final rotationListStudentJournal = rotationListStudentJournalFromJson(jsonString);

import 'dart:convert';

RotationListStudentJournal rotationListStudentJournalFromJson(String str) => RotationListStudentJournal.fromJson(json.decode(str));

class RotationListStudentJournal {
  RotationListStudentJournal({
    required this.data,
  });

  List<RotationJournalData> data;

  factory RotationListStudentJournal.fromJson(Map<String, dynamic> json) => RotationListStudentJournal(
        data: List<RotationJournalData>.from(json["data"].map((x) => RotationJournalData.fromJson(x))),
      );
}

class RotationJournalData {
  RotationJournalData({ this.rotationId,  this.title,  this.hospitalTitle,  this.hospitalSiteId});

  String? rotationId;
  String? title;
  String? hospitalTitle;
  String? hospitalSiteId;

  factory RotationJournalData.fromJson(Map<String, dynamic> json) =>
      RotationJournalData(rotationId: json["RotationId"], title: json["Title"], hospitalTitle: json["HospitalTitle"], hospitalSiteId: json["HospitalSiteId"]);
}
