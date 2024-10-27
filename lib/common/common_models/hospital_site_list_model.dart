// To parse this JSON data, do
//
//     final hospitalUnitListResponseDart = hospitalUnitListResponseDartFromJson(jsonString);

import 'dart:convert';

HospitalSiteListResponse hospitalSiteListResponseDartFromJson(String str) => HospitalSiteListResponse.fromJson(json.decode(str));

String hospitalSiteListResponseDartToJson(HospitalSiteListResponse data) => json.encode(data.toJson());

class HospitalSiteListResponse {
  HospitalSiteListResponse({
     this.data,
  });

  List<HospitalSiteData>? data  = <HospitalSiteData>[];

  factory HospitalSiteListResponse.fromJson(Map<String, dynamic> json) => HospitalSiteListResponse(
    data: List<HospitalSiteData>.from(json["data"].map((x) => HospitalSiteData.fromJson(x as Map<String, dynamic>))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HospitalSiteData {
  HospitalSiteData({
    this.hospitalSiteId,
    this.title,
  });

  String? hospitalSiteId;
  String? title;

  factory HospitalSiteData.fromJson(Map<String, dynamic> json) => HospitalSiteData(
    hospitalSiteId: json["HospitalSiteId"],
    title: json["HospitalSiteName"],
  );

  Map<String, dynamic> toJson() => {
    "HospitalSiteId": hospitalSiteId,
    "HospitalSiteName": title,
  };
}
