// To parse this JSON data, do
//
//     final dailyJournalList = dailyJournalListFromJson(jsonString);

import 'dart:convert';

String ProceduerCountRequestToJson(ProceduerCountRequest data) => json.encode(data.toJson());

class ProceduerCountRequest {
  ProceduerCountRequest({
    required this.accessToken,
    required this.userId,
    required this.RotationId,
    required this.pageNo,
    required this.RecordsPerPage,
    // this.SearchText,
  });

  String accessToken;
  String userId;
  String RotationId;
  String pageNo;
  String RecordsPerPage;
  // String? SearchText;

  Map<String, dynamic> toJson() => {
    "AccessToken": accessToken,
    "UserId": userId,
    "RotationId": RotationId,
    "PageNo": pageNo,
    "RecordsPerPage": RecordsPerPage,
    // if (SearchText != null) "SearchText": SearchText,
  };
}
