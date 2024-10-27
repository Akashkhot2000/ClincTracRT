// To parse this JSON data, do
//
//     final formativeEvaluationdetails = formativeEvaluationdetailsFromJson(jsonString);

import 'dart:convert';

FormativeEvaluationdetails formativeEvaluationdetailsFromJson(String str) => FormativeEvaluationdetails.fromJson(json.decode(str));

String formativeEvaluationdetailsToJson(FormativeEvaluationdetails data) => json.encode(data.toJson());

class FormativeEvaluationdetails {
  Data? data;

  FormativeEvaluationdetails({
    this.data,
  });

  factory FormativeEvaluationdetails.fromJson(Map<String, dynamic> json) => FormativeEvaluationdetails(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  String evaluationId;
  String rotationId;
  String rotationName;
  String clinicianId;
  String clinicianName;
  String studentName;
  DateTime evaluationDate;
  String dateOfStudentSignature;
  String dateOfInstructorSignature;
  String studentComment;
  String status;
  PreceptorDetails preceptorDetails;
  List<Instruction> instructions;
  List<FormativeSection> formativeSections;

  Data({
    required this.evaluationId,
    required this.rotationId,
    required this.rotationName,
    required this.clinicianId,
    required this.clinicianName,
    required this.studentName,
    required this.evaluationDate,
    required this.dateOfStudentSignature,
    required this.dateOfInstructorSignature,
    required this.studentComment,
    required this.status,
    required this.preceptorDetails,
    required this.instructions,
    required this.formativeSections,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        evaluationId: json["EvaluationId"],
        rotationId: json["RotationId"],
        rotationName: json["RotationName"],
        clinicianId: json["ClinicianId"],
        clinicianName: json["ClinicianName"],
        studentName: json["StudentName"],
        evaluationDate: DateTime.parse(json["EvaluationDate"]),
        dateOfStudentSignature: json["DateOfStudentSignature"],
        dateOfInstructorSignature: json["DateOfInstructorSignature"],
        studentComment: json["StudentComment"],
        status: json["Status"],
        preceptorDetails: PreceptorDetails.fromJson(json["PreceptorDetails"]),
        instructions: List<Instruction>.from(json["Instructions"].map((x) => Instruction.fromJson(x))),
        formativeSections: List<FormativeSection>.from(json["FormativeSections"].map((x) => FormativeSection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "EvaluationId": evaluationId,
        "RotationId": rotationId,
        "RotationName": rotationName,
        "ClinicianId": clinicianId,
        "ClinicianName": clinicianName,
        "StudentName": studentName,
        "EvaluationDate": evaluationDate.toIso8601String(),
        "DateOfStudentSignature": dateOfStudentSignature,
        "DateOfInstructorSignature": dateOfInstructorSignature,
        "StudentComment": studentComment,
        "Status": status,
        "PreceptorDetails": preceptorDetails.toJson(),
        "Instructions": List<dynamic>.from(instructions.map((x) => x.toJson())),
        "FormativeSections": List<dynamic>.from(formativeSections.map((x) => x.toJson())),
      };
}

class FormativeSection {
  String sectionTitle;
  List<dynamic> questions;

  FormativeSection({
    required this.sectionTitle,
    required this.questions,
  });

  factory FormativeSection.fromJson(Map<String, dynamic> json) => FormativeSection(
        sectionTitle: json["SectionTitle"],
        questions: List<dynamic>.from(json["Questions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "SectionTitle": sectionTitle,
        "Questions": List<dynamic>.from(questions.map((x) => x)),
      };
}

class Instruction {
  String description;

  Instruction({
    required this.description,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "Description": description,
      };
}

class PreceptorDetails {
  String preceptorId;
  String preceptorName;
  String preceptorMobile;
  bool isPreceptorStatus;

  PreceptorDetails(
      {
        required this.preceptorId,
        required this.preceptorName,
        required this.preceptorMobile,
        required this.isPreceptorStatus});

  factory PreceptorDetails.fromJson(Map<String, dynamic> json) => PreceptorDetails(
    preceptorId: json['PreceptorId']??"",
    preceptorName: json['PreceptorName']??"",
    preceptorMobile: json['PreceptorMobile']??"",
    isPreceptorStatus: json['IsPreceptorStatus']??false,
  );

  Map<String, dynamic> toJson() => {
    "PreceptorId": preceptorId,
    "PreceptorName": preceptorName,
    "PreceptorMobile": preceptorMobile,
    "IsPreceptorStatus": isPreceptorStatus,
  };
}
