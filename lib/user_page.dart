import 'dart:convert';
import 'package:flutter/material.dart';
import 'user_detail.dart';
import 'http_service.dart';
import 'user_model.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final HttpService httpService = HttpService();
  final _formKey = GlobalKey<FormState>();

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
                    if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
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
                      decoration:
                      InputDecoration(labelText: 'Date de début', hintText: "${starterDate.toLocal()}".split(' ')[0]),
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
                  String userJson = jsonEncode(<String,dynamic>{
                    'firstName': firstName,
                    'lastName': lastName,
                    'email': email,
                    'password': password,
                    'starterDate': starterDate.millisecondsSinceEpoch,
                    'age': age,
                    'active': active,
                  });

                  httpService.addUser(userJson);
                  setState(() {});
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                  Text('user added successfully')));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, User user) {
    final _formKey = GlobalKey<FormState>();
    String firstName = user.firstName;
    String lastName = user.lastName;
    String email = user.email;
    String password = user.password;

    int age = user.age;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier l\'Utilisateur'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: firstName,
                  decoration: InputDecoration(labelText: 'Prénom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prénom';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    firstName = value;
                  },
                ),
                TextFormField(
                  initialValue: lastName,
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    lastName = value;
                  },
                ),
                TextFormField(
                  initialValue: email,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                TextFormField(
                  initialValue: password,
                  decoration: InputDecoration(labelText: 'password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                ),
                TextFormField(
                  initialValue: age.toString(),
                  decoration: InputDecoration(labelText: 'Âge'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Veuillez entrer un âge valide';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    age = int.tryParse(value) ?? user.age;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Sauvegarder'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  User updatedUser = User(
                    id: user.id,
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password,
                    starterDate: user.starterDate,
                    age: age,
                    active: user.active,
                  );
                  try {
                    await httpService.updateUser(user.id, updatedUser);
                    setState(() {});
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Utilisateur mis à jour avec succès')),
                    );
                  } catch (e) {
                    print('Erreur lors de la mise à jour de l\'utilisateur : $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors de la mise à jour de l\'utilisateur')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int userId) async {
    bool? confirm = await showDialog<bool>(
        context :context,
        builder :(BuildContext context){
          return AlertDialog(
            title :Text('Confirmer la suppression'),
            content :Text('Êtes-vous sûr de vouloir supprimer cet utilisateur ?'),
            actions :<Widget>[
              TextButton(
                child :Text('Annuler'),
                onPressed :() => Navigator.of(context).pop(false),
              ),
              ElevatedButton(
                child :Text('Supprimer'),
                onPressed :() => Navigator.of(context).pop(true),
              )
            ],
          );
        }
    );
    if(confirm == true){
      httpService.deleteUser(userId);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
      Text('user deleted')));
    }

  }
}