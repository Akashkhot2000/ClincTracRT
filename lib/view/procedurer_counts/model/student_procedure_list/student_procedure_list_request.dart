import 'dart:convert';

String StudentProceduerRequestToJson(StudentProceduerRequest data) => json.encode(data.toJson());

class StudentProceduerRequest {
  StudentProceduerRequest({
    required this.accessToken,
    required this.userId,
    required this.procedureCategoryId,
    required this.pageNo,
    required this.RecordsPerPage,
    this.SearchText,
  });

  String accessToken;
  String userId;
  String procedureCategoryId;
  String pageNo;
  String RecordsPerPage;
  String? SearchText;

  Map<String, dynamic> toJson() => {
    "AccessToken": accessToken,
    "UserId": userId,
    "ProcedureCategoryId": procedureCategoryId,
    "PageNo": pageNo,
    "RecordsPerPage": RecordsPerPage,
    if (SearchText != null) "SearchText": SearchText,
  };
}
