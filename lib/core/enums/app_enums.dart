// ============================================================
// App Enums — mirrors SQL enum types in schema.sql
// ============================================================

enum GenderType {
  male('Male'),
  female('Female'),
  other('Other');

  const GenderType(this.value);
  final String value;

  static GenderType fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum MaritalStatusType {
  neverMarried('Never Married'),
  divorced('Divorced'),
  widowed('Widowed'),
  separated('Separated'),
  awaitingDivorce('Awaiting Divorce');

  const MaritalStatusType(this.value);
  final String value;

  static MaritalStatusType fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum FamilyType {
  nuclear('Nuclear'),
  joint('Joint'),
  extended('Extended');

  const FamilyType(this.value);
  final String value;

  static FamilyType fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum FamilyValues {
  traditional('Traditional'),
  moderate('Moderate'),
  liberal('Liberal');

  const FamilyValues(this.value);
  final String value;

  static FamilyValues fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum FamilyStatus {
  upperClass('Upper Class'),
  upperMiddleClass('Upper-Middle Class'),
  middleClass('Middle Class'),
  lowerMiddleClass('Lower-Middle Class'),
  lowerClass('Lower Class');

  const FamilyStatus(this.value);
  final String value;

  static FamilyStatus fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum DietType {
  vegetarian('Vegetarian'),
  nonVegetarian('Non Vegetarian'),
  vegan('Vegan'),
  eggetarian('Eggetarian');

  const DietType(this.value);
  final String value;

  static DietType fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum HabitType {
  no('No'),
  occasionally('Occasionally'),
  yes('Yes');

  const HabitType(this.value);
  final String value;

  static HabitType fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum ProfileStatus {
  active('Active'),
  inactive('Inactive'),
  suspended('Suspended'),
  deleted('Deleted');

  const ProfileStatus(this.value);
  final String value;

  static ProfileStatus fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum ConnectionStatus {
  pending('Pending'),
  accepted('Accepted'),
  rejected('Rejected'),
  blocked('Blocked');

  const ConnectionStatus(this.value);
  final String value;

  static ConnectionStatus fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum VerificationStatus {
  pending('Pending'),
  verified('Verified'),
  rejected('Rejected');

  const VerificationStatus(this.value);
  final String value;

  static VerificationStatus fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum PlanStatus {
  active('Active'),
  expired('Expired'),
  cancelled('Cancelled');

  const PlanStatus(this.value);
  final String value;

  static PlanStatus fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum PlanName {
  free('Free'),
  silver('Silver'),
  gold('Gold'),
  platinum('Platinum');

  const PlanName(this.value);
  final String value;

  static PlanName fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum ContactType {
  phone('Phone'),
  email('Email');

  const ContactType(this.value);
  final String value;

  static ContactType fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum EducationType {
  highSchool('High School'),
  diploma('Diploma'),
  bachelorsDegree("Bachelor's Degree"),
  mastersDegree("Master's Degree"),
  phd('PhD / Doctorate'),
  professionalDegree('Professional Degree (CA / MBBS / LLB)');

  const EducationType(this.value);
  final String value;

  static EducationType fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}

// ------------------------------------

enum OccupationType {
  engineeringIt('Engineering / IT'),
  doctorMedical('Doctor / Medical'),
  businessEntrepreneur('Business / Entrepreneur'),
  governmentPsu('Government / PSU'),
  financeBanking('Finance / Banking'),
  law('Law'),
  teachingAcademia('Teaching / Academia'),
  artsDesignMedia('Arts / Design / Media'),
  other('Other');

  const OccupationType(this.value);
  final String value;

  static OccupationType fromString(String s) =>
      values.firstWhere((e) => e.value == s);
}
