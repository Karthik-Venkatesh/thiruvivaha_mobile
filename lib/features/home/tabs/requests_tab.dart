import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/connection_request.dart';
import 'package:thiruvivaha_mobile/features/home/presentation/providers/connections_provider.dart';

class RequestsTab extends ConsumerStatefulWidget {
  const RequestsTab({super.key});

  @override
  ConsumerState<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends ConsumerState<RequestsTab>
    with SingleTickerProviderStateMixin {
  static const _primary = Color(0xFF7b001f);

  static const _tabs = ['Received', 'Sent', 'Accepted', 'Rejected'];

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
    final state = ref.watch(connectionsProvider);

    return RefreshIndicator(
      color: _primary,
      onRefresh: () => ref.read(connectionsProvider.notifier).fetchAll(),
      child: Column(
        children: [
          // ── Tab bar ────────────────────────────────────────────────────
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
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // ── Tab views ──────────────────────────────────────────────────
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(
                        items: state.received,
                        emptyMessage: 'No received requests',
                        showActions: true,
                      ),
                      _buildList(
                        items: state.sent,
                        emptyMessage: 'No sent requests',
                      ),
                      _buildList(
                        items: state.accepted,
                        emptyMessage: 'No accepted connections',
                        badgeType: _BadgeType.accepted,
                      ),
                      _buildList(
                        items: state.rejected,
                        emptyMessage: 'No rejected requests',
                        badgeType: _BadgeType.rejected,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList({
    required List<ConnectionRequest> items,
    required String emptyMessage,
    bool showActions = false,
    _BadgeType? badgeType,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_add_outlined,
              size: 56,
              color: Color(0xFFCCCCCC),
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: const Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 80, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) => _RequestTile(
        item: items[index],
        showActions: showActions,
        badgeLabel: badgeType == null
            ? null
            : badgeType == _BadgeType.accepted
            ? (items[index].isSender ? 'Accepted by them' : 'Accepted by you')
            : (items[index].isSender ? 'Rejected by them' : 'Rejected by you'),
        onAccept: showActions
            ? () => ref
                  .read(connectionsProvider.notifier)
                  .respond(
                    connectionId: items[index].connectionId,
                    accept: true,
                  )
            : null,
        onReject: showActions
            ? () => ref
                  .read(connectionsProvider.notifier)
                  .respond(
                    connectionId: items[index].connectionId,
                    accept: false,
                  )
            : null,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Request tile
// ---------------------------------------------------------------------------

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.item,
    required this.showActions,
    this.badgeLabel,
    this.onAccept,
    this.onReject,
  });

  static const _primary = Color(0xFF7b001f);

  final ConnectionRequest item;
  final bool showActions;
  final String? badgeLabel;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (item.occupation != null && item.occupation!.isNotEmpty)
        item.occupation!,
      if (item.displayLocation.isNotEmpty) item.displayLocation,
    ].join(' • ');

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // ── Avatar ────────────────────────────────────────────────────
          _Avatar(name: item.fullName, photoPath: item.primaryPhoto),
          const SizedBox(width: 14),

          // ── Name / subtitle ───────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.fullName}${item.age != null ? ', ${item.age}' : ''}',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1a1c1c),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                if (badgeLabel != null) ...[
                  const SizedBox(height: 4),
                  _StatusBadge(label: badgeLabel!),
                ],
              ],
            ),
          ),

          // ── Action buttons (received tab only) ────────────────────────
          if (showActions) ...[
            const SizedBox(width: 10),
            _ActionButton(
              icon: Icons.check,
              filled: true,
              color: _primary,
              onTap: onAccept,
            ),
            const SizedBox(width: 8),
            _ActionButton(
              icon: Icons.close,
              filled: false,
              color: const Color(0xFF888888),
              onTap: onReject,
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Avatar
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Action button
// ---------------------------------------------------------------------------

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.filled,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final bool filled;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? color : Colors.transparent,
          border: filled
              ? null
              : Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
        ),
        child: Icon(
          icon,
          size: 20,
          color: filled ? Colors.white : const Color(0xFF888888),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Status badge — shown on accepted / rejected tiles
// ---------------------------------------------------------------------------

enum _BadgeType { accepted, rejected }

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isAccepted = label.startsWith('Accepted');
    final color = isAccepted
        ? const Color(0xFF2e7d32) // green for accepted
        : const Color(0xFF888888); // grey for rejected

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
