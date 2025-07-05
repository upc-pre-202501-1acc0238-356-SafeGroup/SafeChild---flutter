class Tutor {
  final int? id;
  final String fullName;
  final String email;
  final String doc;
  final String password;
  final String number;
  final String street;
  final String district;
  final String role;
  final int? profileId;

  Tutor({
    this.id,
    required this.fullName,
    required this.email,
    required this.doc,
    required this.password,
    required this.number,
    required this.street,
    required this.district,
    required this.role,
    this.profileId,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      doc: json['doc'],
      password: json['password'],
      number: json['number'],
      street: json['street'],
      district: json['district'],
      role: json['role'],
      profileId: json['profileId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'doc': doc,
      'password': password,
      'number': number,
      'street': street,
      'district': district,
      'role': role,
      'profileId': profileId,
    };
  }
}