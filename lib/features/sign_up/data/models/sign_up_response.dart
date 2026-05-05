import 'package:json_annotation/json_annotation.dart';
part 'sign_up_response.g.dart';

@JsonSerializable()
class SignupResponse {
  bool? success;
  String? message;
  SignupData? data;

  SignupResponse({this.success, this.message, this.data});

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);
}

@JsonSerializable()
class SignupData {
  SignupUser? user;
  String? token;

  SignupData({this.user, this.token});

  factory SignupData.fromJson(Map<String, dynamic> json) =>
      _$SignupDataFromJson(json);
}

@JsonSerializable()
class SignupUser {
  int? id;
  @JsonKey(name: 'full_name')
  String? fullName;
  String? email;
  String? role;

  SignupUser({this.id, this.fullName, this.email, this.role});

  factory SignupUser.fromJson(Map<String, dynamic> json) =>
      _$SignupUserFromJson(json);
}