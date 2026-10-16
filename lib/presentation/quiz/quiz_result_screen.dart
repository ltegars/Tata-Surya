import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import '../main_navigation_shell.dart';
import 'quiz_screen.dart';

/// Quiz Result Screen — Phase 5A
/// Menampilkan skor akhir setelah 10 soal selesai.
class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback? onRetry;
  final VoidCallback? onReturnHome;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    this.onRetry,
    this.onReturnHome,
  });

  String _getMessage() {
    final ratio = score / total;
    if (ratio == 1.0) {
      return 'Luar biasa! Kamu menjawab semua soal dengan benar.';
    } else if (ratio >= 0.8) {
      return 'Bagus sekali! Pengetahuanmu tentang Tata Surya sudah sangat baik.';
    } else if (ratio >= 0.6) {
      return 'Cukup baik! Terus pelajari lebih banyak tentang Tata Surya.';
    } else if (ratio >= 0.4) {
      return 'Terus semangat! Masih banyak fakta menarik yang bisa kamu pelajari.';
    } else {
      return 'Jangan menyerah! Pelajari kembali materi Tata Surya dan coba lagi.';
    }
  }

  void _retryQuiz(BuildContext context) {
    if (onRetry != null) {
      onRetry!();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizScreen(onExitToHome: onReturnHome),
        ),
      );
    }
  }

  void _returnHome(BuildContext context) {
    if (onReturnHome != null) {
      onReturnHome!();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepSpace,
      appBar: AppBar(
        backgroundColor: AppColors.deepSpace,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Kuis Selesai',
          style: AppTypography.section,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Score card
              _ScoreCard(score: score, total: total),
              const SizedBox(height: AppSpacing.s24),

              // Message card
              AppCard(
                isElevated: true,
                padding: AppSpacing.p20,
                child: Text(
                  _getMessage(),
                  style: AppTypography.body.copyWith(
                    color: AppColors.primaryText.withValues(alpha: 0.9),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.s32),

              // Coba Lagi
              AppButton(
                text: 'Coba Lagi',
                onPressed: () => _retryQuiz(context),
                leadingIcon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: AppColors.primaryButtonText,
                ),
              ),
              const SizedBox(height: AppSpacing.s12),

              // Kembali ke Beranda
              AppButton.secondary(
                text: 'Kembali ke Beranda',
                onPressed: () => _returnHome(context),
                leadingIcon: const Icon(
                  Icons.home_rounded,
                  size: 18,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Score Card
// ---------------------------------------------------------------------------

class _ScoreCard extends StatelessWidget {
  final int score;
  final int total;

  const _ScoreCard({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    final ratio = score / total;
    final Color accentColor = ratio >= 0.8
        ? const Color(0xFF4CAF82)
        : ratio >= 0.5
            ? AppColors.mutedLavender
            : const Color(0xFFCF6679);

    return AppCard(
      isElevated: true,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s24,
        vertical: AppSpacing.s32,
      ),
      borderColor: accentColor.withValues(alpha: 0.4),
      child: Column(
        children: [
          // Circular score indicator
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: accentColor, width: 3.0),
              color: AppColors.deepSpace,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$score',
                  style: AppTypography.display.copyWith(
                    color: accentColor,
                    height: 1.0,
                  ),
                ),
                Text(
                  'dari $total',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s20),
          Text(
            'Skor Kamu',
            style: AppTypography.bodySecondary.copyWith(
              color: AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            '$score / $total',
            style: AppTypography.heading.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
