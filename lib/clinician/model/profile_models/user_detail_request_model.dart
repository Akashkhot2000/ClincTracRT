// To parse this JSON data, do
//
//     final editStudentRequest = editStudentRequestFromJson(jsonString);

import 'dart:convert';

EditUserRequest editStudentRequestFromJson(String str) =>
    EditUserRequest.fromJson(json.decode(str));

String editStudentRequestToJson(EditUserRequest data) =>
    json.encode(data.toJson());

class EditUserRequest {
  EditUserRequest({
    this.userId,
    this.userType,
    this.firstName,
    this.lastName,
    this.email,
    this.userName,
    this.address1,
    this.address2,
    this.countryId,
    this.stateId,
    this.city,
    this.zipCode,
    this.accessToken,
  });

  String? userId;
  String? userType;
  String? firstName;
  String? lastName;
  String? email;
  String? userName;
  String? address1;
  String? address2;
  String? countryId;
  String? stateId;
  String? city;
  String? zipCode;
  String? accessToken;

  factory EditUserRequest.fromJson(Map<String, dynamic> json) =>
      EditUserRequest(
        userId: json["UserId"],
        userType: json["UserType"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        userName: json["UserName"],
        address1: json["Address1"],
        address2: json["Address2"],
        countryId: json["CountryId"],
        stateId: json["StateId"],
        city: json["City"],
        zipCode: json["ZipCode"],
        accessToken: json["AccessToken"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "UserType": userType,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "UserName": userName,
        "Address1": address1,
        "Address2": address2,
        "CountryId": countryId,
        "StateId": stateId,
        "City": city,
        "ZipCode": zipCode,
        "AccessToken": accessToken,
      };
}
