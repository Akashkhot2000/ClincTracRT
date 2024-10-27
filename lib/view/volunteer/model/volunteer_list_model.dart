// To parse this JSON data, do
//
//     final rotationListModel = rotationListModelFromJson(jsonString);

import 'dart:convert';

import 'package:clinicaltrac/model/common_pager_model.dart';
import 'package:intl/intl.dart';

VolunteerListModel volunteerListModelFromJson(String str) =>
    VolunteerListModel.fromJson(json.decode(str));

String volunteerListModelToJson(VolunteerListModel data) =>
    json.encode(data.toJson());

class VolunteerListModel {
  VolunteerListModel({
    this.data,
    this.pager,
  });

  VolunteerListData? data;
  Pager? pager;

  factory VolunteerListModel.fromJson(Map<String, dynamic> json) =>
      VolunteerListModel(
        data: json["data"] != null
            ? VolunteerListData.fromJson(json["data"])
            : null,
        pager: json['pager'] != null ? Pager.fromJson(json['pager']) : null,
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "pager": pager!.toJson(),
      };
}

class VolunteerListData {
  VolunteerListData({
    this.isClockedIn,
    this.rotationList,
  });

  bool? isClockedIn;
  List<Rotation>? rotationList;

  factory VolunteerListData.fromJson(Map<String, dynamic> json) =>
      VolunteerListData(
        isClockedIn: json["TotalTime"] != null ? json["TotalTime"] : null,
        rotationList: json["VolunteerList"] != null
            ? List<Rotation>.from(json["VolunteerList"]
                .map((x) => Rotation.fromJson(x as Map<String, dynamic>)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "TotalTime": isClockedIn,
        "VolunteerList":
            List<dynamic>.from(rotationList!.map((x) => x.toJson())),
      };
}

class Rotation {
  Rotation({
    this.volunteerId,
    this.volunteerDate,
    this.rotationId,
    this.rotationName,
    this.hospitalSiteId,
    this.hospitalSiteName,
    this.orgnizationName,
    this.dateOfClinicianSign,
    this.dateOfSchoolSign,
    this.course,
    this.timeSpent,
  });

  String? volunteerId;
  DateTime? volunteerDate;
  String? rotationId;
  String? rotationName;
  String? hospitalSiteId;
  String? hospitalSiteName;
  String? orgnizationName;
  DateTime? dateOfClinicianSign;
  DateTime? dateOfSchoolSign;
  String? course;
  String? timeSpent;

  factory Rotation.fromJson(Map<String, dynamic> json) {
    DateTime convertDateToUTC(String dateUtc) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
      var formattedTime = dateTime.toLocal();
      return formattedTime;
    }

    return Rotation(
      volunteerId: json["VolunteerId"] != null ? json["VolunteerId"] : null,
      volunteerDate: json["VolunteerDate"] != null
          ? convertDateToUTC(json["VolunteerDate"])
          : null,
      rotationId: json["RotationId"] != null ? json["RotationId"] : null,
      rotationName: json["RotationName"] != null ? json["RotationName"] : null,
      hospitalSiteId:
          json["HospitalSiteId"] != null ? json["HospitalSiteId"] : null,
      hospitalSiteName:
          json["HospitalSiteName"] != null ? json["HospitalSiteName"] : null,
      orgnizationName:
          json["OrgnizationName"] != null ? json["OrgnizationName"] : null,
      dateOfClinicianSign: json["DateOfClinicianSign"] != null
          ? json["DateOfClinicianSign"] != ""
              ? DateTime.parse(json["DateOfClinicianSign"])
              : null
          : null,
      dateOfSchoolSign: json["DateOfSchoolSign"] != null
          ? json["DateOfSchoolSign"] != ""
              ? DateTime.parse(json["DateOfSchoolSign"])
              : null
          : null,
      course: json["Course"] != null ? json["Course"] : null,
      timeSpent: json["TimeSpent"] != null ? json["TimeSpent"] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "VolunteerId": volunteerId,
        "VolunteerDate": volunteerDate!.toIso8601String(),
        "RotationId": rotationId,
        "RotationName": rotationName,
        "HospitalSiteId": hospitalSiteId,
        "HospitalSiteName": hospitalSiteName,
        "OrgnizationName": orgnizationName,
        "DateOfClinicianSign": dateOfClinicianSign,
        "DateOfSchoolSign": dateOfSchoolSign,
        "Course": course,
        "TimeSpent": timeSpent,
      };
}
