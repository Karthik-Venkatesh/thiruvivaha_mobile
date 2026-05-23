import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/partner_preferences.dart';
import 'package:thiruvivaha_mobile/features/home/presentation/providers/partner_preferences_provider.dart';
import 'package:thiruvivaha_mobile/features/home/widgets/home_filter_chip.dart';
import 'package:thiruvivaha_mobile/features/home/widgets/profile_match_card.dart';
import 'package:thiruvivaha_mobile/features/home/widgets/today_match_avatar.dart';

// ---------------------------------------------------------------------------
// Mock data (replace with real providers/repositories later)
// ---------------------------------------------------------------------------

class _TodayMatch {
  final String name;
  final int age;
  final Color avatarColor;
  const _TodayMatch(this.name, this.age, this.avatarColor);
}

class _ProfileCard {
  final String name;
  final int age;
  final String profession;
  final String city;
  final Color cardColor;
  const _ProfileCard(
    this.name,
    this.age,
    this.profession,
    this.city,
    this.cardColor,
  );
}

const _todayMatches = [
  _TodayMatch('Priya', 26, Color(0xFFB5927B)),
  _TodayMatch('Ananya', 25, Color(0xFFD4956A)),
  _TodayMatch('Rahul', 29, Color(0xFF6B8CAE)),
  _TodayMatch('Sana', 27, Color(0xFFD4A574)),
];

const _profileCards = [
  _ProfileCard(
    'Meera Iyer',
    27,
    'Software Engineer',
    'Mumbai',
    Color(0xFF8B7355),
  ),
  _ProfileCard('Vikram Mehta', 30, 'C.A.', 'Ahmedabad', Color(0xFF9B8B7A)),
  _ProfileCard(
    'Aditi Sharma',
    25,
    'Graphic Designer',
    'Bangalore',
    Color(0xFF7A9B7A),
  ),
];

// ---------------------------------------------------------------------------
// MatchesTab
// ---------------------------------------------------------------------------

class MatchesTab extends ConsumerWidget {
  const MatchesTab({super.key});

  static const _primary = Color(0xFF7b001f);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(partnerPreferencesProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTodaysMatches(),
          _buildFilters(prefsAsync),
          _buildMatchesGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTodaysMatches() {
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _todayMatches.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final m = _todayMatches[index];
                return TodayMatchAvatar(
                  name: m.name,
                  age: m.age,
                  avatarColor: m.avatarColor,
                  primary: _primary,
                );
              },
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

  Widget _buildMatchesGrid() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileMatchCard(
                  name: _profileCards[0].name,
                  age: _profileCards[0].age,
                  profession: _profileCards[0].profession,
                  city: _profileCards[0].city,
                  cardColor: _profileCards[0].cardColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileMatchCard(
                  name: _profileCards[1].name,
                  age: _profileCards[1].age,
                  profession: _profileCards[1].profession,
                  city: _profileCards[1].city,
                  cardColor: _profileCards[1].cardColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProfileMatchCard(
                  name: _profileCards[2].name,
                  age: _profileCards[2].age,
                  profession: _profileCards[2].profession,
                  city: _profileCards[2].city,
                  cardColor: _profileCards[2].cardColor,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}
