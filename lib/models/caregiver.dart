class Caregiver {
  final int? id;
  final String completeName;
  final int age;
  final String address;
  final int caregiverExperience;
  final int completedServices;
  final String biography;
  final String profileImage;
  final double farePerHour;
  final String districtsScope;
  final int? profileId;

  Caregiver({
    this.id,
    required this.completeName,
    required this.age,
    required this.address,
    required this.caregiverExperience,
    required this.completedServices,
    required this.biography,
    required this.profileImage,
    required this.farePerHour,
    required this.districtsScope,
    this.profileId,
  });

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
      id: json['id'],
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