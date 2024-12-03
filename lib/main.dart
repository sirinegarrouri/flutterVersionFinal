import 'package:flutter/material.dart';

import 'package:user_management_app/user_page.dart';

import 'home_page.dart';
import 'login_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users App',
      initialRoute: '/', // Définir la route initiale
      routes: {
        '/': (context) => LoginPage(), // Route vers la page de connexion
        '/home': (context) => HomePage(), // Route vers la page d'accueil
        '/users': (context) => UsersPage(), // Route vers la page des utilisateurs
      },
    );
  }
}
