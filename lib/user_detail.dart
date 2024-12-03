import 'package:flutter/material.dart';
import 'user_model.dart'; // Assurez-vous d'importer votre modèle User

class UserDetail extends StatelessWidget {
  final User user;

  UserDetail({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Prénom: ${user.firstName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Nom: ${user.lastName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Password: ${user.password}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Date de début: ${user.starterDate}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Âge: ${user.age}', style: TextStyle(fontSize: 18)), // Conversion ici
            SizedBox(height: 8),
            Text('Actif: ${user.active ? "Oui" : "Non"}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}