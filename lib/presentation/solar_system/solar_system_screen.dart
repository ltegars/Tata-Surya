import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../data/planet_data.dart';
import '../../models/planet.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import '../planet/planet_detail_screen.dart';
import '../planet/widgets/planet_visual_placeholder.dart';

// ════════════════════════════════════════════════════════════════════
// Orbital configuration — visual-only, not scientific
// ════════════════════════════════════════════════════════════════════

/// Visual orbital data for each planet (separate from scientific Planet data).
class _OrbitConfig {
  /// Fractional radius: 0.0 = center, 1.0 = outermost orbit ring.
  final double radiusFraction;

  /// Angular speed multiplier — higher = faster. Inner planets faster.
  final double speedMultiplier;

  /// Dot radius for the planet circle.
  final double dotRadius;

  /// Starting angle (radians) so planets don't stack.
  final double startAngle;

  const _OrbitConfig({
    required this.radiusFraction,
    required this.speedMultiplier,
    required this.dotRadius,
    required this.startAngle,
  });
}

/// Per-planet orbit config keyed by planet index (0=Mercury..7=Neptune).
const List<_OrbitConfig> _orbitConfigs = [
  _OrbitConfig(radiusFraction: 0.14, speedMultiplier: 4.15, dotRadius: 3.5, startAngle: 0.0),
  _OrbitConfig(radiusFraction: 0.22, speedMultiplier: 3.10, dotRadius: 4.5, startAngle: 1.2),
  _OrbitConfig(radiusFraction: 0.30, speedMultiplier: 2.50, dotRadius: 5.0, startAngle: 2.8),
  _OrbitConfig(radiusFraction: 0.38, speedMultiplier: 2.00, dotRadius: 4.0, startAngle: 4.1),
  _OrbitConfig(radiusFraction: 0.52, speedMultiplier: 1.20, dotRadius: 8.0, startAngle: 0.8),
  _OrbitConfig(radiusFraction: 0.64, speedMultiplier: 0.90, dotRadius: 7.0, startAngle: 3.5),
  _OrbitConfig(radiusFraction: 0.78, speedMultiplier: 0.60, dotRadius: 5.5, startAngle: 5.3),
  _OrbitConfig(radiusFraction: 0.90, speedMultiplier: 0.45, dotRadius: 5.0, startAngle: 1.9),
];

// ════════════════════════════════════════════════════════════════════
// Solar System Screen
// ════════════════════════════════════════════════════════════════════

/// Solar System orbit visualization screen.
/// Uses Flutter's built-in AnimationController + CustomPainter.
/// PRD_DESIGN.md Section 20.
class SolarSystemScreen extends StatefulWidget {
  const SolarSystemScreen({super.key});

  @override
  State<SolarSystemScreen> createState() => _SolarSystemScreenState();
}

