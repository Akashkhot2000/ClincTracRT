// To parse this JSON data, do
//
//     final updateJournalRequest = updateJournalRequestFromJson(jsonString);

import 'dart:convert';

String updateJournalRequestToJson(UpdateJournalRequest data) => json.encode(data.toJson());

class UpdateJournalRequest {
  UpdateJournalRequest({
    required this.journalId,
    required this.userId,
     this.userType,
    required this.rotationId,
    required this.journalDate,
    required this.hospitalSiteId,
    required this.hospitalSiteUnitId,
    required this.studentJournalEntry,
    this.clinicianJournalEntry,
    required this.accessToken,
  });

  String journalId;
  String userId;
  String? userType;
  String rotationId;
  String journalDate;
  // DateTime journalDate;
  String hospitalSiteId;
  String hospitalSiteUnitId;
  String studentJournalEntry;
  String? clinicianJournalEntry;
  String accessToken;

  Map<String, dynamic> toJson() => {
        "JournalId": journalId,
        "UserId": userId,
        "UserType": userType,
        "RotationId": rotationId,
        "JournalDate": journalDate,
        // "JournalDate": journalDate.toIso8601String(),
        "HospitalSiteId": hospitalSiteId,
        "HospitalSiteUnitId": hospitalSiteUnitId,
        "StudentJournalEntry": studentJournalEntry,
        "ClinicianJournalEntry": clinicianJournalEntry,
        "AccessToken": accessToken,
      };
}
