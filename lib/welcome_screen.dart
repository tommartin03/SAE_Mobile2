import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _dontShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Écran d\'accueil')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bienvenue dans l'application !",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                Text(
                  "Nous sommes ravis de vous présenter notre site de vente en ligne qui respecte toutes les normes de qualité et de sécurité. Profitez d'une expérience d'achat exceptionnelle avec une large gamme de produits à votre disposition.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                CheckboxListTile(
                  title: Text("Ne plus afficher cet écran"),
                  value: _dontShowAgain,
                  onChanged: (bool? value) {
                    setState(() {
                      _dontShowAgain = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_dontShowAgain) {
                      await _saveCheckboxState();
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Continuer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveCheckboxState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('welcomeScreenSeen', _dontShowAgain);
  }
}
