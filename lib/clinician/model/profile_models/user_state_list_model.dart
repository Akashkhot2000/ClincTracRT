import 'dart:convert';

UserStateListModel stateListFromJson(String str) => UserStateListModel.fromJson(json.decode(str));

String stateListToJson(UserStateListModel data) => json.encode(data.toJson());

class UserStateListModel {
  UserStateListModel({
     this.data,
  });

  List<UserStateListData>? data;

  factory UserStateListModel.fromJson(Map<String, dynamic> json) => UserStateListModel(
    data: List<UserStateListData>.from(json["data"].map((x) => UserStateListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UserStateListData {
  UserStateListData({
     this.stateId,
     this.title,
  });

  String? stateId;
  String? title;

  factory UserStateListData.fromJson(Map<String, dynamic> json) => UserStateListData(
    stateId: json["stateId"],
    title: json["stateName"],
  );

  Map<String, dynamic> toJson() => {
    "stateId": stateId,
    "stateName": title,
  };
}
