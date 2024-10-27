// To parse this JSON data, do
//
//     final clinicianDataList = clinicianDataListFromJson(jsonString);

import 'dart:convert';

ClinicianDataList clinicianDataListFromJson(String str) => ClinicianDataList.fromJson(json.decode(str));

String clinicianDataListToJson(ClinicianDataList data) => json.encode(data.toJson());

class ClinicianDataList {
    ClinicianDataList({
        required this.data,
    });

    List<ClinicianData> data = <ClinicianData>[];

    factory ClinicianDataList.fromJson(Map<String, dynamic> json) => ClinicianDataList(
        data: List<ClinicianData>.from(json["data"].map((x) => ClinicianData.fromJson(x as Map<String, dynamic>))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ClinicianData {
    ClinicianData({
         this.clinicianId,
         this.title,
    });

    String? clinicianId;
    String? title;

    factory ClinicianData.fromJson(Map<String, dynamic> json) => ClinicianData(
        clinicianId: json["ClinicianId"],
        title: json["ClinicianName"],
    );

    Map<String, dynamic> toJson() => {
        "ClinicianId": clinicianId,
        "ClinicianName": title,
    };
}
