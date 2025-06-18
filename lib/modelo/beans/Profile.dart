class Profile {
  final int id;
  final String fullName;

  Profile({required this.id, required this.fullName});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['fullName'],
    );
  }
}