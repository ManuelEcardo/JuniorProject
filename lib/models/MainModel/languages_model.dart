class LanguagesModel {
  int? id;
  String? languageName;

  LanguagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageName = json['language_name'];
  }
}
