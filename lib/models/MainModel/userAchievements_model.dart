class UserAchievementsModel
{
  List<UserAchievementItem> item=[];

  UserAchievementsModel.fromJson(List<dynamic>json)
  {
    for(Map<String,dynamic> element in json)
    {
      item.add(UserAchievementItem.fromJson(element));
    }
  }
}



class UserAchievementItem
{
  String? id;
  int? achievementId;
  int? achieverId;
  int? points;
  String? unlockedAt;


  UserAchievementItem.fromJson(Map<String,dynamic> json)
  {
    id= json['id'];
    achievementId= json['achievement_id'];
    achieverId= json['achiever_id'];
    points= json['points'];
    unlockedAt= json['unlocked_at'];
  }
}