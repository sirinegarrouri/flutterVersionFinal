import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://reqres.in/api/users';
  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  }
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

}
