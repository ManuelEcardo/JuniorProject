class FavouritesModel
{
  List<FavouritesItem> item=[];

  FavouritesModel.fromJson(List<dynamic> json)
  {
    if(json.isNotEmpty)
      {
        for(Map<String,dynamic> element in json)
        {
          item.add(FavouritesItem.fromJson(element));
        }
      }
  }
}

class FavouritesItem
{
  int? id;
  int? userId;
  String? vocabulary;

  FavouritesItem.fromJson(Map<String,dynamic>json)
  {
    id= json['id'];
    userId= json['user_id'];
    vocabulary= json['vocabulary'];
  }
}