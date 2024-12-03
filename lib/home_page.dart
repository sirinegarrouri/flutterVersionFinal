import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Page d\'Accueil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
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
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/users');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_alt_outlined,
                    color: Colors.deepPurpleAccent,
                    size: 28,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Voir Utilisateurs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
