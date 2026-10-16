import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../models/planet.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import 'widgets/planet_visual_placeholder.dart';

/// 3D Planet Explorer Screen
/// Displays an interactive 3D model of the given [Planet].
/// Uses model_viewer_plus to render .glb files with rotate/zoom gestures.
/// Defined in PRD_SYSTEM.md Section 5.5 & PRD_DESIGN.md Section 19.
class Planet3dScreen extends StatefulWidget {
  final Planet planet;

  const Planet3dScreen({super.key, required this.planet});

  @override
  State<Planet3dScreen> createState() => _Planet3dScreenState();
}

class _Planet3dScreenState extends State<Planet3dScreen> {
  bool _assetExists = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAssetExists();
  }

  /// Check whether the planet's 3D model asset is actually bundled.
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
            _TopBar(planetName: planet.name),

            // ── Main Content ──
            Expanded(
              child: _isLoading
                  ? _LoadingState(accentColor: accentColor)
                  : _assetExists
                      ? _ModelViewerContent(
                          planet: planet,
                          accentColor: accentColor,
                        )
                      : _FallbackState(
                          planet: planet,
                          accentColor: accentColor,
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

  const _TopBar({required this.planetName});

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
            child: Text(
              planetName,
              style: AppTypography.heading.copyWith(fontSize: 20),
              overflow: TextOverflow.ellipsis,
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
            'Memuat model 3D...',
            style: AppTypography.bodySecondary.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────── 3D Model Viewer ──────────────────────────

class _ModelViewerContent extends StatelessWidget {
  final Planet planet;
  final Color accentColor;

  const _ModelViewerContent({
    required this.planet,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 3D Viewer area
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.roundedCard,
              border: Border.all(color: AppColors.border, width: 1.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: ModelViewer(
              src: planet.model3dAsset,
              alt: 'Model 3D ${planet.name}',
              autoPlay: true,
              autoRotate: true,
              autoRotateDelay: 0,
              cameraControls: true,
              disableZoom: false,
              backgroundColor: AppColors.surface,
              // Minimal UI — let planet be the focus
              disableTap: false,
              disablePan: true,
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.s20),

        // ── Instruction + Controls ──
        _BottomControls(accentColor: accentColor),

        const SizedBox(height: AppSpacing.s24),
      ],
    );
  }
}

// ────────────────────────── Bottom Controls ──────────────────────────

class _BottomControls extends StatelessWidget {
  final Color accentColor;

  const _BottomControls({required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
      child: Column(
        children: [
          // Instruction hints
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _InstructionChip(
                icon: Icons.touch_app_outlined,
                label: 'Drag untuk memutar',
              ),
              const SizedBox(width: AppSpacing.s16),
              _InstructionChip(
                icon: Icons.pinch_outlined,
                label: 'Pinch untuk zoom',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InstructionChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InstructionChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: AppColors.secondaryText,
        ),
        const SizedBox(width: AppSpacing.s4),
        Text(
          label,
          style: AppTypography.caption.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}

// ────────────────────────── Fallback State ──────────────────────────

class _FallbackState extends StatelessWidget {
  final Planet planet;
  final Color accentColor;

  const _FallbackState({
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
            // Planet visual placeholder as stand-in
            PlanetVisualPlaceholder(
              planetId: planet.id,
              planetName: planet.name,
              accentColor: accentColor,
              size: 140,
            ),

            const SizedBox(height: AppSpacing.s32),

            // Informational message
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

            // Return button
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
