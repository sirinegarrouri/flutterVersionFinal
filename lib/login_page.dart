import 'package:flutter/material.dart';
import 'package:user_management_app/home_page.dart'; // Importez la page d'accueil ou la page suivante après connexion
import 'package:user_management_app/user_model.dart';

import 'http_service.dart'; // Assurez-vous d'importer votre service

import 'package:flutter/material.dart';
import 'package:user_management_app/http_service.dart'; // Importez votre HttpService
import 'package:user_management_app/user_model.dart'; // Importez votre modèle User
import 'package:user_management_app/home_page.dart'; // Importez votre HomePage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final HttpService httpService = HttpService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
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
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    try {
                      User user = await httpService.login(_email, _password);
                      // Navigation vers la page d'accueil après une connexion réussie
                      Navigator.pushReplacementNamed(context, '/home', arguments: user);
                    } catch (e) {
                      // Gérer les erreurs de connexion
                      print('Erreur de connexion: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erreur de connexion')),
                      );
                    }
                  }
                },
                child: Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}