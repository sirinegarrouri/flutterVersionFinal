import 'package:flutter/material.dart';
import 'services/api_service.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: UserListPage(),
    );
  }
}

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> users;

  @override
  void initState() {
    super.initState();
    users = apiService.fetchUsers();
  }

  Future<void> _refreshUsers() async {
    setState(() {
      users = apiService.fetchUsers();
    });
  }

  Future<void> _showDeleteConfirmation(int userId, String userName) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User', style: TextStyle(color: Colors.redAccent)),
        content: Text('Are you sure you want to delete $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await _deleteUser(userId, userName);
    }
  }

  Future<void> _deleteUser(int id, String name) async {
    try {
      await apiService.deleteUser(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$name deleted successfully')),
      );
      _refreshUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _refreshUsers,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.', style: TextStyle(fontSize: 18)));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var user = snapshot.data![index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 6,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['avatar']),
                      radius: 30,
                    ),
                    title: Text(
                      '${user['first_name']} ${user['last_name']}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      user['email'],
                      style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _showDeleteConfirmation(user['id'], '${user['first_name']} ${user['last_name']}'),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
