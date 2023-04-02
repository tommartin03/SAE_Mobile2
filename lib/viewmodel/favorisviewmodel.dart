import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:saemobile/Article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavorisViewModel extends ChangeNotifier {
  static const _keyFavoris = 'favoris';

  Set<Article> _favoris = {};

  Set<Article> get favoris => _favoris;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorisJson = prefs.getString(_keyFavoris);
    if (favorisJson != null) {
      final favorisList = json.decode(favorisJson) as List;
      _favoris = favorisList.map((fav) => Article.fromJson(fav)).toSet();
      notifyListeners();
    }
  }

  Future<void> ajouter(Article article) async {
    if (!_favoris.contains(article)) {
      _favoris.add(article);
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final favorisJson = json.encode(_favoris.toList());
      prefs.setString(_keyFavoris, favorisJson); // ajout de la sauvegarde dans les préférences partagées
      _updateNombreArticlesPanier(); // mise à jour du nombre d'articles dans le panier
    }
  }

  Future<void> supprimer(Article article) async {
    _favoris.remove(article);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final favorisJson = json.encode(_favoris.toList());
    prefs.setString(_keyFavoris, favorisJson); // ajout de la sauvegarde dans les préférences partagées
    _updateNombreArticlesPanier(); // mise à jour du nombre d'articles dans le panier
  }

  int _nombreArticlesPanier = 0;

  int get nombreArticlesPanier => _nombreArticlesPanier;

  void _updateNombreArticlesPanier() {
    _nombreArticlesPanier = _favoris.length;
    notifyListeners();
  }
}