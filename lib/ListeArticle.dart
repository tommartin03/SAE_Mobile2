import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Article.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/viewmodel/favorisviewmodel.dart';
import 'package:saemobile/viewmodel/panierviewmodel.dart';
import 'package:saemobile/AuthProvider.dart';


class Vue1 extends StatefulWidget {
  @override
  _Vue1State createState() => _Vue1State();
}

class _Vue1State extends State<Vue1> {
  List<Article> _articles = [];

  @override
  void initState() {
    super.initState();
    try {
      _fetchArticles();
    } catch (error) {
      print('Error fetching articles: $error');
    }
  }

  Future<void> _fetchArticles() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    final jsonData = json.decode(response.body);
    setState(() {
      _articles = (jsonData as List).map((item) => Article.fromJson(item)).toList();
    });
  }

  Future<void> _showLoginPopup(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Veuillez vous connecter'),
          content: Text('Vous devez être connecté pour ajouter des articles aux favoris ou au panier.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool _isArticleFavorite(Article article) {
    final favorites = Provider.of<FavorisViewModel>(context, listen: false).favoris;
    return favorites.contains(article);
  }

  void _addToFavorites(BuildContext context, Article article) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) {
      _showLoginPopup(context);
      return;
    }
    Provider.of<FavorisViewModel>(context, listen: false).ajouter(article);
  }

  void _removeFromFavorites(Article article) {
    Provider.of<FavorisViewModel>(context, listen: false).supprimer(article);
  }

  Icon _getFavoriteIcon(Article article) {
    final favorites = Provider.of<FavorisViewModel>(context, listen: false).favoris;
    final isFavorite = favorites.contains(article);
    return isFavorite ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_border);
  }

  bool _isArticleInPanier(Article article) {
    final panier = Provider.of<PanierViewModel>(context, listen: false).articles;
    return panier.contains(article);
  }

  void _addToPanier(BuildContext context, Article article) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) {
      _showLoginPopup(context);
      return;
    }
    Provider.of<PanierViewModel>(context, listen: false).ajouter(article);
  }

  Widget _getPanierButton(Article article) {
    return Builder(builder: (context) {
      final panier = Provider.of<PanierViewModel>(context);
      final isInPanier = _isArticleInPanier(article);
      return Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return isInPanier
              ? TextButton(
            onPressed: () {
              panier.supprimer(article);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: Colors.blue),
                SizedBox(width: 4),
                Text('Ajouté', style: TextStyle(color: Colors.white)),
              ],
            ),
          )
              : ElevatedButton(
            onPressed: () {
              _addToPanier(context, article);
            },
            child: Text('Ajouter au panier'),
          );
        },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  article.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '\$${article.price}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<FavorisViewModel>(
                    builder: (context, favorisViewModel, child) {
                      return IconButton(
                        icon: _getFavoriteIcon(article),
                        onPressed: () {
                          if (_isArticleFavorite(article)) {
                            _removeFromFavorites(article);
                          } else {
                            _addToFavorites(context, article);
                          }
                        },
                      );
                    },
                  ),
                  _getPanierButton(article),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

