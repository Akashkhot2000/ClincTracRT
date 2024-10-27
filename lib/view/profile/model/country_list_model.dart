// To parse this JSON data, do
//
//     final countryList = countryListFromJson(jsonString);

import 'dart:convert';

CountryList countryListFromJson(String str) =>
    CountryList.fromJson(json.decode(str));

String countryListToJson(CountryList data) => json.encode(data.toJson());

class CountryList {
  CountryList({
    required this.data,
  });

  List<Datum> data;

  factory CountryList.fromJson(Map<String, dynamic> json) => CountryList(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.countryId,
    required this.countryName,
  });

  String countryId;
  String countryName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        countryId: json["countryId"],
        countryName: json["countryName"],
      );

  Map<String, dynamic> toJson() => {
        "countryId": countryId,
        "countryName": countryName,
      };
}
