class ShortlistedProfile {
  final String profileId;
  final String fullName;
  final DateTime? dateOfBirth;
  final String? occupation;
  final String? city;
  final String? state;
  final String? primaryPhoto;
  final DateTime? shortlistedAt;

  const ShortlistedProfile({
    required this.profileId,
    required this.fullName,
    this.dateOfBirth,
    this.occupation,
    this.city,
    this.state,
    this.primaryPhoto,
    this.shortlistedAt,
  });

  int? get age {
    if (dateOfBirth == null) return null;

    final today = DateTime.now();
    int age = today.year - dateOfBirth!.year;
    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month && today.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  String get displayLocation {
    if (city != null && city!.isNotEmpty) return city!;
    if (state != null && state!.isNotEmpty) return state!;
    return '';
  }

  ShortlistedProfile copyWith({
    String? profileId,
    String? fullName,
    DateTime? dateOfBirth,
    String? occupation,
    String? city,
    String? state,
    String? primaryPhoto,
    DateTime? shortlistedAt,
  }) {
    return ShortlistedProfile(
      profileId: profileId ?? this.profileId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      occupation: occupation ?? this.occupation,
      city: city ?? this.city,
      state: state ?? this.state,
      primaryPhoto: primaryPhoto ?? this.primaryPhoto,
      shortlistedAt: shortlistedAt ?? this.shortlistedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  factory ShortlistedProfile.fromMap(Map<String, dynamic> map) {
    return ShortlistedProfile(
      profileId: map['id'] as String,
      fullName: map['full_name'] as String? ?? 'Unknown',
      dateOfBirth: _parseDate(map['date_of_birth']),
      occupation: map['occupation'] as String?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      primaryPhoto: map['primary_photo'] as String?,
      shortlistedAt: _parseDate(map['shortlisted_at']),
    );
  }
}
