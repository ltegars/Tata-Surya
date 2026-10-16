import 'package:flutter/material.dart';
import '../../../data/fact_data.dart';
import '../../../models/fact.dart';
import '../../../theme/theme.dart';
import '../../../widgets/widgets.dart';
import '../../planet/widgets/planet_visual_placeholder.dart';

/// "Tahukah Kamu?" Section
/// Defined in PRD_DESIGN.md Section 15:
/// - Horizontal card
/// - Complete fact without truncation
/// - Small stylized Jupiter visual placeholder
/// - "Pelajari lebih lanjut →" action
class TahukahKamuCard extends StatelessWidget {
  final Fact? fact;
  final VoidCallback? onLearnMore;

  const TahukahKamuCard({
    super.key,
    this.fact,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    final currentFact = fact ?? FactData.featuredFact;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tahukah Kamu?',
            style: AppTypography.section,
          ),
          const SizedBox(height: AppSpacing.s12),
          AppCard(
            onTap: onLearnMore,
            padding: AppSpacing.p20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Planet visual corresponding to the fact
                PlanetVisualPlaceholder(
                  planetId: currentFact.planetId,
                  planetName: currentFact.planetName,
                  accentColor: planetAccentColor(currentFact.planetId),
                  size: 44,
                ),

                const SizedBox(width: AppSpacing.s16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentFact.fact,
                        style: AppTypography.body.copyWith(
                          fontSize: 15,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s12),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pelajari lebih lanjut',
                            style: AppTypography.buttonLabel.copyWith(
                              color: AppColors.mutedLavender,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: AppColors.mutedLavender,
                          ),
                        ],
                      ),
                    ],
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
