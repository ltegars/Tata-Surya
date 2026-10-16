import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

/// Planet Visual Widget
/// Displays the planet's 2D image asset if available (Phase 5D).
/// Falls back to the gradient sphere placeholder if the image is not bundled
/// (e.g., Uranus and Neptune pending final assets).
///
/// Usage is drop-in identical to the old PlanetVisualPlaceholder.
class PlanetVisualPlaceholder extends StatelessWidget {
  final String planetId;
  final String planetName;
  final Color accentColor;
  final double size;

  const PlanetVisualPlaceholder({
    super.key,
    required this.planetId,
    required this.planetName,
    required this.accentColor,
    this.size = 120.0,
  });

  /// Returns the asset path for planets that have a final 2D PNG.
  /// Returns null for planets whose PNG is not yet available.
  String? get _imageAsset {
    const available = {
      'mercury': 'assets/images/planets/mercury.png',
      'venus': 'assets/images/planets/venus.png',
      'earth': 'assets/images/planets/earth.png',
      'mars': 'assets/images/planets/mars.png',
      'jupiter': 'assets/images/planets/jupiter.png',
      'saturn': 'assets/images/planets/saturn.png',
      // 'uranus' and 'neptune' pending Phase 5D completion
    };
    return available[planetId];
  }

  @override
  Widget build(BuildContext context) {
    final asset = _imageAsset;

    if (asset != null) {
      // ── Final 2D PNG asset ──────────────────────────────────────
      return SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          asset,
          width: size,
          height: size,
          fit: BoxFit.contain,
          // Fallback to gradient sphere if image fails to load
          errorBuilder: (context, error, stackTrace) =>
              _GradientSphere(accentColor: accentColor, size: size),
        ),
      );
    }

    // ── Gradient sphere fallback (no PNG yet) ───────────────────
    return _GradientSphere(accentColor: accentColor, size: size);
  }
}

// ---------------------------------------------------------------------------
// Gradient sphere fallback (unchanged from Phase 3 placeholder)
// ---------------------------------------------------------------------------

class _GradientSphere extends StatelessWidget {
  final Color accentColor;
  final double size;

  const _GradientSphere({required this.accentColor, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer subtle glow ring
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accentColor.withValues(alpha: 0.18),
                  accentColor.withValues(alpha: 0.0),
                ],
                stops: const [0.55, 1.0],
              ),
            ),
          ),

          // Planet sphere
          Container(
            width: size * 0.72,
            height: size * 0.72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.3),
                radius: 0.85,
                colors: [
                  accentColor.withValues(alpha: 0.85),
                  accentColor.withValues(alpha: 0.55),
                  accentColor.withValues(alpha: 0.30),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.35),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Subtle surface highlight (top-left)
          Positioned(
            top: size * 0.14,
            left: size * 0.18,
            child: Container(
              width: size * 0.18,
              height: size * 0.1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Returns the planet's natural reference color from AppColors by planet ID.
Color planetAccentColor(String planetId) {
  switch (planetId) {
    case 'mercury':
      return AppColors.planetMercury;
    case 'venus':
      return AppColors.planetVenus;
    case 'earth':
      return AppColors.planetEarth;
    case 'mars':
      return AppColors.planetMars;
    case 'jupiter':
      return AppColors.planetJupiter;
    case 'saturn':
      return AppColors.planetSaturn;
    case 'uranus':
      return AppColors.planetUranus;
    case 'neptune':
      return AppColors.planetNeptune;
    default:
      return AppColors.mutedLavender;
  }
}
