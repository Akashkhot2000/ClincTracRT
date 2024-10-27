// To parse this JSON data, do
//
//     final saveJournalRequest = saveJournalRequestFromJson(jsonString);

import 'dart:convert';

String saveJournalRequestToJson(SaveJournalRequest data) => json.encode(data.toJson());

class SaveJournalRequest {
  SaveJournalRequest({
    required this.userId,
    required this.rotationId,
    required this.journalDate,
    required this.hospitalSiteId,
    required this.hospitalSiteUnitId,
    required this.studentJournalEntry,
    required this.accessToken,
  });

  String userId;
  String rotationId;
  // String journalDate;
  DateTime journalDate;
  String hospitalSiteId;
  String hospitalSiteUnitId;
  String studentJournalEntry;
  String accessToken;

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "RotationId": rotationId,
        // "JournalDate": journalDate,
        "JournalDate": journalDate.toIso8601String(),
        "HospitalSiteId": hospitalSiteId,
        "HospitalSiteUnitId": hospitalSiteUnitId,
        "StudentJournalEntry": studentJournalEntry,
        "AccessToken": accessToken,
      };
}
