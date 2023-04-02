import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/viewmodel/panierviewmodel.dart';
import 'package:saemobile/viewmodel/usermodel.dart';
import 'Article.dart';

class Panier extends StatefulWidget {
  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  bool _isPanierLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPanierLoaded) {
      _loadPanier();
    }
  }

  Future<void> _loadPanier() async {
    final panierViewModel = Provider.of<PanierViewModel>(context, listen: false);
    final user = Provider.of<UserModel>(context, listen: false);
    await panierViewModel.loadPanier(user.username);
    _isPanierLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    final panierViewModel = Provider.of<PanierViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon panier'),
      ),
      body: panierViewModel.articles.isEmpty
          ? Center(
        child: Text('Votre panier est vide'),
      )
          : ListView.builder(
        itemCount: panierViewModel.articles.length,
        itemBuilder: (context, index) {
          final article = panierViewModel.articles[index];
          return ListTile(
            leading: Image.network(
              article.image,
              width: 100, // Augmenter la largeur de l'image
              height: 150, // Augmenter la hauteur de l'image
              fit: BoxFit.cover,
            ),
            title: Text(article.title),
            subtitle: Row(
              children: [
                Text('\$${article.price}'),
                SizedBox(width: 16),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        panierViewModel.diminuerQuantite(article);
                      },
                    ),
                    Text(article.quantite.toString()),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        panierViewModel.augmenterQuantite(article);
                      },
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.remove_shopping_cart),
              onPressed: () {
                panierViewModel.supprimer(article);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total : \$${panierViewModel.prixTotal}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Commande passée'),
                      content: Text('Merci pour votre commande !'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                            panierViewModel.vider();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Passer la commande'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
