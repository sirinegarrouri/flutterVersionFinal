class User {
  final int id; // Assurez-vous que le type correspond à la réponse JSON
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final DateTime starterDate; // Utilisez DateTime pour les dates
  final int age;
  final bool active;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.starterDate,
    required this.age,
    required this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      starterDate: DateTime.fromMillisecondsSinceEpoch(json['starterDate']), // Conversion d'un timestamp
      age: json['age'] as int,
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'starterDate': starterDate.millisecondsSinceEpoch,
      'age': age,
      'active': active,
    };
  }
}