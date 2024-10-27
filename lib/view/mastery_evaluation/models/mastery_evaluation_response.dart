
class MasteryEvaluationResponse {
  int? status;
  bool? success;
  String? message;
  MasteryEvaluationData? payload;

  MasteryEvaluationResponse(
      {this.status, this.success, this.message, this.payload});

  MasteryEvaluationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    payload =
    json!= null ? new MasteryEvaluationData.fromJson(json) : null;
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

class MasteryEvaluationData {
  List<MasteryEvaluationInnerData>? data;
  Pager? pager;

  MasteryEvaluationData({this.data, this.pager});

  MasteryEvaluationData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <MasteryEvaluationInnerData>[];
      json['data'].forEach((v) {
        data!.add(new MasteryEvaluationInnerData.fromJson(v));
      });
    }
    pager = json['pager'] != null ? new Pager.fromJson(json['pager']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pager != null) {
      data['pager'] = this.pager!.toJson();
    }
    return data;
  }
}

class MasteryEvaluationInnerData {
  String? rotationId;
  String? evaluationId;
  String? evaluationDate;
  String? rotaionName;
  DateTime? dateOfStudentSignature;
  DateTime? dateOfInstructorSignature;
  String? hospitalSiteId;
  String? hospitalSite;
  String? clinicianId;
  String? clinicianName;
  String? course;
  String? cPAP;
  String? delieveryOfNeonate;
  String? hFOV;
  String? tracheostomyCare;
  String? totalAvg;
  String? status;

  MasteryEvaluationInnerData(
      {this.rotationId,
        this.evaluationId,
        this.evaluationDate,
        this.rotaionName,
        this.dateOfStudentSignature,
        this.dateOfInstructorSignature,
        this.hospitalSiteId,
        this.hospitalSite,
        this.clinicianId,
        this.clinicianName,
        this.course,
        this.cPAP,
        this.delieveryOfNeonate,
        this.hFOV,
        this.tracheostomyCare,
        this.totalAvg,
        this.status});

  MasteryEvaluationInnerData.fromJson(Map<String, dynamic> json) {
    rotationId = json['RotationId'];
    evaluationId = json['EvaluationId'];
    evaluationDate = json["EvaluationDate"] != ""
        ? json["EvaluationDate"]
        : null;
    rotaionName = json['RotaionName'];
    dateOfStudentSignature = json["DateOfStudentSignature"] != ""
        ? DateTime.parse(json["DateOfStudentSignature"])
        : null;
    dateOfInstructorSignature = json["DateOfInstructorSignature"] != ""
        ? DateTime.parse(json["DateOfInstructorSignature"])
        : null;
    hospitalSiteId = json['HospitalSiteId'];
    hospitalSite = json['HospitalSite'];
    clinicianId = json['ClinicianId'];
    clinicianName = json['ClinicianName'];
    course = json['Course'];
    cPAP = json['CPAP'];
    delieveryOfNeonate = json['DelieveryOfNeonate'];
    hFOV = json['HFOV'];
    tracheostomyCare = json['TracheostomyCare'];
    totalAvg = json['TotalAvg'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RotationId'] = this.rotationId;
    data['EvaluationId'] = this.evaluationId;
    data['EvaluationDate'] = this.evaluationDate;
    data['RotaionName'] = this.rotaionName;
    data['DateOfStudentSignature'] = this.dateOfStudentSignature;
    data['DateOfInstructorSignature'] = this.dateOfInstructorSignature;
    data['HospitalSiteId'] = this.hospitalSiteId;
    data['HospitalSite'] = this.hospitalSite;
    data['ClinicianId'] = this.clinicianId;
    data['ClinicianName'] = this.clinicianName;
    data['Course'] = this.course;
    data['CPAP'] = this.cPAP;
    data['DelieveryOfNeonate'] = this.delieveryOfNeonate;
    data['HFOV'] = this.hFOV;
    data['TracheostomyCare'] = this.tracheostomyCare;
    data['TotalAvg'] = this.totalAvg;
    data['Status'] = this.status;
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