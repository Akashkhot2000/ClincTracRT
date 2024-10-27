// To parse this JSON data, do
//
//     final dailyJournalList = dailyJournalListFromJson(jsonString);

import 'dart:convert';

String CreateCheckoffRequestToJson(CreateCheckoffRequestRequest data) => json.encode(data.toJson());

class CreateCheckoffRequestRequest {
  CreateCheckoffRequestRequest({
    required this.accessToken,
    required this.userId,
    required this.RotationId,
    required this.checkoffDate,
    required this.hospitalSiteId,
    required this.topicId,
    required this.clinicianId,
    this.standardPreceptorMob,
    this.preceptorMobile1,
    this.preceptorMobile2,
    this.preceptorMobile3,
    this.preceptorMobile4,
    this.preceptorMobile5,
    this.isActiveHospitalsite,
  });

  String accessToken;
  String userId;
  String RotationId;
  String checkoffDate;
  String hospitalSiteId;
  String topicId;
  String clinicianId;
  String? standardPreceptorMob;
  String? preceptorMobile1;
  String? preceptorMobile2;
  String? preceptorMobile3;
  String? preceptorMobile4;
  String? preceptorMobile5;
  String? isActiveHospitalsite;

  Map<String, dynamic> toJson() => {
    "AccessToken": accessToken,
    "UserId": userId,
    "RotationId": RotationId,
    "CheckoffDate": checkoffDate,
    "HospitalSiteId": hospitalSiteId,
    "TopicId": topicId,
    "ClinicianId": clinicianId,
    "StandardPreceptorMob": standardPreceptorMob,
    "PreceptorMobile1": preceptorMobile1,
    "PreceptorMobile2": preceptorMobile2,
    "PreceptorMobile3": preceptorMobile3,
    "PreceptorMobile4": preceptorMobile4,
    "PreceptorMobile5": preceptorMobile5,
    "IsActiveHospitalsite": isActiveHospitalsite,
  };
}
