import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widgets/widgets.dart';

/// Feature Section (Fitur Utama) 2x2 Grid
/// Defined in PRD_DESIGN.md Section 14:
/// - Planet Explorer (Kenali 8 planet)
/// - Tata Surya (Lihat gerakan planet)
/// - AR Explorer (Lihat planet di sekitarmu)
/// - Kuis Tata Surya (Uji pengetahuanmu)
class FeatureSection extends StatelessWidget {
  final VoidCallback onPlanetExplorerTap;
  final VoidCallback onSolarSystemTap;
  final VoidCallback onArExplorerTap;
  final VoidCallback onQuizTap;

  const FeatureSection({
    super.key,
    required this.onPlanetExplorerTap,
    required this.onSolarSystemTap,
    required this.onArExplorerTap,
    required this.onQuizTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitur Utama',
            style: AppTypography.section,
          ),
          const SizedBox(height: AppSpacing.s16),

          // 2x2 Grid Layout
          Row(
            children: [
              Expanded(
                child: _FeatureCard(
                  title: 'Planet Explorer',
                  description: 'Kenali 8 planet',
                  icon: Icons.public_outlined,
                  onTap: onPlanetExplorerTap,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _FeatureCard(
                  title: 'Tata Surya',
                  description: 'Lihat gerakan planet',
                  icon: Icons.change_circle_outlined,
                  onTap: onSolarSystemTap,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          Row(
            children: [
              Expanded(
                child: _FeatureCard(
                  title: 'AR Explorer',
                  description: 'Lihat planet di sekitarmu',
                  icon: Icons.view_in_ar_outlined,
                  onTap: onArExplorerTap,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _FeatureCard(
                  title: 'Kuis Tata Surya',
                  description: 'Uji pengetahuanmu',
                  icon: Icons.quiz_outlined,
                  onTap: onQuizTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: AppSpacing.p16,
      child: SizedBox(
        height: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: AppRadius.roundedSmall,
                border: Border.all(color: AppColors.border, width: 1.0),
              ),
              child: Icon(
                icon,
                size: 20,
                color: AppColors.mutedLavender,
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            // Title
            Text(
              title,
              style: AppTypography.body.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.s4),
            // Short Description
            Text(
              description,
              style: AppTypography.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Arrow anchored bottom‑right
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
