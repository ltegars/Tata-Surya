import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widgets/widgets.dart';
import '../../planet/widgets/planet_visual_placeholder.dart';

/// Hero Section for Home Screen
/// Defined in PRD_DESIGN.md Section 13:
/// Greeting: "Halo, Penjelajah!"
/// Title: "Jelajahi Tata Surya"
/// Description: "Kenali planet, temukan fakta menarik, dan jelajahi luar angkasa."
/// CTA: "Mulai Eksplorasi →"
class HomeHero extends StatelessWidget {
  final VoidCallback onStartExploration;

  const HomeHero({
    super.key,
    required this.onStartExploration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s8),

          // Integrated Planet Visual Area
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle space aura / atmospheric limb
                  Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.planetEarth.withValues(alpha: 0.18),
                          blurRadius: 36,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.mutedLavender.withValues(alpha: 0.12),
                          blurRadius: 50,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),

                  // Earth Planet Asset seamlessly integrated into deep navy
                  const PlanetVisualPlaceholder(
                    planetId: 'earth',
                    planetName: 'Bumi',
                    accentColor: AppColors.planetEarth,
                    size: 180,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.s20),

          // Greeting
          Text(
            'Halo, Penjelajah!',
            style: AppTypography.caption.copyWith(
              color: AppColors.paleLavender,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSpacing.s4),

          // Main Title
          Text(
            'Jelajahi\nTata Surya',
            style: AppTypography.display.copyWith(
              fontSize: 34,
              height: 1.15,
            ),
          ),

          const SizedBox(height: AppSpacing.s12),

          // Description
          Text(
            'Kenali planet, temukan fakta menarik, dan jelajahi luar angkasa.',
            style: AppTypography.bodySecondary.copyWith(
              fontSize: 15,
              height: 1.45,
            ),
          ),

          const SizedBox(height: AppSpacing.s20),

          // Primary CTA Button
          AppButton(
            text: 'Mulai Eksplorasi →',
            onPressed: onStartExploration,
          ),
        ],
      ),
    );
  }
}

