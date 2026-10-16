import 'package:flutter/material.dart';
import '../../data/planet_data.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import '../planet/planet_detail_screen.dart';
import 'widgets/planet_card.dart';

/// Planet Explorer Screen
/// Displays all 8 planets from PlanetData in a 2-column grid.
/// Defined in PRD_DESIGN.md Section 17.
class PlanetExplorerScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const PlanetExplorerScreen({
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
                    // Back button (navigates back to Beranda or pops route)
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
                            'Planet',
                            style: AppTypography.heading,
                          ),
                          const SizedBox(height: AppSpacing.s4),
                          Text(
                            'Kenali planet-planet di Tata Surya',
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
                  // Fixed aspect ratio matches PlanetCard height=190 at ~half screen width
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final planet = planets[index];
                    return PlanetCard(
                      planet: planet,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => PlanetDetailScreen(planet: planet),
                          ),
                        );
                      },
                    );
                  },
                  childCount: planets.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.s32)),
          ],
        ),
      ),
    );
  }
}
