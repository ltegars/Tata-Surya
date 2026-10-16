import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';

/// Clean Placeholder Screen for Planet, AR, and Quiz tabs during Phase 2
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final VoidCallback? onReturnHome;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    this.onReturnHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.p24,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon circle with elevated surface
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.0),
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: AppColors.mutedLavender,
                  ),
                ),
                const SizedBox(height: AppSpacing.s24),
                Text(
                  subtitle,
                  style: AppTypography.heading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.s12),
                Text(
                  description,
                  style: AppTypography.bodySecondary,
                  textAlign: TextAlign.center,
                ),
                if (onReturnHome != null) ...[
                  const SizedBox(height: AppSpacing.s32),
                  AppButton.secondary(
                    text: 'Kembali ke Beranda',
                    isFullWidth: false,
                    onPressed: onReturnHome,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
