import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:saemobile/Article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PanierViewModel extends ChangeNotifier {
  static const _keyPanier = 'panier';

  List<Article> _articles = [];
  String? _username;

  List<Article> get articles => _articles;

  Future<void> loadPanier(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    final panierJson = prefs.getString(_keyPanier + _username!);
    if (panierJson != null) {
      final panierList = json.decode(panierJson) as List;
      _articles = panierList.map((pan) => Article.fromJson(pan)).toList();
      print('Panier chargé: $panierJson');
      notifyListeners();
    }
  }


  void ajouter(Article article) {
    if (!_articles.contains(article)) {
      _articles.add(article);
      notifyListeners();
      savePanier();
    }
  }

  void supprimer(Article article) {
    _articles.remove(article);
    notifyListeners();
    savePanier();
  }

  void vider() {
    _articles.clear();
    notifyListeners();
    savePanier();
  }

  void augmenterQuantite(Article article) {
    final index = _articles.indexOf(article);
    _articles[index].quantite++;
    notifyListeners();
    savePanier();
  }

  void diminuerQuantite(Article article) {
    final index = _articles.indexOf(article);
    if (_articles[index].quantite > 1) {
      _articles[index].quantite--;
      notifyListeners();
      savePanier();
    }
  }

  double get prixTotal {
    return _articles.fold(0, (total, article) => total + article.price * article.quantite);
  }

  Article operator [](int index) {
    return _articles[index];
  }


  Future<void> savePanier() async {
    final prefs = await SharedPreferences.getInstance();
    final panierJson = json.encode(_articles);
    prefs.setString(_keyPanier + _username!, panierJson);
    print('Panier sauvegardé: $panierJson');
  }
}
