import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../solar_system/solar_system_screen.dart';
import 'widgets/feature_section.dart';
import 'widgets/home_header.dart';
import 'widgets/home_hero.dart';
import 'widgets/tahukah_kamu_card.dart';

/// Home Screen (Beranda)
/// Implements structure according to PRD_DESIGN.md Section 12:
/// Header ↓ Hero ↓ Fitur Utama ↓ Tahukah Kamu?
class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onSelectTab;

  const HomeScreen({
    super.key,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              const HomeHeader(),

              const SizedBox(height: AppSpacing.s8),

              // 2. Hero Section
              HomeHero(
                onStartExploration: () => onSelectTab(1), // Go to Planet Explorer
              ),

              const SizedBox(height: AppSpacing.s32),

              // 3. Fitur Utama (2x2 Grid)
              FeatureSection(
                onPlanetExplorerTap: () => onSelectTab(1),
                onSolarSystemTap: () => _openSolarSystem(context),
                onArExplorerTap: () => onSelectTab(2),
                onQuizTap: () => onSelectTab(3),
              ),

              const SizedBox(height: AppSpacing.s32),

              // 4. Tahukah Kamu?
              TahukahKamuCard(
                onLearnMore: () => _showLearnMoreInfo(context),
              ),

              const SizedBox(height: AppSpacing.s32),
            ],
          ),
        ),
      ),
    );
  }

  void _openSolarSystem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => const SolarSystemScreen(),
      ),
    );
  }

  void _showLearnMoreInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.roundedCard,
            side: const BorderSide(color: AppColors.border, width: 1.0),
          ),
          title: Text('Fakta Jupiter', style: AppTypography.section),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jupiter adalah planet kelima dari Matahari dan yang terbesar di Tata Surya.',
                style: AppTypography.body,
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'Volume Jupiter sangat besar sehingga dapat menampung lebih dari 1.300 planet seukuran Bumi di dalamnya!',
                style: AppTypography.bodySecondary,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onSelectTab(1); // Jump to Planet Explorer
              },
              child: Text(
                'Buka Planet Explorer',
                style: AppTypography.buttonLabel.copyWith(
                  color: AppColors.mutedLavender,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
