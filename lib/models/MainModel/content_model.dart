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
  List<Choices>? choices=[];
  int? unitId;
  String? link;

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    question = json['question'];
    answer = json['answer'];
    unitId = json['unit_id'];
    link=json['question_link'];
    json['choices'].forEach((element)
    {
      choices?.add(Choices.fromJson(element));
    });
  }
}

class Choices
{
  int? id;
  String? choice;
  String? isCorrect;
  int? questionId;


  Choices.fromJson(Map<String,dynamic> json)
  {
    id=json['id'];
    choice=json['choice'];
    isCorrect=json['is_correct'];
    questionId= json['question_id'];

  }
}


class Lessons
{
  late String lessonTitle;
  late String lessonContent;
  late int unitId;
  late int id;

  Lessons.fromJson(Map<String, dynamic> json)
  {
    lessonTitle=json['lesson_title'];
    lessonContent=json['lesson_content'];
    unitId=json['unit_id'];
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

  Videos({this.videoTitle,this.videoLink,this.videoSubtitle,this.videoDescription});


  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoTitle = json['video_title'];
    videoLink = json['video_link'];
    videoDescription = json['video_description'];
    videoSubtitle = json['video_subtitle'];
    unitId = json['unit_id'];
  }

}
