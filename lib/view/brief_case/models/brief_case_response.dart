


import 'package:intl/intl.dart';

class BriefCaseResponse {
  int? status;
  bool? success;
  String? message;
  BriefCaseData? payload;

  BriefCaseResponse({this.status, this.success, this.message, this.payload});

  BriefCaseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    success = json['success'];
    message = json['message'];
    payload =  BriefCaseData.fromJson(json);
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

class BriefCaseData {
  List<BriefCaseInnerData>? data;
  Pager? pager;

  BriefCaseData({this.data, this.pager});

  BriefCaseData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BriefCaseInnerData>[];
      json['data'].forEach((v) {
        data!.add(new BriefCaseInnerData.fromJson(v));
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

class BriefCaseInnerData {
  String? breifcaseId;
  String? fileTitle;
  String? fileName;
  String? filePath;
  DateTime? uploadedDate;
  String? updatedBy;
  int? fileSize;

  BriefCaseInnerData(
      {this.breifcaseId,
        this.fileTitle,
        this.fileName,
        this.filePath,
        this.uploadedDate,
        this.fileSize,
        this.updatedBy});

  BriefCaseInnerData.fromJson(Map<String, dynamic> json) {
    DateTime convertDateToUTC(String dateUtc) {
      var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
      var formattedTime = dateTime.toLocal();
      return formattedTime;
    }

    breifcaseId = json['BreifcaseId'];
    fileTitle = json['FileTitle'];
    fileSize =json['FileSize'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
    uploadedDate = json["UploadedDate"] != ""
        ? convertDateToUTC(json["UploadedDate"])
        : null;
    updatedBy = json['UpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BreifcaseId'] = this.breifcaseId;
    data['FileTitle'] = this.fileTitle;
    data['FileName'] = this.fileName;
    data['FilePath'] = this.filePath;
    data['UploadedDate'] = this.uploadedDate!.toIso8601String();
    data['UpdatedBy'] = this.updatedBy;
    data['FileSize']=this.fileSize;
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









