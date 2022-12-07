class UserModel {
  Data? data;
  String? message;
  UserModel.fromJson(Map<String, dynamic> json)
  {
    data = Data.fromJson(json['data']);
    message = json['message'];
  }
}

class Data {
  List<UserData>? user=[];
  Data.fromJson(Map<String, dynamic> json)
  {
      json['user'].forEach((v)
      {
        user!.add(UserData.fromJson(v));
      });
  }
}

class UserData {
  int? id;
  String? firstName;
  String? lastName;
  String? gender;
  String? birthDate;
  String? userPhoto;
  String? email;
  int? roleId;


  UserData.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    userPhoto = json['user_photo'];
    email = json['email'];
    roleId = json['role_id'];
  }

}
