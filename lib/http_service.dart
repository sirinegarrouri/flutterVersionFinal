import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'user_model.dart'; // Assurez-vous d'importer votre modèle User

class HttpService {
  final String baseUrl = 'http://localhost:8080/Utilisateurs'; // Remplacez par l'URL de votre serveur

  // Récupérer tous les utilisateurs
  Future<List<User>> getAllUsers() async {
    final response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((dynamic user) => User.fromJson(user),).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Ajoutez cette méthode dans la classe HttpService
  Future<User> addUser(String userJson) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: userJson,
    );

    if (response.statusCode == 201) { // Vérifiez que le code de statut est correct
      return User.fromJson(jsonDecode(response.body)); // Convertir le JSON en objet User
    } else {
      // Si le serveur ne renvoie pas un code de statut 201, lancez une exception
      throw Exception('Failed to create user : ${response.body}');
    }
  }
//delete
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$userId'));

    if (response.statusCode !=
        204) { // Vérifiez que le code de statut est correct
      throw Exception('Failed to delete user');
    }
  }
}