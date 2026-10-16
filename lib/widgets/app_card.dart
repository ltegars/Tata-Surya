import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Standard Card Component
/// Defined in PRD_DESIGN.md Section 8:
/// Background: #171F33, Border: #30394F, Radius: 20px, Subtle low-contrast shadow
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool isElevated;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppRadius.card,
    this.isElevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ??
        (isElevated ? AppColors.surfaceElevated : AppColors.surface);
    final effectiveBorderColor = borderColor ?? AppColors.border;
    final radius = BorderRadius.circular(borderRadius);

    final cardContent = Container(
      padding: padding ?? AppSpacing.p20,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: radius,
        border: Border.all(color: effectiveBorderColor, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: AppColors.mutedLavender.withValues(alpha: 0.12),
          highlightColor: AppColors.mutedLavender.withValues(alpha: 0.06),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
