import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

/// Fun Fact Card
/// Displays a planet's funFact in a visually distinct but subtle info panel.
/// Not gamified — clean, informational.
class FunFactCard extends StatelessWidget {
  final String funFact;

  const FunFactCard({
    super.key,
    required this.funFact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.roundedCard,
        border: Border.all(
          color: AppColors.mutedLavender.withValues(alpha: 0.30),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon indicator
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.mutedLavender.withValues(alpha: 0.12),
              borderRadius: AppRadius.roundedSmall,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 16,
              color: AppColors.mutedLavender,
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tahukah Kamu?',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.mutedLavender,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  funFact,
                  style: AppTypography.bodySecondary.copyWith(
                    fontSize: 14,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
