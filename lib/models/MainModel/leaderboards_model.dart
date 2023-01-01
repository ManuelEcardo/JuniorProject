class LeaderboardsModel
{
  List<LeaderboardsUser> item=[];

  LeaderboardsModel.fromJson(List<dynamic> json)
  {
    for(Map<String,dynamic> element in json)
      {
        item.add(LeaderboardsUser.fromJson(element));
      }
  }

  // LeaderboardsModel(this.item);
}

class LeaderboardsUser
{
  int? rank;
  LeaderboardsItem? user;

  LeaderboardsUser.fromJson(Map<String,dynamic>json)
  {
    rank= json['rank'];

    if(json['user'] !=null)
      {
        user=LeaderboardsItem.fromJson(json['user']);
      }
  }

  LeaderboardsUser({required this.rank, this.user});
}


class LeaderboardsItem
{
  int? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? userPhoto;
  int? points;

  LeaderboardsItem({required this.id, required this.firstName, required this.lastName,required this.fullName,required this.userPhoto,required this.points});

  LeaderboardsItem.fromJson(Map<String,dynamic>json)
  {
    id= json['id'];
    firstName= json['first_name'];
    lastName= json['last_name'];
    fullName= json['full_name'];
    userPhoto= json['user_photo'];
    points= json['points'];
  }

  // leaderboardsItemFull(LeaderboardsItem model)
  // {
  //   id= model.id;
  //   firstName= model.firstName;
  //   lastName= model.lastName;
  //   fullName= model.fullName;
  //   userPhoto= model.userPhoto;
  //   points= model.points;
  // }
}