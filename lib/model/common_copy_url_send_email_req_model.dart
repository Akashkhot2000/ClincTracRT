// To parse this JSON data, do
//
//     final dailyJournalList = dailyJournalListFromJson(jsonString);

import 'dart:convert';

String CommonCopyUrlAndSendEmailRequestToJson(CommonCopyUrlAndSendEmailRequest data) => json.encode(data.toJson());

class CommonCopyUrlAndSendEmailRequest {
  CommonCopyUrlAndSendEmailRequest(
      { this.accessToken,
        this.userId,
        this.evaluationId,
        this.rotationId,
        this.preceptorId,
        this.schoolTopicId,
        this.preceptorNum,
        this.email,
       required this.isSendEmail,
        this.evaluationType,
        });

  String? accessToken;
  String? userId;
  String? evaluationId;
  String? rotationId;
  String? preceptorId;
  String? schoolTopicId;
  String? email;
  String? isSendEmail;
  String? evaluationType;
  String? preceptorNum;

  Map<String, dynamic> toJson() => {
    "AccessToken": accessToken,
    "UserId": userId,
    if (evaluationId != null) "EvaluationId": evaluationId,
    if (rotationId != null) "RotationId": rotationId,
    if (preceptorId != null) "PreceptorId": preceptorId,
    if (schoolTopicId != null) "SchoolTopicId": schoolTopicId,
    if (email != null) "Email": email,
    if (isSendEmail != null) "isSendEmail": isSendEmail,
    if (evaluationType != null) "EvaluationType": evaluationType,
    if (preceptorNum != null) "PreceptorNum": preceptorNum,
  };
}
