// To parse this JSON data, do
//
//     final updateJournalRequest = updateJournalRequestFromJson(jsonString);

import 'dart:convert';

String updateJournalRequestToJson(UpdateInteractionRequestModel data) =>
    json.encode(data.toJson());

class UpdateInteractionRequestModel {
  UpdateInteractionRequestModel({
    this.interactionId,
    this.userId,
    this.userType,
    this.rotationId,
    this.interactionDate,
    this.clinicianDate,
    this.hospitalSiteId,
    this.hospitalSiteUnitId,
    this.studentJournalEntry,
    this.amountTimeSpent,
    this.pointsAwarded,
    this.clinicianResponse,
    this.accessToken,
  });

  String? interactionId;
  String? userId;
  String? userType;
  String? rotationId;
  String? interactionDate;
  String? clinicianDate;
  String? hospitalSiteId;
  String? hospitalSiteUnitId;
  String? studentJournalEntry;
  String? amountTimeSpent;
  String? pointsAwarded;
  String? clinicianResponse;
  String? accessToken;

  Map<String, dynamic> toJson() => {
        "InteractionId": interactionId,
        "UserId": userId,
        "UserType": userType,
        "RotationId": rotationId,
        "InteractionDate": interactionDate,
        "ClinicianDate": clinicianDate,
        "HospitalSiteId": hospitalSiteId,
        "HospitalSiteUnitId": hospitalSiteUnitId,
        "StudentJournalEntry": studentJournalEntry,
        "AmountTimeSpent": amountTimeSpent,
        "PointsAwarded": pointsAwarded,
        "ClinicianResponse": clinicianResponse,
        "AccessToken": accessToken,
      };
}
