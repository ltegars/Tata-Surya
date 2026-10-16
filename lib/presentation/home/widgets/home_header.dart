import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widgets/widgets.dart';

/// Home Header
/// Content: App Logo, App Name, Settings Button
/// Strictly follows PRD_DESIGN.md Section 12.1:
/// - No profile/avatar
/// - No daily missions
/// - No streak
/// - No badges
class HomeHeader extends StatelessWidget {
  final VoidCallback? onSettingsTap;

  const HomeHeader({
    super.key,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          // Logo & Title
          const AppLogo(size: 32),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              'Jelajah Tata Surya',
              style: AppTypography.heading.copyWith(fontSize: 20),
            ),
          ),
          // Settings button
          AppIconButton(
            icon: Icons.tune_rounded,
            tooltip: 'Pengaturan',
            onPressed: onSettingsTap ?? () => _showSettingsDialog(context),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.roundedCard,
            side: const BorderSide(color: AppColors.border, width: 1.0),
          ),
          title: Text('Pengaturan', style: AppTypography.section),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jelajah Tata Surya',
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                'Aplikasi Edukasi Tata Surya untuk Siswa SMP.\nVersi 1.0.0',
                style: AppTypography.bodySecondary,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Tutup',
                style: AppTypography.buttonLabel.copyWith(
                  color: AppColors.mutedLavender,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
