import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/viewmodel/favorisviewmodel.dart';
import 'Article.dart';

class Favoris extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favorisViewModel = Provider.of<FavorisViewModel>(context, listen: false);
    favorisViewModel.loadFavorites();

    return Consumer<FavorisViewModel>(
      builder: (context, favorisViewModel, child) {
        final favoris = favorisViewModel.favoris;
        return Scaffold(
          appBar: AppBar(
            title: Text('Mes favoris'),
          ),
          body: favoris.isEmpty
              ? Center(
            child: Text('Aucun article en favori'),
          )
              : ListView.builder(
            itemCount: favoris.length,
            itemBuilder: (context, index) {
              final article = favorisViewModel.favoris.toList()[index];
              return ListTile(
                leading: Image.network(article.image),
                title: Text(article.title),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => favorisViewModel.supprimer(article),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
