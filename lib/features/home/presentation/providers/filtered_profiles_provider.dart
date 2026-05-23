import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiruvivaha_mobile/config/supabase_config.dart';
import 'package:thiruvivaha_mobile/core/utils/logger.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/daily_recommendation.dart';

const _pageSize = 20;

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class FilteredProfilesState {
  final List<DailyRecommendation> profiles;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  const FilteredProfilesState({
    this.profiles = const [],
    this.hasMore = true,
    this.isLoading = true,
    this.isLoadingMore = false,
    this.error,
  });

  FilteredProfilesState copyWith({
    List<DailyRecommendation>? profiles,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool clearError = false,
  }) {
    return FilteredProfilesState(
      profiles: profiles ?? this.profiles,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class FilteredProfilesNotifier extends StateNotifier<FilteredProfilesState> {
  FilteredProfilesNotifier() : super(const FilteredProfilesState()) {
    _fetch(offset: 0, initial: true);
  }

  Future<void> _fetch({required int offset, required bool initial}) async {
    final authUserId = SupabaseConfig.auth.currentUser?.id;
    if (authUserId == null) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
        clearError: true,
      );
      return;
    }

    if (initial) {
      state = state.copyWith(isLoading: true, clearError: true);
    } else {
      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    try {
      AppLogger.debug(
        'filteredProfiles: fetching offset=$offset limit=$_pageSize',
      );

      final response = await SupabaseConfig.client.rpc(
        'get_filtered_profiles',
        params: {'p_limit': _pageSize, 'p_offset': offset},
      );

      final rows = (response as List<dynamic>)
          .map((r) => DailyRecommendation.fromMap(r as Map<String, dynamic>))
          .toList();

      AppLogger.debug('filteredProfiles: got ${rows.length} profiles');

      if (initial) {
        state = FilteredProfilesState(
          profiles: rows,
          hasMore: rows.length == _pageSize,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          profiles: [...state.profiles, ...rows],
          hasMore: rows.length == _pageSize,
          isLoadingMore: false,
        );
      }
    } catch (e, st) {
      AppLogger.error('filteredProfiles: error — $e\n$st');
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Load the next page. No-op if already loading or no more pages.
  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isLoading || !state.hasMore) return;
    await _fetch(offset: state.profiles.length, initial: false);
  }

  /// Reload from the first page.
  Future<void> refresh() async {
    await _fetch(offset: 0, initial: true);
  }

  /// Insert a skip record and remove the profile from the local list.
  Future<void> skipProfile(String profileId) async {
    // Optimistically remove from UI immediately.
    state = state.copyWith(
      profiles: state.profiles.where((p) => p.id != profileId).toList(),
    );

    try {
      final authUserId = SupabaseConfig.auth.currentUser?.id;
      if (authUserId == null) return;

      final profileRes = await SupabaseConfig.client
          .from('profiles')
          .select('id')
          .eq('auth_user_id', authUserId)
          .single();

      await SupabaseConfig.client.from('skipped_profiles').insert({
        'user_id': profileRes['id'] as String,
        'profile_id': profileId,
      });

      AppLogger.debug('filteredProfiles: skipped profile $profileId');
    } catch (e) {
      AppLogger.error('filteredProfiles: skip failed — $e');
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final filteredProfilesProvider =
    StateNotifierProvider<FilteredProfilesNotifier, FilteredProfilesState>(
      (_) => FilteredProfilesNotifier(),
    );
