// To parse this JSON data, do
//
//     final dailyJournalList = dailyJournalListFromJson(jsonString);

import 'dart:convert';

String MenuAddRemoveRequestToJson(MenuAddRemoveRequest data) => json.encode(data.toJson());

class MenuAddRemoveRequest {
  MenuAddRemoveRequest({
    required this.accessToken,
    required this.userId,
  });

  String accessToken;
  String userId;

  Map<String, dynamic> toJson() => {
    "AccessToken": accessToken,
    "UserId": userId,
  };
}
