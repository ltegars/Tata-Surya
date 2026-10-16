import 'package:flutter/material.dart';
import '../theme/theme.dart';

enum AppButtonVariant { primary, secondary }

/// Button Component as defined in PRD_DESIGN.md Section 23
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isFullWidth;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isFullWidth = true,
    this.width,
    this.height = 48.0,
  });

  const AppButton.secondary({
    super.key,
    required this.text,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isFullWidth = true,
    this.width,
    this.height = 48.0,
  }) : variant = AppButtonVariant.secondary;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;

    final backgroundColor = isPrimary
        ? AppColors.mutedLavender
        : AppColors.surfaceElevated;
    final foregroundColor = isPrimary
        ? AppColors.primaryButtonText
        : AppColors.primaryText;
    final borderColor = isPrimary ? Colors.transparent : AppColors.border;

    final content = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          const SizedBox(width: AppSpacing.s8),
        ],
        Text(
          text,
          style: AppTypography.buttonLabel.copyWith(color: foregroundColor),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.s8),
          trailingIcon!,
        ],
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: AppRadius.roundedButton,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.roundedButton,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: AppRadius.roundedButton,
              border: Border.all(color: borderColor, width: 1.0),
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
