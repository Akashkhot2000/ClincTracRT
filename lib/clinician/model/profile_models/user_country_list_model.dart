// To parse this JSON data, do
//
//     final countryList = countryListFromJson(jsonString);

import 'dart:convert';

UserCountryListModel countryListFromJson(String str) =>
    UserCountryListModel.fromJson(json.decode(str));

String countryListToJson(UserCountryListModel data) => json.encode(data.toJson());

class UserCountryListModel {
  UserCountryListModel({
     this.data,
  });

  List<UserCountryListData>? data;

  factory UserCountryListModel.fromJson(Map<String, dynamic> json) => UserCountryListModel(
    data: List<UserCountryListData>.from(json["data"].map((x) => UserCountryListData.fromJson(x as Map<String, dynamic>))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UserCountryListData {
  UserCountryListData({
     this.countryId,
     this.title,
  });

  String? countryId;
  String? title;

  factory UserCountryListData.fromJson(Map<String, dynamic> json) => UserCountryListData(
    countryId: json["countryId"],
    title: json["countryName"],
  );

  Map<String, dynamic> toJson() => {
    "countryId": countryId,
    "countryName": title,
  };
}
