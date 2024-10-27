class ClinicianDrInteractionModel {
  int? status;
  bool? success;
  String? message;
  ClinicianDrInteractionPayload? payload;

  ClinicianDrInteractionModel(
      {this.status, this.success, this.message, this.payload});

  ClinicianDrInteractionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    payload =
    json['payload'] != null ? new ClinicianDrInteractionPayload.fromJson(json['payload']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    return data;
  }
}

class ClinicianDrInteractionPayload {
  ClinicianDrInteractionData? data;
  Pager? pager;

  ClinicianDrInteractionPayload({this.data, this.pager});

  ClinicianDrInteractionPayload.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ClinicianDrInteractionData.fromJson(json['data']) : null;
    pager = json['pager'] != null ? new Pager.fromJson(json['pager']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.pager != null) {
      data['pager'] = this.pager!.toJson();
    }
    return data;
  }
}

class ClinicianDrInteractionData {
  String? interactionDescriptionCount;
  List<ClinicianInteractionList>? interactionList;

  ClinicianDrInteractionData({this.interactionDescriptionCount, this.interactionList});

  ClinicianDrInteractionData.fromJson(Map<String, dynamic> json) {
    interactionDescriptionCount = json['InteractionDescriptionCount'];
    if (json['InteractionList'] != null) {
      interactionList = <ClinicianInteractionList>[];
      json['InteractionList'].forEach((v) {
        interactionList!.add(new ClinicianInteractionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InteractionDescriptionCount'] = this.interactionDescriptionCount;
    if (this.interactionList != null) {
      data['InteractionList'] =
          this.interactionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClinicianInteractionList {
  String? interactionId;
  DateTime? interactionDate;
  String? clinicianId;
  String? clinicianFullName;
  String? studentFullName;
  String? rotationId;
  String? rotationName;
  String? hospitalsitesName;
  String? hospitalSiteUnitId;
  String? hospitalUnitName;
  String? rank;
  String? timeSpent;
  String? pointsAwarded;
  String? drInteractionPoint;
  String? clinicianDate;
  String? schoolDate;
  String? studentResponse;
  String? clinicianResponse;
  String? schoolResponse;
  bool? isExpire;

  ClinicianInteractionList(
      {this.interactionId,
        this.interactionDate,
        this.clinicianId,
        this.clinicianFullName,
        this.studentFullName,
        this.rotationId,
        this.rotationName,
        this.hospitalsitesName,
        this.hospitalSiteUnitId,
        this.hospitalUnitName,
        this.rank,
        this.timeSpent,
        this.pointsAwarded,
        this.drInteractionPoint,
        this.clinicianDate,
        this.schoolDate,
        this.studentResponse,
        this.clinicianResponse,
        this.schoolResponse,
        this.isExpire});

  ClinicianInteractionList.fromJson(Map<String, dynamic> json) {
    interactionId = json['InteractionId'];
    interactionDate =DateTime.parse( json['InteractionDate']);
    clinicianId = json['ClinicianId'];
    clinicianFullName = json['ClinicianFullName'];
    studentFullName = json['StudentFullName'];
    rotationId = json['RotationId'];
    rotationName = json['RotationName'];
    hospitalsitesName = json['HospitalsitesName'];
    hospitalSiteUnitId = json['HospitalSiteUnitId'];
    hospitalUnitName = json['HospitalUnitName'];
    rank = json['Rank'];
    timeSpent = json['TimeSpent'];
    pointsAwarded = json['PointsAwarded'];
    drInteractionPoint = json['DrInteractionPoint'];
    clinicianDate = json['ClinicianDate'];
    schoolDate = json['SchoolDate'];
    studentResponse = json['StudentResponse'];
    clinicianResponse = json['ClinicianResponse'];
    schoolResponse = json['SchoolResponse'];
    isExpire = json['isExpire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['InteractionId'] = this.interactionId;
    data['InteractionDate'] = "${this.interactionDate!.year.toString().padLeft(4, '0')}-${interactionDate!.month.toString().padLeft(2, '0')}-${interactionDate!.day.toString().padLeft(2, '0')}";
    data['ClinicianId'] = this.clinicianId;
    data['ClinicianFullName'] = this.clinicianFullName;
    data['StudentFullName'] = this.studentFullName;
    data['RotationId'] = this.rotationId;
    data['RotationName'] = this.rotationName;
    data['HospitalsitesName'] = this.hospitalsitesName;
    data['HospitalSiteUnitId'] = this.hospitalSiteUnitId;
    data['HospitalUnitName'] = this.hospitalUnitName;
    data['Rank'] = this.rank;
    data['TimeSpent'] = this.timeSpent;
    data['PointsAwarded'] = this.pointsAwarded;
    data['DrInteractionPoint'] = this.drInteractionPoint;
    data['ClinicianDate'] = this.clinicianDate;
    data['SchoolDate'] = this.schoolDate;
    data['StudentResponse'] = this.studentResponse;
    data['ClinicianResponse'] = this.clinicianResponse;
    data['SchoolResponse'] = this.schoolResponse;
    data['isExpire'] = this.isExpire;
    return data;
  }
}

class Pager {
  String? pageNumber;
  String? recordsPerPage;
  String? totalRecords;

  Pager({this.pageNumber, this.recordsPerPage, this.totalRecords});

  Pager.fromJson(Map<String, dynamic> json) {
    pageNumber = json['PageNumber'];
    recordsPerPage = json['RecordsPerPage'];
    totalRecords = json['TotalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageNumber'] = this.pageNumber;
    data['RecordsPerPage'] = this.recordsPerPage;
    data['TotalRecords'] = this.totalRecords;
    return data;
  }
}
