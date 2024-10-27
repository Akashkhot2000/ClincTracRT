// To parse this JSON data, do
//
//     final stateList = stateListFromJson(jsonString);

import 'dart:convert';

StateList stateListFromJson(String str) => StateList.fromJson(json.decode(str));

String stateListToJson(StateList data) => json.encode(data.toJson());

class StateList {
  StateList({
    required this.data,
  });

  List<DatumState> data;

  factory StateList.fromJson(Map<String, dynamic> json) => StateList(
        data: List<DatumState>.from(json["data"].map((x) => DatumState.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumState {
  DatumState({
    required this.stateId,
    required this.stateName,
  });

  String stateId;
  String stateName;

  factory DatumState.fromJson(Map<String, dynamic> json) => DatumState(
        stateId: json["stateId"],
        stateName: json["stateName"],
      );

  Map<String, dynamic> toJson() => {
        "stateId": stateId,
        "stateName": stateName,
      };
}
