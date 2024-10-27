import 'dart:convert';

CommonTypeListModel commonTypeDataModelFromJson(String str) =>
    CommonTypeListModel.fromJson(json.decode(str));

String commonTypeDataModelToJson(CommonTypeListModel data) =>
    json.encode(data.toJson());

class CommonTypeListModel {
  CommonTypeListModel({
    this.id,
    required this.typeName,
    required this.type,
  });

  String? id;
  String typeName;
  String type;

  factory CommonTypeListModel.fromJson(Map<String, dynamic> json) =>
      CommonTypeListModel(
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
