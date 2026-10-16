import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../models/planet.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import 'planet_3d_screen.dart';
import 'widgets/planet_visual_placeholder.dart';

/// AR Planet Explorer Screen
/// Displays an interactive Augmented Reality experience for the given [Planet].
/// Uses model_viewer_plus Scene Viewer on Android, with a clean educational fallback
/// to the 3D Explorer on platforms or devices where AR is unavailable (e.g. Chrome desktop).
/// Defined in PRD_SYSTEM.md Section 5.7 & PRD_DESIGN.md Section 21.
class PlanetArScreen extends StatefulWidget {
  final Planet planet;

  /// Optional override for AR platform support (useful for testing fallback states).
  final bool? isArSupported;

  /// Optional custom viewer builder for testing environments where WebViewPlatform is unavailable.
  final Widget Function(BuildContext context, Planet planet)? viewerBuilder;

  /// Global debug override to simulate platform AR support in tests without altering system platform.
  static bool? debugArSupportedOverride;

  const PlanetArScreen({
    super.key,
    required this.planet,
    this.isArSupported,
    this.viewerBuilder,
  });

  @override
  State<PlanetArScreen> createState() => _PlanetArScreenState();
}

class _PlanetArScreenState extends State<PlanetArScreen> {
  bool _assetExists = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAssetExists();
  }

  /// Check whether the planet's 3D model asset exists in the bundle.
  Future<void> _checkAssetExists() async {
    try {
      await rootBundle.load(widget.planet.model3dAsset);
      if (mounted) {
        setState(() {
          _assetExists = true;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _assetExists = false;
          _isLoading = false;
        });
      }
    }
  }

  bool get _effectiveArSupported {
    if (widget.isArSupported != null) {
      return widget.isArSupported!;
    }
    if (PlanetArScreen.debugArSupportedOverride != null) {
      return PlanetArScreen.debugArSupportedOverride!;
    }
    // AR Scene Viewer is specifically targeted for Android devices
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    final planet = widget.planet;
    final accentColor = planetAccentColor(planet.id);

    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──
            _TopBar(
              planetName: planet.name,
              isArMode: _effectiveArSupported,
            ),

            // ── Main Content ──
            Expanded(
              child: _isLoading
                  ? _LoadingState(accentColor: accentColor)
                  : !_assetExists
                      ? _ModelMissingFallback(
                          planet: planet,
                          accentColor: accentColor,
                        )
                      : !_effectiveArSupported
                          ? _PlatformFallbackState(
                              planet: planet,
                              accentColor: accentColor,
                            )
                          : _ArViewerContent(
                              planet: planet,
                              accentColor: accentColor,
                              viewerBuilder: widget.viewerBuilder,
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────── Top Bar ──────────────────────────

class _TopBar extends StatelessWidget {
  final String planetName;
  final bool isArMode;

  const _TopBar({
    required this.planetName,
    required this.isArMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      child: Row(
        children: [
          AppIconButton(
            icon: Icons.arrow_back_rounded,
            onPressed: () => Navigator.pop(context),
            tooltip: 'Kembali ke Detail Planet',
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    planetName,
                    style: AppTypography.heading.copyWith(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s8,
                    vertical: AppSpacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.roundedSmall,
                    border: Border.all(color: AppColors.border, width: 1.0),
                  ),
                  child: Text(
                    'AR Explorer',
                    style: AppTypography.caption.copyWith(
                      fontSize: 11,
                      color: AppColors.mutedLavender,
                      fontWeight: FontWeight.w600,
                    ),
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

// ────────────────────────── Loading State ──────────────────────────

class _LoadingState extends StatelessWidget {
  final Color accentColor;

  const _LoadingState({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            'Menyiapkan model AR...',
            style: AppTypography.bodySecondary.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────── AR Viewer Content ──────────────────────────

class _ArViewerContent extends StatelessWidget {
  final Planet planet;
  final Color accentColor;
  final Widget Function(BuildContext context, Planet planet)? viewerBuilder;

  const _ArViewerContent({
    required this.planet,
    required this.accentColor,
    this.viewerBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // AR / 3D Viewer Container
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.roundedCard,
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: viewerBuilder != null
                ? viewerBuilder!(context, planet)
                : ModelViewer(
                    src: planet.model3dAsset,
                    alt: 'Model AR ${planet.name}',
                    ar: true,
                    arModes: const ['scene-viewer', 'webxr'],
                    arScale: ArScale.auto,
                    arPlacement: ArPlacement.floor,
                    autoPlay: true,
                    autoRotate: true,
                    autoRotateDelay: 0,
                    cameraControls: true,
                    disableZoom: false,
                    backgroundColor: AppColors.surface,
                    disableTap: false,
                    disablePan: false,
                  ),
          ),
        ),

        const SizedBox(height: AppSpacing.s16),

        // ── Short Instruction + Action Area ──
        _ArBottomSection(
          planet: planet,
          accentColor: accentColor,
        ),

        const SizedBox(height: AppSpacing.s20),
      ],
    );
  }
}

// ────────────────────────── AR Bottom Section ──────────────────────────

class _ArBottomSection extends StatelessWidget {
  final Planet planet;
  final Color accentColor;

  const _ArBottomSection({
    required this.planet,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        children: [
          // Primary educational headline
          Text(
            'Jelajahi ${planet.name} di dunia nyata',
            style: AppTypography.section.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            'Tempatkan planet pada permukaan datar.',
            style: AppTypography.bodySecondary.copyWith(
              fontSize: 13,
              color: AppColors.primaryText.withValues(alpha: 0.82),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.s12),

          // Instruction chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ArInstructionChip(
                icon: Icons.layers_outlined,
                label: 'Permukaan Datar',
              ),
              const SizedBox(width: AppSpacing.s12),
              _ArInstructionChip(
                icon: Icons.pinch_outlined,
                label: 'Putar & Zoom',
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s16),

          // Secondary option to switch to 3D mode if preferred or if AR fails
          AppButton.secondary(
            text: 'Buka Mode 3D',
            leadingIcon: const Icon(
              Icons.view_in_ar_outlined,
              size: 16,
              color: AppColors.primaryText,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => Planet3dScreen(planet: planet),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ArInstructionChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ArInstructionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedSmall,
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.mutedLavender,
          ),
          const SizedBox(width: AppSpacing.s8),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 12,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────── Platform Fallback State ──────────────────────────
// Shown on platforms where Scene Viewer AR is unavailable (e.g. Chrome desktop, iOS, etc.)

class _PlatformFallbackState extends StatelessWidget {
  final Planet planet;
  final Color accentColor;

  const _PlatformFallbackState({
    required this.planet,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Planet visual placeholder
              PlanetVisualPlaceholder(
                planetId: planet.id,
                planetName: planet.name,
                accentColor: accentColor,
                size: 150,
              ),

              const SizedBox(height: AppSpacing.s24),

              // Fallback Title
              Text(
                'AR tidak tersedia di perangkat ini.',
                style: AppTypography.section.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.s8),

              // Suggested fallback guidance
              Text(
                'Gunakan mode 3D untuk tetap menjelajahi planet.',
                style: AppTypography.body.copyWith(
                  fontSize: 14,
                  color: AppColors.mutedLavender,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.s12),

              // Educational explanation
              Text(
                'Fitur Augmented Reality memerlukan perangkat Android dengan dukungan Scene Viewer / ARCore untuk mendeteksi permukaan nyata.\n'
                'Kamu tetap dapat memutar dan memperbesar model 3D ${planet.name} secara interaktif di layar.',
                style: AppTypography.bodySecondary.copyWith(
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.s24),

              // Primary 3D fallback button
              AppButton(
                text: 'Jelajahi 3D',
                leadingIcon: const Icon(
                  Icons.view_in_ar_outlined,
                  size: 18,
                  color: AppColors.deepSpace,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => Planet3dScreen(planet: planet),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.s12),

              // Secondary return button
              AppButton.secondary(
                text: 'Kembali ke Detail Planet',
                leadingIcon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                  color: AppColors.primaryText,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ────────────────────────── Missing Model Fallback State ──────────────────────────

class _ModelMissingFallback extends StatelessWidget {
  final Planet planet;
  final Color accentColor;

  const _ModelMissingFallback({
    required this.planet,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlanetVisualPlaceholder(
              planetId: planet.id,
              planetName: planet.name,
              accentColor: accentColor,
              size: 140,
            ),
            const SizedBox(height: AppSpacing.s32),
            Text(
              'Model 3D belum tersedia',
              style: AppTypography.section.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s12),
            Text(
              'Model 3D untuk ${planet.name} sedang disiapkan.\n'
              'Silakan kembali lagi nanti.',
              style: AppTypography.bodySecondary.copyWith(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s32),
            AppButton.secondary(
              text: 'Kembali ke Detail Planet',
              onPressed: () => Navigator.pop(context),
              isFullWidth: false,
              leadingIcon: const Icon(
                Icons.arrow_back_rounded,
                size: 18,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
