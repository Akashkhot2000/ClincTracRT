// To parse this JSON data, do
//
//     final JournalDetailsRequest = JournalDetailsRequestFromJson(jsonString);

import 'dart:convert';

String JournalDetailsRequestToJson(JournalDetailsRequest data) => json.encode(data.toJson());

class JournalDetailsRequest {
  JournalDetailsRequest({
    required this.accessToken,
    required this.userId,
    this.rotationId,
    required this.journalId,
  });

  String accessToken;
  String userId;
  String? rotationId;
  String journalId;

  Map<String, dynamic> toJson() => {
        "AccessToken": accessToken,
        "UserId": userId,
        if (rotationId != null) "RotationId": rotationId,
        "JournalId": journalId,
      };
}
