import 'package:flutter/material.dart';
import '../../models/planet.dart';
import '../../services/audio_player_service.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import 'planet_3d_screen.dart';
import 'planet_ar_screen.dart';
import 'widgets/audio_player_section.dart';
import 'widgets/fun_fact_card.dart';
import 'widgets/planet_visual_placeholder.dart';
import 'widgets/quick_stats_section.dart';

/// Planet Detail Screen
/// Displays all fields of the passed [Planet] object.
/// Uses a single planet instance — no hardcoded per-planet screens.
/// Defined in PRD_DESIGN.md Section 18.
class PlanetDetailScreen extends StatefulWidget {
  final Planet planet;

  const PlanetDetailScreen({super.key, required this.planet});

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen> {
  late final AudioPlayerService _audioService;

  @override
  void initState() {
    super.initState();
    _audioService = AudioPlayerService();
    // Load the planet's audio asset — service marks unavailable if file is missing
    _audioService.loadAsset(widget.planet.audioAsset);
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planet = widget.planet;
    final accentColor = planetAccentColor(planet.id);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ──
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s16,
                  0,
                ),
                child: AppIconButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Kembali ke Daftar Planet',
                ),
              ),

              // ── Planet Hero Visual ──
              _PlanetHero(
                planet: planet,
                accentColor: accentColor,
              ),

              // ── Planet Name + Type ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planet.name,
                      style: AppTypography.heading.copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    Text(
                      planet.type,
                      style: AppTypography.bodySecondary.copyWith(
                        fontSize: 13,
                        color: accentColor.withValues(alpha: 0.90),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.s24),

              // ── Quick Stats ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s20,
                ),
                child: QuickStatsSection(planet: planet),
              ),

              const SizedBox(height: AppSpacing.s24),

              // ── Divider ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: Divider(color: AppColors.border, height: 1),
              ),

              const SizedBox(height: AppSpacing.s24),

              // ── Description ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tentang ${planet.name}',
                      style: AppTypography.section.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: AppSpacing.s12),
                    Text(
                      planet.description,
                      style: AppTypography.body.copyWith(
                        fontSize: 15,
                        height: 1.65,
                        color: AppColors.primaryText.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.s20),

              // ── Fun Fact ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s20,
                ),
                child: FunFactCard(funFact: planet.funFact),
              ),

              const SizedBox(height: AppSpacing.s24),

              // ── Divider ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.s20),
                child: Divider(color: AppColors.border, height: 1),
              ),

              const SizedBox(height: AppSpacing.s24),

              // ── Audio Player ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s20,
                ),
                child: AudioPlayerSection(audioService: _audioService),
              ),

              const SizedBox(height: AppSpacing.s24),

              // ── Future Feature Placeholders ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s20,
                ),
                child: _FutureFeaturesSection(planet: planet),
              ),

              const SizedBox(height: AppSpacing.s48),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────── Hero ──────────────────────────

class _PlanetHero extends StatelessWidget {
  final Planet planet;
  final Color accentColor;

  const _PlanetHero({required this.planet, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.75,
          colors: [
            accentColor.withValues(alpha: 0.12),
            AppColors.deepSpace,
          ],
        ),
      ),
      child: Center(
        child: PlanetVisualPlaceholder(
          planetId: planet.id,
          planetName: planet.name,
          accentColor: accentColor,
          size: 170,
        ),
      ),
    );
  }
}

// ────────────────────────── Explore Further ──────────────────────────

class _FutureFeaturesSection extends StatelessWidget {
  final Planet planet;

  const _FutureFeaturesSection({required this.planet});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jelajahi Lebih Jauh',
          style: AppTypography.section.copyWith(fontSize: 16),
        ),
        const SizedBox(height: AppSpacing.s12),

        // 3D Explorer — functional (Phase 4B)
        _FeatureButton(
          label: 'Jelajahi 3D',
          icon: Icons.view_in_ar_outlined,
          description: 'Putar dan perbesar model 3D',
          isActive: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => Planet3dScreen(planet: planet),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.s12),

        // AR Explorer — functional (Phase 4C)
        _FeatureButton(
          label: 'Buka AR',
          icon: Icons.camera_alt_outlined,
          description: 'Lihat planet di sekitarmu',
          isActive: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => PlanetArScreen(planet: planet),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// A feature action button that can be active (tappable) or inactive (coming soon).
class _FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String description;
  final bool isActive;
  final VoidCallback? onTap;

  const _FeatureButton({
    required this.label,
    required this.icon,
    required this.description,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor =
        isActive ? AppColors.mutedLavender : AppColors.secondaryText;
    final effectiveLabelColor =
        isActive ? AppColors.primaryText : AppColors.secondaryText;

    return AppCard(
      onTap: isActive ? onTap : null,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s14,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.mutedLavender.withValues(alpha: 0.12)
                  : AppColors.surface,
              borderRadius: AppRadius.roundedSmall,
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            child: Icon(
              icon,
              size: 18,
              color: effectiveIconColor,
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.body.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: effectiveLabelColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  description,
                  style: AppTypography.caption.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          if (isActive)
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.secondaryText,
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s8,
                vertical: AppSpacing.s4,
              ),
              decoration: BoxDecoration(
                color: AppColors.deepSpace,
                borderRadius: AppRadius.roundedSmall,
                border: Border.all(color: AppColors.border, width: 1.0),
              ),
              child: Text(
                'Segera',
                style: AppTypography.caption.copyWith(
                  fontSize: 11,
                  color: AppColors.secondaryText,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