class _SolarSystemScreenState extends State<SolarSystemScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _isPlaying = true;
  double _speedMultiplier = 1.0;
  int? _selectedPlanetIndex;

  static const List<double> _speedOptions = [0.5, 1.0, 2.0];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  void _setSpeed(double speed) {
    setState(() {
      _speedMultiplier = speed;
    });
  }

  void _selectPlanet(int index) {
    setState(() {
      _selectedPlanetIndex = _selectedPlanetIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final planets = PlanetData.planets;
    final selectedPlanet =
        _selectedPlanetIndex != null ? planets[_selectedPlanetIndex!] : null;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Padding(
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
                    tooltip: 'Kembali',
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Text('Tata Surya', style: AppTypography.heading),
                ],
              ),
            ),

            // ── Orbit Visualization ──
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapDown: (details) =>
                        _handleTap(details, constraints, planets),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return CustomPaint(
                          size: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          painter: _SolarSystemPainter(
                            planets: planets,
                            animationValue: _controller.value,
                            speedMultiplier: _speedMultiplier,
                            selectedIndex: _selectedPlanetIndex,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            // ── Controls ──
            _ControlsBar(
              isPlaying: _isPlaying,
              currentSpeed: _speedMultiplier,
              speedOptions: _speedOptions,
              onTogglePlay: _togglePlayPause,
              onSpeedChanged: _setSpeed,
            ),

            // ── Selected Planet Info ──
            if (selectedPlanet != null)
              _PlanetInfoPanel(
                planet: selectedPlanet,
                onExplore: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          PlanetDetailScreen(planet: selectedPlanet),
                    ),
                  );
                },
                onDismiss: () => setState(() => _selectedPlanetIndex = null),
              ),

            if (selectedPlanet == null)
              const SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
  }

  /// Hit-test planets in the visualization.
  void _handleTap(
    TapDownDetails details,
    BoxConstraints constraints,
    List<Planet> planets,
  ) {
    final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    final maxRadius =
        math.min(constraints.maxWidth, constraints.maxHeight) / 2 - 16;

    for (int i = planets.length - 1; i >= 0; i--) {
      final config = _orbitConfigs[i];
      final orbitRadius = config.radiusFraction * maxRadius;
      final angle = config.startAngle +
          _controller.value *
              2 *
              math.pi *
              config.speedMultiplier *
              _speedMultiplier;
      final planetPos = Offset(
        center.dx + orbitRadius * math.cos(angle),
        center.dy + orbitRadius * math.sin(angle),
      );

      final tapRadius = config.dotRadius + 14; // generous touch target
      if ((details.localPosition - planetPos).distance <= tapRadius) {
        _selectPlanet(i);
        return;
      }
    }

    // Tap on empty space → deselect
    setState(() => _selectedPlanetIndex = null);
  }
}

// ════════════════════════════════════════════════════════════════════
// Custom Painter — orbits + Sun + planets
// ════════════════════════════════════════════════════════════════════

class _SolarSystemPainter extends CustomPainter {
  final List<Planet> planets;
  final double animationValue;
  final double speedMultiplier;
  final int? selectedIndex;

