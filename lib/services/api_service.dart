/*import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://reqres.in/api/users';

  // Fetch users from API
  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }

  // Delete a user
  Future<bool> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 404) {
      throw Exception('User not found.');
    } else {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }

  // Update a user
  Future<bool> updateUser(int id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 404) {
      throw Exception('User not found.');
    } else {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }
}*/

