import 'package:flutter/material.dart';
import 'package:saemobile/Favoris.dart';
import 'package:saemobile/ListeArticle.dart';
import 'package:saemobile/Panier.dart';
import 'package:saemobile/viewmodel/favorisviewmodel.dart';
import 'package:saemobile/viewmodel/panierviewmodel.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/AuthProvider.dart';
import 'package:saemobile/LoginPage.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title, required this.widgetOptions})
      : super(key: key);

  final String title;
  final List<Widget> widgetOptions;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  int _nombreArticlesPanier = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<FavorisViewModel>(context, listen: false).loadFavorites();
    _updateNombreArticlesPanier(); // appel de la méthode pour mettre à jour le nombre d'articles dans le panier
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<FavorisViewModel>(context).addListener(_onFavoritesChange);
    Provider.of<PanierViewModel>(context).addListener(_onPanierChange);
  }

  @override
  void dispose() {
    Provider.of<FavorisViewModel>(context).removeListener(_onFavoritesChange);
    Provider.of<PanierViewModel>(context).removeListener(_onPanierChange);
    super.dispose();
  }

  void _onFavoritesChange() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {});
      _updateNombreArticlesPanier();
    }
  }


  void _onPanierChange() {
    _updateNombreArticlesPanier();
  }

  void _onItemTapped(int index) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user == null && (index == 1 || index == 2)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  void _updateNombreArticlesPanier() {
    final panierViewModel = Provider.of<PanierViewModel>(context, listen: false);
    final nombreArticles = panierViewModel.articles.length;
    setState(() {
      _nombreArticlesPanier = nombreArticles;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.user?.username ?? 'Invité';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavorisViewModel()),
        ChangeNotifierProvider(create: (_) => PanierViewModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Text(
                    'Bonjour, $username',
                    style: TextStyle(fontSize: 25),
                  ),
                  IconButton(
                    onPressed: () {
                      authProvider.logout();
                    },
                    icon: Icon(Icons.logout),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: widget.widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Articles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoris',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  if (_nombreArticlesPanier > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$_nombreArticlesPanier',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Panier',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

