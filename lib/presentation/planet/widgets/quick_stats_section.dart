import 'package:flutter/material.dart';
import '../../../models/planet.dart';
import '../../../theme/theme.dart';

/// Quick Stats Section
/// Displays Diameter, Distance from Sun, Temperature, and Moons
/// from the Planet model in a clean 2×2 grid layout.
class QuickStatsSection extends StatelessWidget {
  final Planet planet;

  const QuickStatsSection({
    super.key,
    required this.planet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik Cepat',
          style: AppTypography.section.copyWith(fontSize: 16),
        ),
        const SizedBox(height: AppSpacing.s12),
        // 2×2 stat grid — IntrinsicHeight ensures both cards in a row
        // always match the height of the taller card, for every planet.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Diameter',
                  value: planet.diameter,
                  icon: Icons.radio_button_unchecked_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _StatItem(
                  label: 'Jarak ke Matahari',
                  value: planet.distanceFromSun,
                  icon: Icons.wb_sunny_outlined,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Suhu Rata-rata',
                  value: planet.temperature,
                  icon: Icons.thermostat_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: _StatItem(
                  label: 'Jumlah Bulan',
                  value: planet.moons.toString(),
                  icon: Icons.brightness_3_outlined,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.roundedMedium,
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize.max so the Column fills the stretched Container height
        // (set by IntrinsicHeight in the parent Row)
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: AppColors.mutedLavender,
              ),
              const SizedBox(width: AppSpacing.s4),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            value,
            style: AppTypography.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
