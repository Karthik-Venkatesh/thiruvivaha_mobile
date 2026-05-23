import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/daily_recommendation.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/partner_preferences.dart';
import 'package:thiruvivaha_mobile/features/home/presentation/providers/daily_recommendations_provider.dart';
import 'package:thiruvivaha_mobile/features/home/presentation/providers/filtered_profiles_provider.dart';
import 'package:thiruvivaha_mobile/features/home/presentation/providers/partner_preferences_provider.dart';
import 'package:thiruvivaha_mobile/features/home/widgets/home_filter_chip.dart';
import 'package:thiruvivaha_mobile/features/home/widgets/profile_match_card.dart';
import 'package:thiruvivaha_mobile/features/home/widgets/today_match_avatar.dart';

// Palette cycled for avatar/card backgrounds when no photo is available.
const _cardColors = [
  Color(0xFFB5927B),
  Color(0xFFD4956A),
  Color(0xFF6B8CAE),
  Color(0xFFD4A574),
  Color(0xFF7A9B7A),
];

// ---------------------------------------------------------------------------
// MatchesTab
// ---------------------------------------------------------------------------

class MatchesTab extends ConsumerStatefulWidget {
  const MatchesTab({super.key});

  @override
  ConsumerState<MatchesTab> createState() => _MatchesTabState();
}

class _MatchesTabState extends ConsumerState<MatchesTab> {
  static const _primary = Color(0xFF7b001f);

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      ref.read(filteredProfilesProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(partnerPreferencesProvider);
    final recsAsync = ref.watch(dailyRecommendationsProvider);
    final filtered = ref.watch(filteredProfilesProvider);

    return RefreshIndicator(
      color: _primary,
      onRefresh: () async {
        ref.invalidate(dailyRecommendationsProvider);
        await ref.read(filteredProfilesProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTodaysMatches(recsAsync),
            _buildFilters(prefsAsync),
            _buildMatchesGrid(filtered),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysMatches(AsyncValue<List<DailyRecommendation>> recsAsync) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Today's Matches",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1a1c1c),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'VIEW ALL',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: recsAsync.when(
              data: (recs) => recs.isEmpty
                  ? Center(
                      child: Text(
                        'No matches found',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final r = recs[index];
                        return TodayMatchAvatar(
                          name: r.fullName,
                          age: r.age ?? 0,
                          avatarColor: _cardColors[index % _cardColors.length],
                          primary: _primary,
                        );
                      },
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (_, __) => Center(
                child: Text(
                  'Failed to load matches',
                  style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AsyncValue<PartnerPreferences?> prefsAsync) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD6D6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tune, size: 16, color: _primary),
                  const SizedBox(width: 6),
                  Text(
                    'Filters',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _primary,
                    ),
                  ),
                ],
              ),
            ),
            ...prefsAsync.when<List<Widget>>(
              data: (prefs) {
                final labels = prefs?.toFilterLabels() ?? const <String>[];
                return labels.map<Widget>((label) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: HomeFilterChip(label: label),
                  );
                }).toList();
              },
              loading: () => [
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ],
              error: (_, __) => const <Widget>[],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesGrid(FilteredProfilesState state) {
    // ── Initial loading ────────────────────────────────────────────────────
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(48),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    // ── Error ──────────────────────────────────────────────────────────────
    if (state.error != null && state.profiles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Failed to load profiles',
            style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey),
          ),
        ),
      );
    }

    // ── Empty ──────────────────────────────────────────────────────────────
    if (state.profiles.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No matches found',
            style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey),
          ),
        ),
      );
    }

    // ── Grid ───────────────────────────────────────────────────────────────
    final recs = state.profiles;
    final rows = <Widget>[];

    for (int i = 0; i < recs.length; i += 2) {
      final left = recs[i];
      final right = i + 1 < recs.length ? recs[i + 1] : null;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProfileMatchCard(
                name: left.fullName,
                age: left.age ?? 0,
                profession: left.occupation ?? '—',
                city: left.displayLocation,
                cardColor: _cardColors[i % _cardColors.length],
                onSkip: () => ref
                    .read(filteredProfilesProvider.notifier)
                    .skipProfile(left.id),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: right != null
                  ? ProfileMatchCard(
                      name: right.fullName,
                      age: right.age ?? 0,
                      profession: right.occupation ?? '—',
                      city: right.displayLocation,
                      cardColor: _cardColors[(i + 1) % _cardColors.length],
                      onSkip: () => ref
                          .read(filteredProfilesProvider.notifier)
                          .skipProfile(right.id),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
      if (i + 2 < recs.length) rows.add(const SizedBox(height: 12));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        children: [
          ...rows,
          const SizedBox(height: 16),
          // ── Pagination footer ────────────────────────────────────────
          if (state.isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (!state.hasMore)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'You\'ve seen all matches',
                style: GoogleFonts.manrope(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
