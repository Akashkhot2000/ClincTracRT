// To parse this JSON data, do
//
//     final rotationListStudentJournal = rotationListStudentJournalFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/clinician/view/dr_intraction/model/uni_rotation_list_model.dart';


SMRotationListStudentJournal rotationListStudentJournalFromJson(String str) => SMRotationListStudentJournal.fromJson(json.decode(str));

class SMRotationListStudentJournal {
  SMRotationListStudentJournal({
    required this.data,
  });

  List<UniRotationJournalData> data;

  factory SMRotationListStudentJournal.fromJson(Map<String, dynamic> json) => SMRotationListStudentJournal(
    data: List<UniRotationJournalData>.from(json["data"].map((x) => UniRotationJournalData.fromJson(x))),
  );
}

// class RotationJournalData {
//   RotationJournalData({ this.rotationId,  this.title,  this.hospitalTitle,  this.hospitalSiteId});
//
//   String? rotationId;
//   String? title;
//   String? hospitalTitle;
//   String? hospitalSiteId;
//
//   factory RotationJournalData.fromJson(Map<String, dynamic> json) =>
//       RotationJournalData(rotationId: json["RotationId"], title: json["Title"], hospitalTitle: json["HospitalTitle"], hospitalSiteId: json["HospitalSiteId"]);
// }
