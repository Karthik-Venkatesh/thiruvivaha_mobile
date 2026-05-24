class ConnectionRequest {
  final String connectionId;
  final String profileId;
  final String fullName;
  final DateTime? dateOfBirth;
  final String? occupation;
  final String? city;
  final String? state;
  final String? primaryPhoto;
  final String? message;
  final DateTime? createdAt;

  /// Whether the current user sent this request (true = I sent, false = they sent).
  final bool isSender;

  const ConnectionRequest({
    required this.connectionId,
    required this.profileId,
    required this.fullName,
    this.dateOfBirth,
    this.occupation,
    this.city,
    this.state,
    this.primaryPhoto,
    this.message,
    this.createdAt,
    this.isSender = false,
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
    return '';
  }

  factory ConnectionRequest.fromMap(Map<String, dynamic> map) {
    return ConnectionRequest(
      connectionId: map['connection_id'] as String,
      profileId: map['profile_id'] as String,
      fullName: map['full_name'] as String? ?? 'Unknown',
      dateOfBirth: map['date_of_birth'] != null
          ? DateTime.tryParse(map['date_of_birth'] as String)
          : null,
      occupation: map['occupation'] as String?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      primaryPhoto: map['primary_photo'] as String?,
      message: map['message'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'] as String)
          : null,
      isSender: map['is_sender'] as bool? ?? false,
    );
  }
}
