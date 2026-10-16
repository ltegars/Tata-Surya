import 'package:flutter/material.dart';
import '../../data/planet_data.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import '../planet/planet_ar_screen.dart';
import '../planet/widgets/planet_card.dart';

/// AR Explorer Screen
/// Displays all 8 planets in a 2-column grid as direct shortcuts to AR.
/// Flow: Bottom Nav → AR Explorer → tap planet → PlanetArScreen → AR
class ArExplorerScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const ArExplorerScreen({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final planets = PlanetData.planets;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s20,
                  AppSpacing.s20,
                  AppSpacing.s20,
                  AppSpacing.s8,
                ),
                child: Row(
                  children: [
                    AppIconButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: () {
                        if (onBack != null) {
                          onBack!();
                        } else if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      tooltip: 'Kembali',
                    ),
                    const SizedBox(width: AppSpacing.s12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AR Explorer',
                            style: AppTypography.heading,
                          ),
                          const SizedBox(height: AppSpacing.s4),
                          Text(
                            'Jelajahi planet di sekitarmu.',
                            style: AppTypography.bodySecondary.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s16)),

            // ── 2-Column Planet Grid ──
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.s12,
                  mainAxisSpacing: AppSpacing.s12,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final planet = planets[index];
                    return PlanetCard(
                      planet: planet,
                      actionIcon: Icons.view_in_ar_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => PlanetArScreen(planet: planet),
                          ),
                        );
                      },
                    );
                  },
                  childCount: planets.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s24)),
          ],
        ),
      ),
    );
  }
}
