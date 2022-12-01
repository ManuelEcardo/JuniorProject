class LanguageModel
{
  List<Languages> item=[];

  LanguageModel.fromJson(List<dynamic>json)
  {
    for(Map<String,dynamic> element in json)
      {
        item.add(Languages.fromJson(element));
      }
  }
}


class Languages {
  int? id;
  String? languageName;
  String? createdAt;
  String? updatedAt;

  Languages(this.id,this.languageName,this.createdAt,this.updatedAt);

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageName = json['language_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

}
