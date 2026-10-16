import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'ar/ar_explorer_screen.dart';
import 'home/home_screen.dart';
import 'planet/planet_explorer_screen.dart';
import 'quiz/quiz_screen.dart';

/// Main Navigation Shell with 4-Tab Bottom Navigation
/// As defined in PRD_SYSTEM.md Section 6 & PRD_DESIGN.md Section 16:
/// - Beranda (Home)
/// - Planet (Planet Explorer)
/// - AR (AR Explorer)
/// - Quiz (Kuis Tata Surya)
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // Tab 0: Beranda (fully implemented)
      HomeScreen(
        onSelectTab: _onTabSelected,
      ),

      // Tab 1: Planet Explorer (Phase 3 — implemented)
      PlanetExplorerScreen(
        onBack: () => _onTabSelected(0),
      ),

      // Tab 2: AR Explorer (direct shortcuts to AR)
      ArExplorerScreen(
        onBack: () => _onTabSelected(0),
      ),

      // Tab 3: Quiz (Phase 5 — implemented)
      QuizScreen(onExitToHome: () => _onTabSelected(0)),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.border,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.mutedLavender,
          unselectedItemColor: AppColors.secondaryText,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
              tooltip: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public_outlined),
              activeIcon: Icon(Icons.public),
              label: 'Planet',
              tooltip: 'Planet Explorer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar_outlined),
              activeIcon: Icon(Icons.view_in_ar),
              label: 'AR',
              tooltip: 'AR Explorer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz_outlined),
              activeIcon: Icon(Icons.quiz),
              label: 'Quiz',
              tooltip: 'Kuis Tata Surya',
            ),
          ],
        ),
      ),
    );
  }
}
