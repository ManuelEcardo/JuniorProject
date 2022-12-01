class ContentModel {

  List<String>? unitOverview;
  List<Questions>? questions;
  List<Lessons>? lessons;
  List<Videos>? videos;

  ContentModel.fromJson(Map<String, dynamic> json)
  {
    json['unit_overview'].forEach((element)
    {
      unitOverview?.add(element);
    }
    );

    json['questions'].forEach((element)   //It is a list, so we need to add each element, can be achieved by using forEach to get each element then add it using .add
    {
      questions?.add(Questions.fromJson(element));
    }
    );

    json['lessons'].forEach((element)
    {
      questions?.add(Questions.fromJson(element));
    }
    );

    json['videos'].forEach((element)
    {
      questions?.add(Questions.fromJson(element));
    }
    );
  }
}

class Questions
{
  int? id;
  String? type;
  String? question;
  String? answer;
  String? choices;
  int? unitId;
  String? createdAt;
  String? updatedAt;

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    question = json['question'];
    answer = json['answer'];
    choices = json['choices'];
    unitId = json['unit_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}


class Lessons
{
  String? lesson_title;
  String? lesson_content;
  int? unit_id;

  Lessons.fromJson(Map<String, dynamic> json)
  {
    lesson_title=json['lesson_title'];
    lesson_content=json['lesson_content'];
    unit_id=json['unit_id'];
  }

}

class Videos
{

}