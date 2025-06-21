
class Caregiver {
  final int? id;
  final String email;
  final String completeName;
  final int age;
  final String address;
  final int caregiverExperience;
  final int completedServices;
  final String? biography;
  final String? profileImage;
  final int? farePerHour;
  final String? districtsScope;
  final int? profileId;

  Caregiver({
    this.id,
    required this.email,
    required this.completeName,
    required this.age,
    required this.address,
    required this.caregiverExperience,
    required this.completedServices,
    this.biography,
    this.profileImage,
    this.farePerHour,
    this.districtsScope,
    this.profileId,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
      id: json['id'],
      email: json['email'],
      completeName: json['completeName'],
      age: json['age'],
      address: json['address'],
      caregiverExperience: json['caregiverExperience'],
      completedServices: json['completedServices'],
      biography: json['biography'],
      profileImage: json['profileImage'],
      farePerHour: json['farePerHour'],
      districtsScope: json['districtsScope'],
      profileId: json['profileId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'completeName': completeName,
      'age': age,
      'address': address,
      'caregiverExperience': caregiverExperience,
      'completedServices': completedServices,
      'biography': biography,
      'profileImage': profileImage,
      'farePerHour': farePerHour,
      'districtsScope': districtsScope,
      'profileId': profileId,
    };
  }
}