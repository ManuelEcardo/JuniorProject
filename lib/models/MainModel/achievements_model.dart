class AchievementsModel
{
  List<AchievementItem> item=[];

  AchievementsModel.fromJson(List<dynamic>json)
  {
    for(Map<String,dynamic> element in json)
    {
      item.add(AchievementItem.fromJson(element));
    }
  }
}

class AchievementItem
{
  int? id;
  String? name;
  String? description;
  int? points;
  int? secret;


  AchievementItem.fromJson(Map<String,dynamic> json)
  {
    id= json['id'];
    name= json['name'];
    description= json['description'];
    points= json['points'];
    secret= json['secret'];
  }
}