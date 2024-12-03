import 'package:flutter/material.dart';
import 'user_model.dart'; // Assurez-vous d'importer votre modèle User

class UserDetail extends StatelessWidget {
  final User user;

  UserDetail({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 6,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.indigoAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                detailItem('Prénom', user.firstName),
                detailItem('Nom', user.lastName),
                detailItem('Email', user.email),
                detailItem('Date de début', user.starterDate as String),
                detailItem('Âge', user.age.toString()),
                detailItem('Actif', user.active ? 'Oui' : 'Non'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
