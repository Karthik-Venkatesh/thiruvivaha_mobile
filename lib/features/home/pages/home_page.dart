import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thiruvivaha_mobile/features/home/tabs/matches_tab.dart';
import 'package:thiruvivaha_mobile/features/home/tabs/requests_tab.dart';
import 'package:thiruvivaha_mobile/features/home/tabs/shortlisted_tab.dart';
import 'package:thiruvivaha_mobile/features/home/tabs/profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavIndex = 0;

  static const _primary = Color(0xFF7b001f);

  static const _tabTitles = [
    'Sacred Union',
    'Requests',
    'Shortlisted',
    'My Profile',
  ];

  static const _navLabels = ['Matches', 'Requests', 'Shortlisted', 'Profile'];

  static const _navIcons = [
    Icons.favorite_border,
    Icons.person_add_outlined,
    Icons.star_border,
    Icons.person_outline,
  ];

  static const _navActiveIcons = [
    Icons.favorite,
    Icons.person_add,
    Icons.star,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1a1c1c)),
          onPressed: () {},
        ),
        title: Text(
          _tabTitles[_currentNavIndex],
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF1a1c1c),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 1:
        return const RequestsTab();
      case 2:
        return const ShortlistedTab();
      case 3:
        return const ProfileTab();
      default:
        return const MatchesTab();
    }
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              final isActive = _currentNavIndex == i;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() => _currentNavIndex = i);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFFFD6D6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        isActive ? _navActiveIcons[i] : _navIcons[i],
                        color: isActive ? _primary : const Color(0xFF888888),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _navLabels[i],
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isActive ? _primary : const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
