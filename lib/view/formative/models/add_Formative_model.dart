class AddFormativeRequest {
  AddFormativeRequest(
      {required this.accessToken,
      required this.userId,
      required this.RotationId,
      required this.MobileNumber,
      required this.EvaluationDate,
      required this.SignatureName});

  String accessToken;
  String userId;
  String RotationId;
  String EvaluationDate;
  String MobileNumber;
  String SignatureName;
  Map<String, dynamic> toJson() => {
        "AccessToken": accessToken,
        "UserId": userId,
        "RotationId": RotationId,
        "EvaluationDate": EvaluationDate,
        "MobileNumber": MobileNumber,
        "SignatureName": SignatureName,
      };
}
