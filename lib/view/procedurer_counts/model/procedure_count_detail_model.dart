// To parse this JSON data, do
//
//     final rotationListModel = rotationListModelFromJson(jsonString);

import 'dart:convert';
import '../../../model/common_pager_model.dart';


ProcedureCountDetailsModel procedureCountDetailsModelFromJson(String str) =>
    ProcedureCountDetailsModel.fromJson(json.decode(str));

// String procedureCountDetailsModelToJson(ProcedureCountDetail data) => json.encode(data.toJson());

class ProcedureCountDetailsModel {
  ProcedureCountDetailsModel({
    required this.data,
    required this.pager,
  });

  List<ProcedureCountDetail> data;
  Pager pager;
  factory ProcedureCountDetailsModel.fromJson(Map<String, dynamic> json) => ProcedureCountDetailsModel(
    data: List<ProcedureCountDetail>.from(json["data"].map((x) => ProcedureCountDetail.fromJson(x as Map<String, dynamic>))),
    pager: Pager.fromJson(json["pager"]),
  );
}

class ProcedureCountDetail {
  ProcedureCountDetail({
    required this.procedureCountTopicId,
    required this.procedureCountName,
    required this.procedureCountsCode,
    required this.totalTopicCount,
    required this.procedureCount,
    this.isExpanded = false,
  });

  String procedureCountTopicId;
  String procedureCountName;
  String procedureCountsCode;
  int totalTopicCount;
  List<ProcedureCount> procedureCount;
  bool? isExpanded;

  factory ProcedureCountDetail.fromJson(Map<String, dynamic> json) => ProcedureCountDetail(
        procedureCountTopicId: json["ProcedureCountTopicId"],
        procedureCountName: json["ProcedureCountName"],
        procedureCountsCode: json["ProcedureCountsCode"],
        totalTopicCount: json["TotalTopicCount"],
        procedureCount: List<ProcedureCount>.from(json["ProcedureCount"].map((x) => ProcedureCount.fromJson(x))),
    isExpanded: json["IsExpanded"],
        // procedureCount: json["procedureCount"] != null ? List<ProcedureCount>.from(json["procedureCount"].map((x) => ProcedureCount.fromJson(x))):[],
  );

  // Map<String, dynamic> toJson() => {
  //       "ProcedureCountTopicId": procedureCountTopicId,
  //       "ProcedureCountName": procedureCountName,
  //       "ProcedureCountsCode": procedureCountsCode,
  //       "TotalTopicCount": totalTopicCount,
  //       "ProcedureCount":
  //           List<dynamic>.from(procedureCount.map((x) => x.toJson())),
  //     };
}

class ProcedureCount {
  ProcedureCount({
    required this.procedureCountId,
    required this.procedurePointsAssist,
    required this.procedurePointsObserve,
    required this.procedurePointsPerform,
    required this.procedurePointsPerformTotal,
    required this.total,
    required this.evalutionDate,
    required this.procedureDate,
  });

  String procedureCountId;
  String procedurePointsAssist;
  String procedurePointsObserve;
  String procedurePointsPerform;
  String procedurePointsPerformTotal;
  String total;
  DateTime? evalutionDate;
  DateTime? procedureDate;

  factory ProcedureCount.fromJson(Map<String, dynamic> json) {
  //   DateTime convertDateToUTC(String dateUtc) {
  //     var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateUtc, true);
  //     var formattedTime = dateTime.toLocal();
  //     return formattedTime;
  //   }

    return ProcedureCount(
      procedureCountId: json["ProcedureCountId"],
      procedurePointsAssist: json["ProcedurePointsAssist"],
      procedurePointsObserve: json["ProcedurePointsObserve"],
      procedurePointsPerform: json["ProcedurePointsPerform"],
      procedurePointsPerformTotal: json["ProcedurePointsPerformTotal"],
      total: json["Total"],
      evalutionDate: json["EvalutionDate"] != "" ? DateTime.parse(json["EvalutionDate"]): null,
      procedureDate: json["ProcedureDate"] != ""
          ? DateTime.parse(json["ProcedureDate"]): null,
    );
  }
  // Map<String, dynamic> toJson() => {
  //       "ProcedurePointsAssist": procedurePointsAssist,
  //       "ProcedurePointsObserve": procedurePointsObserve,
  //       "ProcedurePointsPerform": procedurePointsPerform,
  //       "ProcedurePointsPerformTotal": procedurePointsPerformTotal,
  //       "Total": total,
  //       "EvalutionDate": evalutionDate.toIso8601String(),
  //       "ProcedureDate": procedureDate.toIso8601String(),
  //     };
}
