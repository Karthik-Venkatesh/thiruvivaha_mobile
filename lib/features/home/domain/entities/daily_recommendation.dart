class DailyRecommendation {
  final String id;
  final String fullName;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? religion;
  final String? caste;
  final String? education;
  final String? occupation;
  final int? annualIncome;
  final String? city;
  final String? state;
  final String? country;
  final int? heightCm;
  final String? complexion;
  final String? diet;
  final String? maritalStatus;
  final String? primaryPhoto;

  const DailyRecommendation({
    required this.id,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.religion,
    this.caste,
    this.education,
    this.occupation,
    this.annualIncome,
    this.city,
    this.state,
    this.country,
    this.heightCm,
    this.complexion,
    this.diet,
    this.maritalStatus,
    this.primaryPhoto,
  });

  int? get age {
    if (dateOfBirth == null) return null;
    final today = DateTime.now();
    int a = today.year - dateOfBirth!.year;
    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month && today.day < dateOfBirth!.day)) {
      a--;
    }
    return a;
  }

  String get displayLocation {
    if (city != null && city!.isNotEmpty) return city!;
    if (state != null && state!.isNotEmpty) return state!;
    if (country != null && country!.isNotEmpty) return country!;
    return '';
  }

  factory DailyRecommendation.fromMap(Map<String, dynamic> map) {
    return DailyRecommendation(
      id: map['id'] as String,
      fullName: map['full_name'] as String? ?? 'Unknown',
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.tryParse(map['date_of_birth'] as String)
          : null,
      gender: map['gender'] as String?,
      religion: map['religion'] as String?,
      caste: map['caste'] as String?,
      education: map['education'] as String?,
      occupation: map['occupation'] as String?,
      annualIncome: map['annual_income'] as int?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      country: map['country'] as String?,
      heightCm: map['height_cm'] as int?,
      complexion: map['complexion'] as String?,
      diet: map['diet'] as String?,
      maritalStatus: map['marital_status'] as String?,
      primaryPhoto: map['primary_photo'] as String?,
    );
  }
}
