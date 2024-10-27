import 'dart:convert';

String ProceduerCountStepsRequestToJson(ProceduerCountStepsRequest data) => json.encode(data.toJson());

class ProceduerCountStepsRequest {
  ProceduerCountStepsRequest({
    required this.accessToken,
    required this.userId,
    required this.procedureCountsCode,
    required this.procedureCountTopicId,
    required this.pageNo,
    required this.RecordsPerPage,
    this.SearchText,
  });

  String accessToken;
  String userId;
  String procedureCountsCode;
  String procedureCountTopicId;
  String pageNo;
  String RecordsPerPage;
  String? SearchText;

  Map<String, dynamic> toJson() => {
    "AccessToken": accessToken,
    "UserId": userId,
    "ProcedureCountsCode": procedureCountsCode,
    "ProcedureCountTopicId": procedureCountTopicId,
    "PageNo": pageNo,
    "RecordsPerPage": RecordsPerPage,
    if (SearchText != null) "SearchText": SearchText,
  };
}
