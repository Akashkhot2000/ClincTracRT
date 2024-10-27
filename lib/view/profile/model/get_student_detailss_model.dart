// To parse this JSON data, do
//
//     final studentDetailsResponse = studentDetailsResponseFromJson(jsonString);

import 'dart:convert';

StudentDetailsResponse studentDetailsResponseFromJson(String str) =>
    StudentDetailsResponse.fromJson(json.decode(str));

String studentDetailsResponseToJson(StudentDetailsResponse data) =>
    json.encode(data.toJson());

class StudentDetailsResponse {
  StudentDetailsResponse({
    required this.data,
  });

  Datastd data;

  factory StudentDetailsResponse.fromJson(Map<String, dynamic> json) =>
      StudentDetailsResponse(
        data: Datastd.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Datastd {
  Datastd({
    required this.loggedUserId,
    required this.accessToken,
    required this.loggedUserRankTitle,
    required this.loggedUserFirstName,
    required this.loggedUserMiddleName,
    required this.loggedUserLastName,
    required this.loggedUserEmail,
    required this.loggedUserName,
    required this.loggedUserAddress1,
    required this.loggedUserAddress2,
    required this.countryId,
    required this.countryName,
    required this.stateId,
    required this.stateName,
    required this.city,
    required this.zipCode,
    required this.loggedUserProfile,
  });

  String loggedUserId;
  String accessToken;
  String loggedUserRankTitle;
  String loggedUserFirstName;
  String loggedUserMiddleName;
  String loggedUserLastName;
  String loggedUserEmail;
  String loggedUserName;
  String loggedUserAddress1;
  String loggedUserAddress2;
  String countryId;
  String countryName;
  String stateId;
  String stateName;
  String city;
  String zipCode;
  String loggedUserProfile;

  factory Datastd.fromJson(Map<String, dynamic> json) => Datastd(
        loggedUserId: json["LoggedUserId"],
        accessToken: json["AccessToken"],
        loggedUserRankTitle: json["LoggedUserRankTitle"],
        loggedUserFirstName: json["LoggedUserFirstName"],
        loggedUserMiddleName: json["LoggedUserMiddleName"],
        loggedUserLastName: json["LoggedUserLastName"],
        loggedUserEmail: json["LoggedUserEmail"],
        loggedUserName: json["LoggedUserName"],
        loggedUserAddress1: json["LoggedUserAddress1"],
        loggedUserAddress2: json["LoggedUserAddress2"],
        countryId: json["CountryId"] == null ? '' : json["CountryId"],
        countryName: json["CountryName"] == null ? '' : json["CountryName"],
        stateId: json["StateId"],
        stateName: json["StateName"] == null ? '' : json["StateName"],
        city: json["City"],
        zipCode: json["ZipCode"],
        loggedUserProfile: json["LoggedUserProfile"],
      );

  Map<String, dynamic> toJson() => {
        "LoggedUserId": loggedUserId,
        "AccessToken": accessToken,
        "LoggedUserRankTitle": loggedUserRankTitle,
        "LoggedUserFirstName": loggedUserFirstName,
        "LoggedUserMiddleName": loggedUserMiddleName,
        "LoggedUserLastName": loggedUserLastName,
        "LoggedUserEmail": loggedUserEmail,
        "LoggedUserName": loggedUserName,
        "LoggedUserAddress1": loggedUserAddress1,
        "LoggedUserAddress2": loggedUserAddress2,
        "CountryId": countryId,
        "CountryName": countryName,
        "StateId": stateId,
        "StateName": stateName,
        "City": city,
        "ZipCode": zipCode,
        "LoggedUserProfile": loggedUserProfile,
      };
}
