class UniRotationJournalData {
  UniRotationJournalData({ this.rotationId,  this.title,  this.hospitalTitle,  this.hospitalSiteId});

  String? rotationId;
  String? title;
  String? hospitalTitle;
  String? hospitalSiteId;

  factory UniRotationJournalData.fromJson(Map<String, dynamic> json) =>
      UniRotationJournalData(rotationId: json["RotationId"], title: json["Title"], hospitalTitle: json["HospitalTitle"], hospitalSiteId: json["HospitalSiteId"]);
}