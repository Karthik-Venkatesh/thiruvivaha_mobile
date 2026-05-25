import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/shortlisted_profile.dart';
import 'package:thiruvivaha_mobile/features/home/presentation/providers/shortlisted_profiles_provider.dart';

class ShortlistedTab extends ConsumerStatefulWidget {
  const ShortlistedTab({super.key});

  @override
  ConsumerState<ShortlistedTab> createState() => _ShortlistedTabState();
}

class _ShortlistedTabState extends ConsumerState<ShortlistedTab>
    with SingleTickerProviderStateMixin {
  static const _primary = Color(0xFF7b001f);
  static const _tabs = ['Shortlisted', 'Skipped Profiles'];

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shortlistedProfilesProvider);

    return RefreshIndicator(
      color: _primary,
      onRefresh: () =>
          ref.read(shortlistedProfilesProvider.notifier).fetchAll(),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: _primary,
              unselectedLabelColor: const Color(0xFF888888),
              indicatorColor: _primary,
              indicatorWeight: 2,
              labelStyle: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : state.error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 56,
                            color: Color(0xFFCCCCCC),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Unable to load profiles',
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              color: const Color(0xFF8c7071),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.error!,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              color: const Color(0xFFAAAAAA),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildShortlistedSection(
                        byMe: state.shortlistedByMe,
                        byThem: state.shortlistedBySomeone,
                      ),
                      _buildSkippedSection(items: state.skippedProfiles),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  /// Combined "Shortlisted" tab: single date-sorted list with inline
  /// "By you" / "By them" label inside each tile.
  Widget _buildShortlistedSection({
    required List<ShortlistedProfile> byMe,
    required List<ShortlistedProfile> byThem,
  }) {
    if (byMe.isEmpty && byThem.isEmpty) {
      return _buildEmpty(
        icon: Icons.favorite_border,
        title: 'No shortlisted profiles yet',
        subtitle: 'Profiles you or others shortlist will appear here',
      );
    }

    // Merge both lists with a byMe flag, then sort newest-first.
    final items = [
      for (final p in byMe) _ShortlistItem(profile: p, byMe: true),
      for (final p in byThem) _ShortlistItem(profile: p, byMe: false),
    ]..sort((a, b) {
        final aDate = a.profile.shortlistedAt;
        final bDate = b.profile.shortlistedAt;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return bDate.compareTo(aDate);
      });

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 80, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) => _ShortlistedTile(
        item: items[index].profile,
        byMeLabel: items[index].byMe,
      ),
    );
  }

  Widget _buildSkippedSection({required List<ShortlistedProfile> items}) {
    if (items.isEmpty) {
      return _buildEmpty(
        icon: Icons.skip_next_outlined,
        title: 'No skipped profiles',
        subtitle: 'Profiles you skip will appear here',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 80, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) =>
          _ShortlistedTile(item: items[index], isSkipped: true),
    );
  }

  Widget _buildEmpty({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: const Color(0xFFCCCCCC)),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: const Color(0xFFAAAAAA),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: const Color(0xFF8c7071),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ShortlistItem {
  final ShortlistedProfile profile;
  final bool byMe;
  const _ShortlistItem({required this.profile, required this.byMe});
}

class _ShortlistedTile extends StatelessWidget {
  const _ShortlistedTile({
    required this.item,
    this.isSkipped = false,
    this.byMeLabel,
  });

  static const _primary = Color(0xFF7b001f);

  final ShortlistedProfile item;
  final bool isSkipped;
  /// When non-null, show an inline "By you" / "By them" badge.
  final bool? byMeLabel;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (item.occupation != null && item.occupation!.isNotEmpty)
        item.occupation!,
      if (item.displayLocation.isNotEmpty) item.displayLocation,
    ].join(' • ');

    final dateLabel = isSkipped ? 'Skipped on' : 'Shortlisted on';

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _Avatar(name: item.fullName, photoPath: item.primaryPhoto),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${item.fullName}${item.age != null ? ', ${item.age}' : ''}',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1a1c1c),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (byMeLabel != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: byMeLabel!
                              ? _primary.withValues(alpha: 0.08)
                              : const Color(0xFF1565C0).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          byMeLabel! ? 'By you' : 'By them',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: byMeLabel!
                                ? _primary
                                : const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF888888),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (item.shortlistedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '$dateLabel ${item.shortlistedAt!.day.toString().padLeft(2, '0')}/${item.shortlistedAt!.month.toString().padLeft(2, '0')}/${item.shortlistedAt!.year}',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: isSkipped
                          ? const Color(0xFF888888)
                          : _primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.photoPath});

  final String name;
  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 60,
        height: 60,
        child: photoPath != null && photoPath!.isNotEmpty
            ? Image.network(photoPath!, fit: BoxFit.cover)
            : Container(
                color: const Color(0xFF7b001f).withValues(alpha: 0.15),
                child: Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF7b001f),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
