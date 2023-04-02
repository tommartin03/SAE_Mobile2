import 'package:flutter/foundation.dart';

class UserModel extends ChangeNotifier {
  final String id;
  final String username;
  final String password;

  UserModel({
    required this.id,
    required this.username,
    required this.password,
  })  : assert(id != null),
        assert(username != null),
        assert(password != null);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'],
      password: json['password'],
    );
  }
}
