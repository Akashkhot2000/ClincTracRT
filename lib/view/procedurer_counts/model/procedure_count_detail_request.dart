// To parse this JSON data, do
//
//     final dailyJournalList = dailyJournalListFromJson(jsonString);

import 'dart:convert';

String ProcedureCountDetailRequestToJson(ProcedureCountDetailRequest data) => json.encode(data.toJson());

class ProcedureCountDetailRequest {
  ProcedureCountDetailRequest({
    required this.accessToken,
    required this.userId,
    required this.RotationId,
    required this.procedureCategoryId,
    required this.pageNo,
    required this.RecordsPerPage,
    this.SearchText,
  });

  String accessToken;
  String userId;
  String RotationId;
  String procedureCategoryId;
  String pageNo;
  String RecordsPerPage;
  String? SearchText;

  Map<String, dynamic> toJson() => {
    "AccessToken": accessToken,
    "UserId": userId,
    "RotationId": RotationId,
    "ProcedureCategoryId": procedureCategoryId,
    "PageNo": pageNo,
    "RecordsPerPage": RecordsPerPage,
    if (SearchText != null) "SearchText": SearchText,
  };
}
