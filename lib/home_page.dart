import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'Accueil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Icône pour le bouton de déconnexion
            onPressed: () {
              // Rediriger vers la page de connexion
              Navigator.of(context).pushReplacementNamed('/'); // Utilisez le nom de la route pour naviguer
            },
          ),
        ],
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