class RegisterModel {
  User? user;
  String? token;
  String? message;

  RegisterModel.fromJson(Map<String, dynamic> json) {
    user = User.fromJson(json['user']);
    token = json['token'];
    message= json['message'];
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? gender;
  String? birthDate;
//String? userPhoto;
  String? email;
  String? roleId;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    birthDate = json['birth_date'];
    // userPhoto = json['user_photo'];
    email = json['email'];
    roleId = json['role_id'];
  }

}
