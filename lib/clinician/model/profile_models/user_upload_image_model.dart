import 'dart:convert';

UserPhotoUploadRequest photoUploadRequestFromJson(String str) =>
    UserPhotoUploadRequest.fromJson(json.decode(str));

String photoUploadRequestToJson(UserPhotoUploadRequest data) =>
    json.encode(data.toJson());

class UserPhotoUploadRequest {
  UserPhotoUploadRequest(
      {this.userId, this.accessToken, this.image, this.userType});

  String? userId;
  String? accessToken;
  String? image;
  String? userType;

  factory UserPhotoUploadRequest.fromJson(Map<String, dynamic> json) =>
      UserPhotoUploadRequest(
        userId: json["UserId"],
        accessToken: json["AccessToken"],
        image: json["Image"],
        userType: json["UserType"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "AccessToken": accessToken,
        "Image": image,
        "UserType": userType
      };
}
