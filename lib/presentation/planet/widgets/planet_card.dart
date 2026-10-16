import 'package:flutter/material.dart';
import '../../../models/planet.dart';
import '../../../theme/theme.dart';
import '../../../widgets/widgets.dart';
import 'planet_visual_placeholder.dart';

/// Planet Card for the 2-column Planet Explorer grid.
/// Consistent: fixed height, identical padding, image area, layout.
class PlanetCard extends StatelessWidget {
  final Planet planet;
  final VoidCallback onTap;
  final IconData actionIcon;

  const PlanetCard({
    super.key,
    required this.planet,
    required this.onTap,
    this.actionIcon = Icons.arrow_forward_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = planetAccentColor(planet.id);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: SizedBox(
        // Fixed height ensures every card in the grid is identical
        height: 190,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Planet visual area (fixed height) ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.card),
                topRight: Radius.circular(AppRadius.card),
              ),
              child: Container(
                height: 100,
                width: double.infinity,
                color: AppColors.deepSpace,
                child: Center(
                  child: PlanetVisualPlaceholder(
                    planetId: planet.id,
                    planetName: planet.name,
                    accentColor: accentColor,
                    size: 80,
                  ),
                ),
              ),
            ),

            // ── Text area (fixed padding, fixed structure) ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s12,
                  AppSpacing.s8,
                  AppSpacing.s12,
                  AppSpacing.s8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Planet name
                    Text(
                      planet.name,
                      style: AppTypography.body.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    // Planet type
                    Text(
                      _shortType(planet.type),
                      style: AppTypography.caption.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Arrow action indicator anchored bottom-right
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        actionIcon,
                        size: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shorten verbose type strings so they fit on small cards.
  String _shortType(String type) {
    // e.g. "Planet Kebumian (Terestrial)" → "Terestrial"
    //      "Gas Raksasa (Gas Giant)"       → "Gas Giant"
    //      "Es Raksasa (Ice Giant)"        → "Ice Giant"
    final match = RegExp(r'\(([^)]+)\)').firstMatch(type);
    return match != null ? match.group(1)! : type;
  }
}
