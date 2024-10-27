import 'dart:convert';

PEFTypeListModel procedureCountDataModelFromJson(String str) =>
    PEFTypeListModel.fromJson(json.decode(str));

String procedureCountDataModelToJson(PEFTypeListModel data) =>
    json.encode(data.toJson());

class PEFTypeListModel {
  PEFTypeListModel({
    this.id,
    required this.typeName,
    required this.type,
  });

  String? id;
  String typeName;
  String type;

  factory PEFTypeListModel.fromJson(Map<String, dynamic> json) =>
      PEFTypeListModel(
        id: json["Id"],
        typeName: json["Name"],
        type: json["Type"],
      );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": typeName,
    "Type": type,
  };
}
