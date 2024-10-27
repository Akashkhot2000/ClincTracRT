class AddCommonEvaluationRequest {
  AddCommonEvaluationRequest(
      {required this.accessToken,
        required this.userId,
        required this.RotationId,
        required this.MobileNumber,
        required this.EvaluationDate,
        this.EvalType,
        required this.SignatureName});

  String accessToken;
  String userId;
  String RotationId;
  String EvaluationDate;
  String? EvalType;
  String MobileNumber;
  String SignatureName;
  Map<String, dynamic> toJson() => {
    "AccessToken": accessToken,
    "UserId": userId,
    "RotationId": RotationId,
    "EvaluationDate": EvaluationDate,
    "EvalType": EvalType,
    "MobileNumber": MobileNumber,
    "SignatureName": SignatureName,
  };
}
