// To parse this JSON data, do
//
//     final SaveDailyWeeklyEvalRequest = SaveDailyWeeklyEvalRequestFromJson(jsonString);

import 'dart:convert';

String SaveDailyWeeklyEvalRequestToJson(SaveDailyWeeklyEvalRequest data) =>
    json.encode(data.toJson());

class SaveDailyWeeklyEvalRequest {
  SaveDailyWeeklyEvalRequest({
    required this.userId,
    required this.rotationId,
    required this.EvaluationDate,
    required this.MobileNumber,
    required this.SignatureName,
    required this.accessToken,
  });

  String userId;
  String rotationId;
  DateTime EvaluationDate;
  String MobileNumber;
  String SignatureName;
  String accessToken;

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "RotationId": rotationId,
        "EvaluationDate": EvaluationDate.toIso8601String(),
        "MobileNumber": MobileNumber,
        "Signature Name": SignatureName,
        "AccessToken": accessToken,
      };
}
