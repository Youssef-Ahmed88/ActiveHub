import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  bool? success;
  String? message;
  LoginData? data;

  LoginResponse({this.success, this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class LoginData {
  UserData? user;
  String? token;

  LoginData({this.user, this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}

@JsonSerializable()
class UserData {
  int? id;
  @JsonKey(name: 'full_name')
  String? fullName;
  String? email;
  String? phone;
  @JsonKey(name: 'profile_image')
  String? profileImage;
  String? role;

  UserData({this.id, this.fullName, this.email, this.phone, this.profileImage, this.role});

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}