// To parse this JSON data, do
//
//     final studentDetailsResponse = studentDetailsResponseFromJson(jsonString);

import 'dart:convert';

UserDetailModel studentDetailsResponseFromJson(String str) =>
    UserDetailModel.fromJson(json.decode(str));

String studentDetailsResponseToJson(UserDetailModel data) =>
    json.encode(data.toJson());

class UserDetailModel {
  UserDetailModel({
     this.data,
  });

  UserDetailData? data;

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      UserDetailModel(
        data: UserDetailData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class UserDetailData {
  UserDetailData({
     this.loggedUserId,
     this.accessToken,
     this.loggedUserRankTitle,
     this.loggedUserFirstName,
     this.loggedUserMiddleName,
     this.loggedUserLastName,
     this.loggedUserEmail,
     this.loggedUserName,
     this.loggedUserAddress1,
     this.loggedUserAddress2,
     this.countryId,
     this.countryName,
     this.stateId,
     this.stateName,
     this.city,
     this.zipCode,
     this.loggedUserProfile,
  });

  String? loggedUserId;
  String? accessToken;
  String? loggedUserRankTitle;
  String? loggedUserFirstName;
  String? loggedUserMiddleName;
  String? loggedUserLastName;
  String? loggedUserEmail;
  String? loggedUserName;
  String? loggedUserAddress1;
  String? loggedUserAddress2;
  String? countryId;
  String? countryName;
  String? stateId;
  String? stateName;
  String? city;
  String? zipCode;
  String? loggedUserProfile;

  factory UserDetailData.fromJson(Map<String, dynamic> json) => UserDetailData(
    loggedUserId: json["LoggedUserId"] != null ? json["LoggedUserId"] : null,
    accessToken: json["AccessToken"]!= null ? json["AccessToken"] : null,
    loggedUserRankTitle: json["LoggedUserRankTitle"]!= null ? json["LoggedUserRankTitle"] : null,
    loggedUserFirstName: json["LoggedUserFirstName"]!= null ? json["LoggedUserFirstName"] : null,
    loggedUserMiddleName: json["LoggedUserMiddleName"]!= null ? json["LoggedUserMiddleName"] : null,
    loggedUserLastName: json["LoggedUserLastName"]!= null ? json["LoggedUserLastName"] : null,
    loggedUserEmail: json["LoggedUserEmail"]!= null ? json["LoggedUserEmail"] : null,
    loggedUserName: json["LoggedUserName"]!= null ? json["LoggedUserName"] : null,
    loggedUserAddress1: json["LoggedUserAddress1"]!= null ? json["LoggedUserAddress1"] : null,
    loggedUserAddress2: json["LoggedUserAddress2"]!= null ? json["LoggedUserAddress2"] : null,
    countryId: json["CountryId"] == null ? '' : json["CountryId"],
    countryName: json["CountryName"] == null ? '' : json["CountryName"],
    stateId: json["StateId"]!= null ? json["StateId"] : null,
    stateName: json["StateName"] == null ? '' : json["StateName"],
    city: json["City"]!= null ? json["City"] : null,
    zipCode: json["ZipCode"]!= null ? json["ZipCode"] : null,
    loggedUserProfile: json["LoggedUserProfile"]!= null ? json["LoggedUserProfile"] : null,
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
