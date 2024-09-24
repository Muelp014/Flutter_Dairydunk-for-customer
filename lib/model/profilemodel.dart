class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String location;
  final String? profilePictureUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.location,
    this.profilePictureUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  static UserProfile fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      location: map['location'],
      profilePictureUrl: map['profilePictureUrl'],
    );
  }
}
