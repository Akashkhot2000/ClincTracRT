class ActiveRotationStatus {
  bool isRotationActive = false;
  int? rotationId;
  String? rotationName;

  ActiveRotationStatus(
      {required this.isRotationActive, this.rotationId, this.rotationName});

  ActiveRotationStatus.fromJson(Map<String, dynamic> json) {
    isRotationActive = json['isRotationActive'];
    rotationId = json['rotationId'];
    rotationName = json['rotationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isRotationActive'] = this.isRotationActive;
    data['rotationName'] = this.rotationName;
    return data;
  }
}
