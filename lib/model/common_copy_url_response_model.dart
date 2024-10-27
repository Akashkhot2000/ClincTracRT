import 'dart:convert';

CopyUrlResponseModel copyUrlResponseModelFromJson(String str) => CopyUrlResponseModel.fromJson(json.decode(str));

String copyUrlResponseModelToJson(CopyUrlResponseModel data) => json.encode(data.toJson());

class CopyUrlResponseModel {
  CopyUrlResponseModel({
    required this.data,
  });

  CopyUrlData data;

  factory CopyUrlResponseModel.fromJson(Map<String, dynamic> json) => CopyUrlResponseModel(
    data: CopyUrlData.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class CopyUrlData {
  String? evaluationType;
  String? copyUrl;

  CopyUrlData({this.evaluationType, this.copyUrl,});

  factory CopyUrlData.fromJson(Map<String, dynamic> json) => CopyUrlData(
    evaluationType: json['EvaluationType'].toString(),
    copyUrl: json['URL'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'EvaluationType': evaluationType,
    'URL': copyUrl,
  };
}
