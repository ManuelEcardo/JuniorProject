class DailyTipModel
{
  int? id;
  String? content;
  String? category;

  DailyTipModel.fromJson(Map<String,dynamic>json)
  {
    id=json['id'];
    content=json['content'];
    category=json['category'];
  }
}