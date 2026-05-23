class PartnerPreferences {
  final String? id;
  final int? ageMin;
  final int? ageMax;
  final int? heightMinCm;
  final int? heightMaxCm;
  final String? religion;
  final String? caste;
  final String? education;
  final String? occupation;
  final int? incomeMin;
  final String? location;
  final String? diet;
  final String? maritalStatus;
  final String? smoking;
  final String? drinking;

  const PartnerPreferences({
    this.id,
    this.ageMin,
    this.ageMax,
    this.heightMinCm,
    this.heightMaxCm,
    this.religion,
    this.caste,
    this.education,
    this.occupation,
    this.incomeMin,
    this.location,
    this.diet,
    this.maritalStatus,
    this.smoking,
    this.drinking,
  });

  factory PartnerPreferences.fromMap(Map<String, dynamic> map) {
    return PartnerPreferences(
      id: map['id'] as String?,
      ageMin: map['age_min'] as int?,
      ageMax: map['age_max'] as int?,
      heightMinCm: map['height_min_cm'] as int?,
      heightMaxCm: map['height_max_cm'] as int?,
      religion: map['religion'] as String?,
      caste: map['caste'] as String?,
      education: map['education'] as String?,
      occupation: map['occupation'] as String?,
      incomeMin: map['income_min'] as int?,
      location: map['location'] as String?,
      diet: map['diet'] as String?,
      maritalStatus: map['marital_status'] as String?,
      smoking: map['smoking'] as String?,
      drinking: map['drinking'] as String?,
    );
  }

  /// Returns non-null preference fields as human-readable filter chip labels.
  List<String> toFilterLabels() {
    final labels = <String>[];

    if (ageMin != null && ageMax != null) {
      labels.add('Age: $ageMin–$ageMax');
    } else if (ageMin != null) {
      labels.add('Age: $ageMin+');
    } else if (ageMax != null) {
      labels.add('Age: up to $ageMax');
    }

    if (religion != null) labels.add('Religion: $religion');
    if (caste != null) labels.add('Caste: $caste');
    if (location != null) labels.add('Location: $location');
    if (education != null) labels.add('Education: $education');
    if (occupation != null) labels.add('Occupation: $occupation');
    if (diet != null) labels.add('Diet: $diet');
    if (maritalStatus != null) labels.add('Marital Status: $maritalStatus');

    if (heightMinCm != null && heightMaxCm != null) {
      labels.add('Height: ${heightMinCm}–${heightMaxCm} cm');
    }

    return labels;
  }
}
