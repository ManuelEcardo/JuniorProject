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

  // LeaderboardsModel(this.item);
}


class LeaderboardsItem
{
  int? id;
  int? rank;
  String? firstName;
  String? lastName;
  String? fullName;
  String? userPhoto;
  int? points;

  LeaderboardsItem({required this.id, required this.firstName, required this.lastName,required this.fullName,required this.userPhoto,required this.points, required   this.rank});

  LeaderboardsItem.fromJson(Map<String,dynamic>json)
  {
    id= json['id'];
    rank =json['rank'];
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