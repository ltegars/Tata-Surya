import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Icon Button as defined in PRD_DESIGN.md Section 23
/// Uses elevated surface with clear icon and minimum 44dp tap target for accessibility
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 44.0,
    this.iconSize = 20.0,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.surfaceElevated;
    final effectiveIconColor = iconColor ?? AppColors.primaryText;

    Widget button = Material(
      color: effectiveBg,
      borderRadius: AppRadius.roundedSmall,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.roundedSmall,
        splashColor: AppColors.mutedLavender.withValues(alpha: 0.12),
        highlightColor: AppColors.mutedLavender.withValues(alpha: 0.06),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: AppRadius.roundedSmall,
            border: Border.all(color: AppColors.border, width: 1.0),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            size: iconSize,
            color: effectiveIconColor,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
