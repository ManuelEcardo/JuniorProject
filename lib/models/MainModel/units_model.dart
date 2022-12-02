
class UnitsModel
{
  List<UnitItem>item=[];

  UnitsModel.fromJson(List<dynamic>json)
  {
    for(Map<String,dynamic> element in json)
    {
      item.add(UnitItem.fromJson(element));
    }
  }
}


class UnitItem {
  int? id; //The unit id
  String? unitName;
  String? unitLevel;
  String? unitStatus;
  int? languageId; //it's language id, ex unit 2 from language id 1 => in English Course.

  UnitItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unit_name'];
    unitLevel = json['unit_level'];
    unitStatus = json['unit_status'];
    languageId = json['language_id'];
  }

}
