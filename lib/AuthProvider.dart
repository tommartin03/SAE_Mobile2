import 'package:flutter/material.dart';
import 'ApiService.dart';
import 'viewmodel/usermodel.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/viewmodel/panierviewmodel.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  ApiService _apiService;

  AuthProvider({required ApiService apiService}) : _apiService = apiService;

  UserModel? get user => _user;

  Future<void> login(String username, String password, BuildContext context) async {
    try {
      _user = await _apiService.getUser(username, password);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    Provider.of<PanierViewModel>(context, listen: false)
        .loadPanier(username);
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}
