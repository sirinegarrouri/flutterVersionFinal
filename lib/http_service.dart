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
  Future<User> addUser(String u) async {
    final response = await post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: u,
    );
    if (response.statusCode == 201) {
      print('Status code : ${response.statusCode}');
      print('Body : ${response.body}');
      return User.fromJson(jsonDecode(response.body));
    } else {
      print('Erreur : ${response.statusCode} - ${response
          .body}'); // Ajoutez cette ligne
      throw Exception('Failed to add user');
    }
  }

  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/$userId'));

    if (response.statusCode !=
        204) { // Vérifiez que le code de statut est correct
      throw Exception('Failed to delete user');
    }
  }

  // Obtenir un utilisateur par ID
  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user
          .toJson()), // Assurez-vous d'avoir une méthode toJson() dans votre modèle User
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Connexion d'un utilisateur
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/Utilisateurs/login'), // Assurez-vous que cette URL est correcte
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
