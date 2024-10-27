import 'dart:convert';

PhotoUploadRequest photoUploadRequestFromJson(String str) => PhotoUploadRequest.fromJson(json.decode(str));

String photoUploadRequestToJson(PhotoUploadRequest data) => json.encode(data.toJson());

class PhotoUploadRequest {
  PhotoUploadRequest({
    required this.userId,
    required this.accessToken,
    required this.image,
  });

  String userId;
  String accessToken;
  String image;

  factory PhotoUploadRequest.fromJson(Map<String, dynamic> json) => PhotoUploadRequest(
        userId: json["UserId"],
        accessToken: json["AccessToken"],
        image: json["Image"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "AccessToken": accessToken,
        "Image": image,
      };
}
