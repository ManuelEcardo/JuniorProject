class MerriamModel {

  Meta? meta;
  Hwi? hwi;
  String? fl;  //Type; verb or noun or adjective
  String? date; //Date of first use.
  List<String>? shortdef;


  MerriamModel.fromJson(Map<String, dynamic> json) {
    meta = Meta.fromJson(json['meta']);
    hwi = Hwi.fromJson(json['hwi']);
    fl = json['fl'];
    date= json['date'];
    shortdef = json['shortdef'].cast<String>();
  }
}

class Meta {
  String? id;
  Meta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}


class Hwi {
  String? hw; //Spaces between words; example: earthquake => returns earth*quake
  List<Prs?>? prs=[];  //Contains how to spell and audio file.

  Hwi.fromJson(Map<String, dynamic> json) {
    hw = json['hw'];
      json['prs'].forEach((v) {
        prs!.add( Prs.fromJson(v));
      });
  }

}

class Prs {
  String? mw;   //Spelling
  Sound? sound;

  Prs.fromJson(Map<String, dynamic> json) {
    mw = json['mw'];
    sound = Sound.fromJson(json['sound']);
  }

}

class Sound {
  String? audio;
  String? ref;
  String? stat;

  Sound.fromJson(Map<String, dynamic>? json) {
    audio = json?['audio'];
    ref = json?['ref'];
    stat= json?['stat'];
  }

}
