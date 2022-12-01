class UnitsModel {
  int? id;
  String? unitName;
  String? unitLevel;
  String? unitStatus;
  int? languageId;

  UnitsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unit_name'];
    unitLevel = json['unit_level'];
    unitStatus = json['unit_status'];
    languageId = json['language_id'];
  }

}
