// To parse this JSON data, do
//
//     final dailyJournalDetailsResponse = dailyJournalDetailsResponseFromJson(jsonString);

import 'dart:convert';

DailyJournalDetailsResponse dailyJournalDetailsResponseFromJson(String str) => DailyJournalDetailsResponse.fromJson(json.decode(str));

class DailyJournalDetailsResponse {
  DailyJournalDetailsResponse({
    required this.data,
  });

  DailyJournalDetailsData data;

  factory DailyJournalDetailsResponse.fromJson(Map<String, dynamic> json) => DailyJournalDetailsResponse(
        data: DailyJournalDetailsData.fromJson(json["data"]),
      );
}

class DailyJournalDetailsData {
  DailyJournalDetailsData({
    required this.journalId,
    required this.rotationId,
    required this.rotationName,
    required this.hospitalSiteUnitId,
    required this.hospitalSiteunitName,
    required this.hospitalSiteId,
    required this.hospitalName,
    required this.journalDate,
    required this.schoolResponse,
    required this.clinicianResponse,
    required this.studentResponseForEdit,
    required this.schoolResponseForEdit,
    required this.clinicianResponseForEdit,
  });

  String journalId;
  String rotationId;
  String rotationName;
  String hospitalSiteUnitId;
  String hospitalSiteunitName;
  String hospitalSiteId;
  String hospitalName;
  String journalDate;
  // DateTime journalDate;
  bool schoolResponse;
  bool clinicianResponse;
  String studentResponseForEdit;
  String schoolResponseForEdit;
  String clinicianResponseForEdit;

  factory DailyJournalDetailsData.fromJson(Map<String, dynamic> json) => DailyJournalDetailsData(
        journalId: json["JournalId"],
        rotationId: json["RotationId"],
        rotationName: json["RotationName"],
        hospitalSiteUnitId: json["HospitalSiteUnitId"],
        hospitalSiteunitName: json["HospitalSiteunitName"],
        hospitalSiteId: json["HospitalSiteId"],
        hospitalName: json["HospitalName"],
        journalDate: json["JournalDate"],
        // journalDate: DateTime.parse(json["JournalDate"]),
        schoolResponse: json["SchoolResponse"],
        clinicianResponse: json["ClinicianResponse"],
        studentResponseForEdit: json["StudentResponseForEdit"],
        schoolResponseForEdit: json["SchoolResponseForEdit"],
        clinicianResponseForEdit: json["ClinicianResponseForEdit"],
      );
}
