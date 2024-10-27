// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

WebRedirectModel webRedirectModelFromJson(String str) => WebRedirectModel.fromJson(json.decode(str));

String webRedirectModelToJson(WebRedirectModel data) => json.encode(data.toJson());

class WebRedirectModel {
  WebRedirectModel({
    required this.type,
    required this.statusType,
  });

  String type;
  String statusType;

  factory WebRedirectModel.fromJson(Map<String, dynamic> json) => WebRedirectModel(
    type: json["Type"],
    statusType: json["StatusType"],
  );

  Map<String, dynamic> toJson() => {
    "Type": type,
    "StatusType": statusType,
  };
}
