class User {
  final int id;
  final String username;
  final List<String> roles;
  final String? token;

  User({required this.id, required this.username, required this.roles, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      // Manejar el caso donde 'roles' es nulo en la respuesta
      roles: json['roles'] != null
          ? List<String>.from(json['roles'])
          : ['TUTOR'], // Valor predeterminado
      token: json['token'],
    );
  }
}