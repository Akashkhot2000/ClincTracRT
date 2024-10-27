// To parse this JSON data, do
//
//     final hospitalUnitListResponseDart = hospitalUnitListResponseDartFromJson(jsonString);

import 'dart:convert';

HospitalUnitListResponseDart hospitalUnitListResponseDartFromJson(String str) => HospitalUnitListResponseDart.fromJson(json.decode(str));

String hospitalUnitListResponseDartToJson(HospitalUnitListResponseDart data) => json.encode(data.toJson());

class HospitalUnitListResponseDart {
  HospitalUnitListResponseDart({
    required this.data,
  });

  List<Datum> data;

  factory HospitalUnitListResponseDart.fromJson(Map<String, dynamic> json) => HospitalUnitListResponseDart(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
     this.hospitalSiteUnitId,
     this.title,
  });

  String? hospitalSiteUnitId;
  String? title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        hospitalSiteUnitId: json["HospitalSiteUnitId"],
    title: json["HospitalSiteUnitName"],
      );

  Map<String, dynamic> toJson() => {
        "HospitalSiteUnitId": hospitalSiteUnitId,
        "HospitalSiteUnitName": title,
      };
}
