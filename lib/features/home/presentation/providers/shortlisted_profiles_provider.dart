import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiruvivaha_mobile/config/supabase_config.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/shortlisted_profile.dart';

class ShortlistedProfilesState {
  final List<ShortlistedProfile> shortlistedByMe;
  final List<ShortlistedProfile> shortlistedBySomeone;
  final List<ShortlistedProfile> skippedProfiles;
  final bool isLoading;
  final String? error;

  const ShortlistedProfilesState({
    this.shortlistedByMe = const [],
    this.shortlistedBySomeone = const [],
    this.skippedProfiles = const [],
    this.isLoading = true,
    this.error,
  });

  ShortlistedProfilesState copyWith({
    List<ShortlistedProfile>? shortlistedByMe,
    List<ShortlistedProfile>? shortlistedBySomeone,
    List<ShortlistedProfile>? skippedProfiles,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ShortlistedProfilesState(
      shortlistedByMe: shortlistedByMe ?? this.shortlistedByMe,
      shortlistedBySomeone: shortlistedBySomeone ?? this.shortlistedBySomeone,
      skippedProfiles: skippedProfiles ?? this.skippedProfiles,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class ShortlistedProfilesNotifier
    extends StateNotifier<ShortlistedProfilesState> {
  ShortlistedProfilesNotifier() : super(const ShortlistedProfilesState()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    final authUserId = SupabaseConfig.auth.currentUser?.id;
    if (authUserId == null) {
      state = const ShortlistedProfilesState(isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final currentProfileId = await _fetchCurrentProfileId(authUserId);
      if (currentProfileId == null) {
        state = const ShortlistedProfilesState(isLoading: false);
        return;
      }

      final shortlistedByMeEntries = await _fetchShortlistEntries(
        userId: currentProfileId,
        type: _ShortlistQueryType.byMe,
      );
      final shortlistedBySomeoneEntries = await _fetchShortlistEntries(
        userId: currentProfileId,
        type: _ShortlistQueryType.bySomeone,
      );
      final skippedEntries = await _fetchSkippedEntries(currentProfileId);

      final shortlistedByMe = await _hydrateProfiles(shortlistedByMeEntries);
      final shortlistedBySomeone = await _hydrateProfiles(
        shortlistedBySomeoneEntries,
      );
      final skippedProfiles = await _hydrateProfiles(skippedEntries);

      state = state.copyWith(
        shortlistedByMe: shortlistedByMe,
        shortlistedBySomeone: shortlistedBySomeone,
        skippedProfiles: skippedProfiles,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<String?> _fetchCurrentProfileId(String authUserId) async {
    final response = await SupabaseConfig.client
        .from('profiles')
        .select('id')
        .eq('auth_user_id', authUserId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return response['id'] as String?;
  }

  Future<List<_ShortlistedEntry>> _fetchShortlistEntries({
    required String userId,
    required _ShortlistQueryType type,
  }) async {
    final query = SupabaseConfig.client.from('shortlisted_profiles');

    final response = switch (type) {
      _ShortlistQueryType.byMe =>
        await query
            .select('id, profile_id, created_at')
            .eq('user_id', userId)
            .order('created_at', ascending: false),
      _ShortlistQueryType.bySomeone =>
        await query
            .select('id, user_id, created_at')
            .eq('profile_id', userId)
            .order('created_at', ascending: false),
    };

    final rows = response as List<dynamic>;

    return rows.map((row) {
      final map = row as Map<String, dynamic>;
      final profileId = switch (type) {
        _ShortlistQueryType.byMe => map['profile_id'] as String,
        _ShortlistQueryType.bySomeone => map['user_id'] as String,
      };

      return _ShortlistedEntry(
        profileId: profileId,
        shortlistedAt: _parseDate(map['created_at']),
      );
    }).toList();
  }

  Future<List<_ShortlistedEntry>> _fetchSkippedEntries(
    String userId,
  ) async {
    final response = await SupabaseConfig.client
        .from('skipped_profiles')
        .select('id, profile_id, created_at')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final rows = response as List<dynamic>;

    return rows.map((row) {
      final map = row as Map<String, dynamic>;
      return _ShortlistedEntry(
        profileId: map['profile_id'] as String,
        shortlistedAt: _parseDate(map['created_at']),
      );
    }).toList();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Future<List<ShortlistedProfile>> _hydrateProfiles(
    List<_ShortlistedEntry> entries,
  ) async {
    if (entries.isEmpty) {
      return const [];
    }

    final profileIds = entries.map((entry) => entry.profileId).toList();

    final response = await SupabaseConfig.client
        .from('profiles')
        .select('id, full_name, date_of_birth, occupation, city, state')
        .in_('id', profileIds)
        .order('full_name');

    final rows = response as List<dynamic>;
    final byId = {
      for (final row in rows)
        (row as Map<String, dynamic>)['id'] as String:
            ShortlistedProfile.fromMap(row),
    };

    return entries
        .map((entry) {
          final profile = byId[entry.profileId];
          if (profile == null) {
            return null;
          }

          return profile.copyWith(shortlistedAt: entry.shortlistedAt);
        })
        .whereType<ShortlistedProfile>()
        .toList();
  }
}

enum _ShortlistQueryType { byMe, bySomeone }

class _ShortlistedEntry {
  final String profileId;
  final DateTime? shortlistedAt;

  const _ShortlistedEntry({required this.profileId, this.shortlistedAt});
}

final shortlistedProfilesProvider =
    StateNotifierProvider<
      ShortlistedProfilesNotifier,
      ShortlistedProfilesState
    >((_) => ShortlistedProfilesNotifier());
