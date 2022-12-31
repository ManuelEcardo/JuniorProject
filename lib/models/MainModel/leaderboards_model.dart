class LeaderboardsModel
{
  List<LeaderboardsItem> item=[];

  LeaderboardsModel.fromJson(List<dynamic> json)
  {
    for(Map<String,dynamic> element in json)
      {
        item.add(LeaderboardsItem.fromJson(element));
      }
  }
}


class LeaderboardsItem
{
  int? id;
  String? firstName;
  String? lastName;
  String? fullName;
  int? points;


  LeaderboardsItem.fromJson(Map<String,dynamic>json)
  {
    id= json['id'];
    firstName= json['first_name'];
    lastName= json['last_name'];
    fullName= json['full_name'];
    points= json['points'];
  }
}