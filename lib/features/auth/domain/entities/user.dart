class UserEntity {
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? profileImageUrl;
  final String? bio;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? religion;
  final String? caste;
  final String? occupation;
  final String? education;
  final String? location;
  final bool emailVerified;
  final bool phoneVerified;
  final bool profileComplete;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.profileImageUrl,
    this.bio,
    this.gender,
    this.dateOfBirth,
    this.religion,
    this.caste,
    this.occupation,
    this.education,
    this.location,
    this.emailVerified = false,
    this.phoneVerified = false,
    this.profileComplete = false,
    required this.createdAt,
    required this.updatedAt,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? profileImageUrl,
    String? bio,
    String? gender,
    DateTime? dateOfBirth,
    String? religion,
    String? caste,
    String? occupation,
    String? education,
    String? location,
    bool? emailVerified,
    bool? phoneVerified,
    bool? profileComplete,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      location: location ?? this.location,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      profileComplete: profileComplete ?? this.profileComplete,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'UserEntity(id: $id, email: $email, fullName: $fullName)';
}

class AuthSuccessResponse {
  final String accessToken;
  final String? refreshToken;
  final UserEntity user;

  AuthSuccessResponse({
    required this.accessToken,
    this.refreshToken,
    required this.user,
  });
}
