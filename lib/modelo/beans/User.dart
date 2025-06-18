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
      roles: List<String>.from(json['roles']),
      token: json['token'],
    );
  }
}