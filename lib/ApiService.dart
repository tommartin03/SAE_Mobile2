import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saemobile/viewmodel/usermodel.dart';

class ApiService {
  final String apiUrl;

  ApiService({required this.apiUrl});

  Future<UserModel> getUser(String username, String password) async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        final userJson = jsonResponse.firstWhere(
              (user) => user['username'] == username && user['password'] == password,
          orElse: () => null,
        );

        if (userJson != null) {
          return UserModel.fromJson(userJson as Map<String, dynamic>);
        } else {
          throw Exception('User not found');
        }
      } else {
        throw Exception('Failed to decode response body');
      }
    } else {
      throw Exception('Failed to load users');
    }
  }
}