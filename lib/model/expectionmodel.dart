class ExpectionModel {
  String? userId;
  String? attendanceId;
  String? rotationId;
  String? hospitalSiteId;
  String? clockInDate;
  String? clockInTime;
  String? clockOutDate;
  String? clockOutTime;
  String? exceptionHours;
  String? reason;
  String? isTimeZone;
  String? longitude;
  String? lattitude;
  String? accessToken;

  ExpectionModel(
      {this.userId,
        this.attendanceId,
        this.rotationId,
        this.hospitalSiteId,
        this.clockInDate,
        this.clockInTime,
        this.clockOutDate,
        this.clockOutTime,
        this.exceptionHours,
        this.reason,
        this.isTimeZone,
        this.longitude,
        this.lattitude,
        this.accessToken});

  ExpectionModel.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    attendanceId = json['AttendanceId'];
    rotationId = json['RotationId'];
    hospitalSiteId = json['HospitalSiteId'];
    clockInDate = json['ClockInDate'];
    clockInTime = json['ClockInTime'];
    clockOutDate = json['ClockOutDate'];
    clockOutTime = json['ClockOutTime'];
    exceptionHours = json['ExceptionHours'];
    reason = json['Reason'];
    isTimeZone = json['IsTimeZone'];
    longitude = json['Longitude'];
    lattitude = json['Lattitude'];
    accessToken = json['AccessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['AttendanceId'] = this.attendanceId;
    data['RotationId'] = this.rotationId;
    data['HospitalSiteId'] = this.hospitalSiteId;
    data['ClockInDate'] = this.clockInDate;
    data['ClockInTime'] = this.clockInTime;
    data['ClockOutDate'] = this.clockOutDate;
    data['ClockOutTime'] = this.clockOutTime;
    data['ExceptionHours'] = this.exceptionHours;
    data['Reason'] = this.reason;
    data['IsTimeZone'] = this.isTimeZone;
    data['Longitude'] = this.longitude;
    data['Lattitude'] = this.lattitude;
    data['AccessToken'] = this.accessToken;
    return data;
  }
}
