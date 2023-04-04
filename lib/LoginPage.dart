import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saemobile/AuthProvider.dart';
import 'package:saemobile/ListeArticle.dart';
import 'package:saemobile/viewmodel/panierviewmodel.dart';
import 'package:saemobile/welcome_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    Provider.of<AuthProvider>(context, listen: false)
        .login(_username, _password, context)
        .then((_) {
      Provider.of<PanierViewModel>(context, listen: false)
          .loadPanier(_username);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      ).then((value) {
        // This block of code will be executed when the user clicks on "Continuer"
        Navigator.pop(context);
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.user != null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Mon application'),
            ),
            body: Vue1(),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 0,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favoris',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: 'Panier',
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Connexion'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration:
                      InputDecoration(labelText: 'Nom d\'utilisateur'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre nom d\'utilisateur';
                        }
                        return null;
                      },
                      onSaved: (value) => _username = value!,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Mot de passe'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre mot de passe';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Se connecter'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
