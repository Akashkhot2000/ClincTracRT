// To parse this JSON data, do
//
//     final editStudentRequest = editStudentRequestFromJson(jsonString);

import 'dart:convert';

EditStudentRequest editStudentRequestFromJson(String str) => EditStudentRequest.fromJson(json.decode(str));

String editStudentRequestToJson(EditStudentRequest data) => json.encode(data.toJson());

class EditStudentRequest {
  EditStudentRequest({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userName,
    required this.address1,
    required this.address2,
    required this.countryId,
    required this.stateId,
    required this.city,
    required this.zipCode,
    required this.accessToken,
  });

  String userId;
  String firstName;
  String lastName;
  String email;
  String userName;
  String address1;
  String address2;
  String countryId;
  String stateId;
  String city;
  String zipCode;
  String accessToken;

  factory EditStudentRequest.fromJson(Map<String, dynamic> json) => EditStudentRequest(
        userId: json["UserId"],
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