  _SolarSystemPainter({
    required this.planets,
    required this.animationValue,
    required this.speedMultiplier,
    this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2 - 16;

    // ── Sun ──
    _drawSun(canvas, center);

    // ── Orbits + Planets ──
    for (int i = 0; i < planets.length; i++) {
      final config = _orbitConfigs[i];
      final orbitRadius = config.radiusFraction * maxRadius;
      final color = planetAccentColor(planets[i].id);
      final isSelected = selectedIndex == i;

      // Orbit ring
      final orbitPaint = Paint()
        ..color = AppColors.border.withAlpha(isSelected ? 100 : 50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 1.5 : 0.8;
      canvas.drawCircle(center, orbitRadius, orbitPaint);

      // Planet position
      final angle = config.startAngle +
          animationValue *
              2 *
              math.pi *
              config.speedMultiplier *
              speedMultiplier;
      final planetPos = Offset(
        center.dx + orbitRadius * math.cos(angle),
        center.dy + orbitRadius * math.sin(angle),
      );

      // Glow behind selected planet
      if (isSelected) {
        final glowPaint = Paint()
          ..color = color.withAlpha(60)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawCircle(planetPos, config.dotRadius + 6, glowPaint);
      }

      // Planet dot — radial gradient for depth
      final planetPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: [
            color.withAlpha(240),
            color.withAlpha(170),
          ],
        ).createShader(Rect.fromCircle(
          center: planetPos,
          radius: config.dotRadius,
        ));
      canvas.drawCircle(planetPos, config.dotRadius, planetPaint);

      // Thin border ring
      final ringPaint = Paint()
        ..color = color.withAlpha(isSelected ? 180 : 80)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 1.5 : 0.6;
      canvas.drawCircle(planetPos, config.dotRadius, ringPaint);

      // Label for selected planet
      if (isSelected) {
        _drawLabel(canvas, planetPos, planets[i].name, config.dotRadius);
      }
    }
  }

  void _drawSun(Canvas canvas, Offset center) {
    // Outer glow
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD06B).withAlpha(35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, 22, glowPaint);

    // Mid glow
    final midGlow = Paint()
      ..color = const Color(0xFFFFD06B).withAlpha(60)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(center, 14, midGlow);

    // Sun core
    final sunPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.25, -0.25),
        radius: 1.0,
        colors: [
          Color(0xFFFFF4D9),
          Color(0xFFFFD06B),
          Color(0xFFEBA939),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: 11));
    canvas.drawCircle(center, 11, sunPaint);
  }

  void _drawLabel(
    Canvas canvas,
    Offset planetPos,
    String name,
    double dotRadius,
  ) {
    final textSpan = TextSpan(
      text: name,
      style: const TextStyle(
        color: AppColors.primaryText,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
    final painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final bgRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(
          planetPos.dx,
          planetPos.dy - dotRadius - 14,
        ),
        width: painter.width + 12,
        height: painter.height + 6,
      ),
      const Radius.circular(6),
    );

    canvas.drawRRect(
      bgRect,
      Paint()..color = AppColors.surfaceElevated.withAlpha(210),
    );
    canvas.drawRRect(
      bgRect,
      Paint()
        ..color = AppColors.border.withAlpha(120)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6,
    );

    painter.paint(
      canvas,
      Offset(
        bgRect.left + 6,
        bgRect.top + 3,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _SolarSystemPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.speedMultiplier != speedMultiplier ||
        oldDelegate.selectedIndex != selectedIndex;
  }
}

// ════════════════════════════════════════════════════════════════════
// Controls Bar
// ════════════════════════════════════════════════════════════════════

class _ControlsBar extends StatelessWidget {
  final bool isPlaying;
  final double currentSpeed;
  final List<double> speedOptions;
  final VoidCallback onTogglePlay;
  final ValueChanged<double> onSpeedChanged;

  const _ControlsBar({
    required this.isPlaying,
    required this.currentSpeed,
    required this.speedOptions,
    required this.onTogglePlay,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedMedium,
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Row(
        children: [
          // Play / Pause
          GestureDetector(
            onTap: onTogglePlay,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.mutedLavender.withAlpha(25),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.mutedLavender.withAlpha(80),
                  width: 1.0,
                ),
              ),
              child: Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 22,
                color: AppColors.mutedLavender,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.s16),

          // Speed label
          Text(
            'Kecepatan',
            style: AppTypography.caption.copyWith(fontSize: 12),
          ),

          const SizedBox(width: AppSpacing.s12),

          // Speed chips
          ...speedOptions.map((speed) {
            final isActive = speed == currentSpeed;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.s8),
              child: GestureDetector(
                onTap: () => onSpeedChanged(speed),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.mutedLavender.withAlpha(30)
                        : AppColors.surfaceElevated,
                    borderRadius: AppRadius.roundedSmall,
                    border: Border.all(
                      color: isActive
                          ? AppColors.mutedLavender.withAlpha(120)
                          : AppColors.border,
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    '${speed == speed.roundToDouble() ? speed.toInt() : speed}×',
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: isActive
                          ? AppColors.mutedLavender
                          : AppColors.secondaryText,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// Planet Info Panel (shown on selection)
// ════════════════════════════════════════════════════════════════════

class _PlanetInfoPanel extends StatelessWidget {
  final Planet planet;
  final VoidCallback onExplore;
  final VoidCallback onDismiss;

  const _PlanetInfoPanel({
    required this.planet,
    required this.onExplore,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = planetAccentColor(planet.id);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        0,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedCard,
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: accentColor.withAlpha(15),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with planet color dot, name, and close
          Row(
            children: [
              // Color dot
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planet.name,
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Planet ke-${planet.orderFromSun} dari Matahari',
                      style: AppTypography.caption.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onDismiss,
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s8),

          // Short description (first sentence)
          Text(
            _firstSentence(planet.description),
            style: AppTypography.bodySecondary.copyWith(
              fontSize: 13,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: AppSpacing.s12),

          // Explore button
          SizedBox(
            height: 38,
            child: AppButton(
              text: 'Jelajahi ${planet.name} →',
              onPressed: onExplore,
              height: 38,
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the first sentence of a description for the compact panel.
  String _firstSentence(String text) {
    final dotIndex = text.indexOf('. ');
    if (dotIndex == -1) return text;
    return text.substring(0, dotIndex + 1);
  }
}
