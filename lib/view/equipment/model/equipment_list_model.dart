// To parse this JSON data, do
//
//     final AllAllRotaionListModel = AllAllRotaionListModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../model/common_pager_model.dart';

EquipmentListModel AllRotationListModelFromJson(String str) =>
    EquipmentListModel.fromJson(json.decode(str));

class EquipmentListModel {
  EquipmentListModel({
    required this.data,
    required this.pager,
  });

  List<EquipmentListData> data;
  Pager pager;

  factory EquipmentListModel.fromJson(Map<String, dynamic> json) =>
      EquipmentListModel(
        data: List<EquipmentListData>.from(
            json["data"].map((x) => EquipmentListData.fromJson(x))),
        pager: Pager.fromJson(json['pager']),
      );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "pager": pager.toJson(),
  };
}

class EquipmentListData {
  EquipmentListData({
    required this.equipmentDate,
    required this.rotationName,
    required this.clinicianFullName,
  });


  DateTime equipmentDate;
  String rotationName;
  String clinicianFullName;

  factory EquipmentListData.fromJson(Map<String, dynamic> json) {
    DateTime convertDateToUTC(String dateUtc) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
      var formattedTime = dateTime.toLocal();
      return formattedTime;
    }

    return EquipmentListData(
      equipmentDate: DateTime.parse(json["EquipmentDate"]),
      rotationName: json["RotationName"],
      clinicianFullName: json["ClinicianFullName"],
    );
  }

  Map<String, dynamic> toJson() => {
    "EquipmentDate": equipmentDate,
    "RotationName": rotationName,
    "ClinicianFullName": clinicianFullName,

  };
}
