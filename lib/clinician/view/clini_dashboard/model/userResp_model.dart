// To parse this JSON data, do
//
//     final userLoginResponse = userLoginResponseFromJson(jsonString);

import 'dart:convert';

UserLoginResponseModel userLoginResponseFromJson(String str) => UserLoginResponseModel.fromJson(json.decode(str));

String userLoginResponseToJson(UserLoginResponseModel data) => json.encode(data.toJson());

class UserLoginResponseModel {
  UserLoginResponseModel({
     this.data,
  });

  Data? data;

  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) => UserLoginResponseModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    required this.loggedUserId,
    required this.accessToken,
    required this.loggedUserRankTitle,
    required this.loggedUserRole,
    required this.loggedUserRoleType,
    required this.loggedUserType,
    required this.loggedUserFirstName,
    required this.loggedUserMiddleName,
    required this.loggedUserLastName,
    required this.loggedUserEmail,
    required this.loggedUserProfile,
    required this.loggedUserSchoolName,
    required this.loggedUserSchoolType,
    required this.loggedUserloginhistoryId,
  });

  String loggedUserId;
  String accessToken;
  String loggedUserRankTitle;
  String loggedUserRole;
  String loggedUserRoleType;
  String loggedUserType;
  String loggedUserFirstName;
  String loggedUserMiddleName;
  String loggedUserLastName;
  String loggedUserEmail;
  String loggedUserProfile;
  String loggedUserSchoolName;
  String loggedUserSchoolType;
  String loggedUserloginhistoryId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    loggedUserId: json["LoggedUserId"],
    accessToken: json["AccessToken"],
    loggedUserRankTitle: json["LoggedUserRankTitle"] == null ? "" : json["LoggedUserRankTitle"],
    loggedUserRole: json["LoggedUserRole"] == null ? "" : json["LoggedUserRole"],
    loggedUserRoleType: json["LoggedUserRoleType"] == null ? "" : json["LoggedUserRoleType"],
    loggedUserType: json["LoggedUserType"] == null ? "" : json["LoggedUserType"],
    loggedUserFirstName: json["LoggedUserFirstName"],
    loggedUserMiddleName: json["LoggedUserMiddleName"],
    loggedUserLastName: json["LoggedUserLastName"],
    loggedUserEmail: json["LoggedUserEmail"],
    loggedUserProfile: json["LoggedUserProfile"],
    loggedUserSchoolName: json["LoggedUserSchoolName"],
    loggedUserSchoolType: json["LoggedUserSchoolType"],
    loggedUserloginhistoryId: json["LoggedUserloginhistoryId"],
  );

  Map<String, dynamic> toJson() => {
    "LoggedUserId": loggedUserId,
    "AccessToken": accessToken,
    "LoggedUserRankTitle": loggedUserRankTitle,
    "LoggedUserRole": loggedUserRole,
    "LoggedUserRoleType": loggedUserRoleType,
    "LoggedUserType": loggedUserType,
    "LoggedUserFirstName": loggedUserFirstName,
    "LoggedUserMiddleName": loggedUserMiddleName,
    "LoggedUserLastName": loggedUserLastName,
    "LoggedUserEmail": loggedUserEmail,
    "LoggedUserProfile": loggedUserProfile,
    "LoggedUserSchoolName": loggedUserSchoolName,
    "LoggedUserSchoolType": loggedUserSchoolType,
    "LoggedUserloginhistoryId": loggedUserloginhistoryId,
  };
}
