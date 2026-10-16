import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Clean Solar System Vector Icon/Logo for "Jelajah Tata Surya"
/// Outline style, consistent with Soft Space UI, no emoji
class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({
    super.key,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AppLogoPainter(),
      ),
    );
  }
}

class _AppLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final sunRadius = size.width * 0.18;
    final orbitRadius = size.width * 0.42;

    // Center Sun
    final sunPaint = Paint()
      ..color = AppColors.mutedLavender
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, sunRadius, sunPaint);

    // Orbit Path
    final orbitPaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, orbitRadius, orbitPaint);

    // Orbiting Planet Dot
    final planetPaint = Paint()
      ..color = AppColors.paleLavender
      ..style = PaintingStyle.fill;
    final planetOffset = Offset(
      center.dx + orbitRadius * 0.866, // cos(30 deg)
      center.dy - orbitRadius * 0.5,   // -sin(30 deg)
    );
    canvas.drawCircle(planetOffset, sunRadius * 0.55, planetPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
