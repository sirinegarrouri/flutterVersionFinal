import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'Accueil'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/users'); // Utiliser le nom de la route pour naviguer
          },
          child: Text('Aller à la liste des utilisateurs'),
        ),
      ),
    );
  }
}