import 'package:flutter/material.dart';
import 'home.dart';
import 'ListeArticle.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/viewmodel/favorisviewmodel.dart';
import 'Favoris.dart';
import 'package:saemobile/Panier.dart';
import 'package:saemobile/viewmodel/panierviewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saemobile/AuthProvider.dart';
import 'package:saemobile/ApiService.dart';
import 'package:saemobile/LoginPage.dart';
import 'package:saemobile/viewmodel/usermodel.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Widget> _widgetOptions = [
    Vue1(),
    Favoris(),
    Panier(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavorisViewModel()),
        ChangeNotifierProvider(create: (_) => PanierViewModel()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            apiService: ApiService(apiUrl: 'https://fakestoreapi.com/users'),
          ),
        ),
        ChangeNotifierProvider(create: (_) => UserModel(id:'default',username: 'default', password: 'default')),
      ],
      child: MaterialApp(
        title: 'Mon application',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Tom MARTIN Store', widgetOptions: _widgetOptions),
        navigatorObservers: [RouteObserver<PageRoute>()],
      ),
    );
  }
}
