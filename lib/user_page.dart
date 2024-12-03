import 'dart:convert';
import 'package:flutter/material.dart';
import 'http_service.dart';
import 'user_model.dart';
import 'user_detail.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final HttpService httpService = HttpService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Utilisateurs'),
      ),
      body: FutureBuilder<List<User>>(
        future: httpService.getAllUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            List<User> users = snapshot.data!;
            return ListView(
              children: users.map((User user) => ListTile(
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserDetail(user: user),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(context, user);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteUser(user.id);
                      },
                    ),
                  ],
                ),
              )).toList(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showPostDialog(context);
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }

  Future<void> showPostDialog(BuildContext context) async {
    String firstName = '';
    String lastName = '';
    String email = '';
    String password = '';
    int age = 0;
    bool active = true;
    DateTime starterDate = DateTime.now();
    String selectedStatus = 'active';

    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un Utilisateur'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prénom';
                    }
                    return null;
                  },
                  onChanged: (value) => firstName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                  onChanged: (value) => lastName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    return null;
                  },
                  onChanged: (value) => email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    return null;
                  },
                  onChanged: (value) => password = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Âge'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Veuillez entrer un âge valide';
                    }
                    return null;
                  },
                  onChanged: (value) => age = int.parse(value),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: starterDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && pickedDate != starterDate)
                      starterDate = pickedDate;
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Date de début', hintText: "${starterDate.toLocal()}".split(' ')[0]),
                      validator: (value) {
                        if (starterDate == null) {
                          return 'Veuillez choisir une date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Actif'),
                        value: 'active',
                        groupValue: selectedStatus,
                        onChanged: (String? value) {
                          setState(() {
                            selectedStatus = value!;
                            active = true;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Non Actif'),
                        value: 'inactive',
                        groupValue: selectedStatus,
                        onChanged: (String? value) {
                          setState(() {
                            selectedStatus = value!;
                            active = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Ajouter'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String userJson = jsonEncode(<String, dynamic>{
                    'firstName': firstName,
                    'lastName': lastName,
                    'email': email,
                    'password': password,
                    'starterDate': starterDate.millisecondsSinceEpoch,
                    'age': age,
                    'active': active,
                  });

                  await httpService.addUser(userJson); // Appel à la méthode d'ajout
                  setState(() {});
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur ajouté avec succès')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _emailController.text = user.email;
    _passwordController.text = user.password;
    _ageController.text = user.age.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier l\'Utilisateur'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prénom';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Mot de passe'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Âge'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Veuillez entrer un âge valide';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Modifier'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String updatedUserJson = jsonEncode({
                    'id': user.id,
                    'firstName': _firstNameController.text,
                    'lastName': _lastNameController.text,
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'age': int.parse(_ageController.text),
                  });

                  await httpService.updateUser(user.id, updatedUserJson);
                  setState(() {});
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur modifié avec succès')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int userId) async {
    await httpService.deleteUser(userId);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur supprimé')));
  }
}
