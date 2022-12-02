class ContentModel {

  List<String>? unitOverview=[];
  List<Questions>? questions=[];
  List<Lessons>? lessons=[];
  List<Videos>? videos=[];

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
      lessons?.add(Lessons.fromJson(element));
    }
    );

    json['videos'].forEach((element)
    {
      videos?.add(Videos.fromJson(element));
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
  late String lesson_title;
  late String lesson_content;
  late int unit_id;
  late int id;

  Lessons.fromJson(Map<String, dynamic> json)
  {
    lesson_title=json['lesson_title'];
    lesson_content=json['lesson_content'];
    unit_id=json['unit_id'];
    id=json['id'];
  }

}

class Videos {
  int? id;
  String? videoTitle;
  String? videoLink;
  String? videoDescription;
  String? videoSubtitle;
  int? unitId;


  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoTitle = json['video_title'];
    videoLink = json['video_link'];
    videoDescription = json['video_description'];
    videoSubtitle = json['video_subtitle'];
    unitId = json['unit_id'];
  }

}
