import 'package:flutter/material.dart';
import '../../data/quiz_data.dart';
import '../../models/quiz_question.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import '../main_navigation_shell.dart';
import 'quiz_result_screen.dart';

/// Quiz Screen — Phase 5A
/// Menampilkan 10 soal pilihan ganda Tata Surya satu per satu.
class QuizScreen extends StatefulWidget {
  /// Called when the user confirms they want to exit the quiz.
  /// If null, the back button is not shown.
  final VoidCallback? onExitToHome;

  const QuizScreen({super.key, this.onExitToHome});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuizQuestion> _questions = QuizData.questions;

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _answered = false;

  QuizQuestion get _currentQuestion => _questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;
  bool get _isCorrect =>
      _selectedOptionIndex == _currentQuestion.correctAnswerIndex;

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOptionIndex = index;
      _answered = true;
      if (index == _currentQuestion.correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedOptionIndex = null;
      _answered = false;
    });
  }

  void _advance() {
    if (!_answered) return;
    if (_isLastQuestion) {
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            score: _score,
            total: _questions.length,
            onRetry: () {
              Navigator.of(context).pop();
              _resetQuiz();
            },
            onReturnHome: () {
              Navigator.of(context).pop();
              _resetQuiz();
              if (widget.onExitToHome != null) {
                widget.onExitToHome!();
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const MainNavigationShell(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ),
      );
    } else {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _answered = false;
      });
    }
  }

  Future<void> _confirmExit() async {
    final onExit = widget.onExitToHome;
    if (onExit == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.border, width: 1.0),
        ),
        title: Text(
          'Keluar dari kuis?',
          style: AppTypography.section.copyWith(fontSize: 18),
        ),
        content: Text(
          'Jawaban dan progres kuis saat ini akan hilang.',
          style: AppTypography.bodySecondary,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.s16,
          AppSpacing.s4,
          AppSpacing.s16,
          AppSpacing.s16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Batal',
              style: AppTypography.buttonLabel.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Keluar',
              style: AppTypography.buttonLabel.copyWith(
                color: AppColors.mutedLavender,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _resetQuiz();
      onExit();
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
        leading: widget.onExitToHome != null
            ? IconButton(
                tooltip: 'Keluar dari kuis',
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryText,
                ),
                onPressed: _confirmExit,
              )
            : null,
        automaticallyImplyLeading: false,
        title: Text(
          'Kuis Tata Surya',
          style: AppTypography.section,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fixed header: progress bar + soal counter ────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16,
                AppSpacing.s4,
                AppSpacing.s16,
                AppSpacing.s4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentIndex + 1) / _questions.length,
                      minHeight: 5,
                      backgroundColor: AppColors.surfaceElevated,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.mutedLavender,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    'Soal ${_currentIndex + 1} dari ${_questions.length}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.mutedLavender,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable question + options + feedback ─────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s8,
                  AppSpacing.s16,
                  AppSpacing.s16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question text
                    AppCard(
                      isElevated: true,
                      padding: AppSpacing.p20,
                      child: Text(
                        _currentQuestion.question,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.55,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),

                    // Answer options
                    ...List.generate(
                      _currentQuestion.options.length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                        child: _OptionTile(
                          label: _optionLabel(i),
                          text: _currentQuestion.options[i],
                          state: _optionState(i),
                          onTap: _answered ? null : () => _selectOption(i),
                        ),
                      ),
                    ),

                    // Feedback panel
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.12),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      ),
                      child: _answered
                          ? _FeedbackPanel(
                              key: ValueKey(_currentIndex),
                              isCorrect: _isCorrect,
                              correctAnswer: _currentQuestion
                                  .options[_currentQuestion.correctAnswerIndex],
                              explanation: _currentQuestion.explanation,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            // ── Fixed bottom: Lanjut / Lihat Hasil button ────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s16,
                AppSpacing.s8,
                AppSpacing.s16,
                AppSpacing.s16,
              ),
              child: AppButton(
                text: _isLastQuestion ? 'Lihat Hasil' : 'Lanjut',
                onPressed: _answered ? _advance : null,
                trailingIcon: Icon(
                  _isLastQuestion
                      ? Icons.check_rounded
                      : Icons.arrow_forward_rounded,
                  size: 18,
                  color: _answered
                      ? AppColors.primaryButtonText
                      : AppColors.secondaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _optionLabel(int i) => const ['A', 'B', 'C', 'D'][i];

  _OptionState _optionState(int i) {
    if (!_answered) return _OptionState.idle;
    if (i == _currentQuestion.correctAnswerIndex) return _OptionState.correct;
    if (i == _selectedOptionIndex) return _OptionState.incorrect;
    return _OptionState.dimmed;
  }
}


// ---------------------------------------------------------------------------
// Option State
// ---------------------------------------------------------------------------

enum _OptionState { idle, correct, incorrect, dimmed }

// ---------------------------------------------------------------------------
// Option Tile
// ---------------------------------------------------------------------------

class _OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final _OptionState state;
  final VoidCallback? onTap;

  const _OptionTile({
    required this.label,
    required this.text,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colors based on state
    final Color bgColor;
    final Color borderColor;
    final Color labelBg;
    final Color textColor;

    switch (state) {
      case _OptionState.correct:
        bgColor = const Color(0xFF1E2E22);
        borderColor = const Color(0xFF4CAF82);
        labelBg = const Color(0xFF4CAF82);
        textColor = AppColors.primaryText;
        break;
      case _OptionState.incorrect:
        bgColor = const Color(0xFF2E1E1E);
        borderColor = const Color(0xFFCF6679);
        labelBg = const Color(0xFFCF6679);
        textColor = AppColors.primaryText;
        break;
      case _OptionState.dimmed:
        bgColor = AppColors.surface;
        borderColor = AppColors.border.withValues(alpha: 0.4);
        labelBg = AppColors.surfaceElevated;
        textColor = AppColors.secondaryText.withValues(alpha: 0.5);
        break;
      case _OptionState.idle:
        bgColor = AppColors.surface;
        borderColor = AppColors.border;
        labelBg = AppColors.surfaceElevated;
        textColor = AppColors.primaryText;
        break;
    }

    final labelColor = (state == _OptionState.correct || state == _OptionState.incorrect)
        ? Colors.white
        : AppColors.mutedLavender;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        splashColor: AppColors.mutedLavender.withValues(alpha: 0.10),
        highlightColor: AppColors.mutedLavender.withValues(alpha: 0.06),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: borderColor, width: 1.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Label badge
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: labelBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              // Answer text
              Expanded(
                child: Text(
                  text,
                  style: AppTypography.body.copyWith(
                    color: textColor,
                    fontSize: 15,
                    height: 1.45,
                  ),
                ),
              ),
              // State icon
              if (state == _OptionState.correct) ...[
                const SizedBox(width: AppSpacing.s8),
                const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF4CAF82), size: 20),
              ] else if (state == _OptionState.incorrect) ...[
                const SizedBox(width: AppSpacing.s8),
                const Icon(Icons.cancel_rounded,
                    color: Color(0xFFCF6679), size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feedback Panel
// ---------------------------------------------------------------------------

class _FeedbackPanel extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String explanation;

  const _FeedbackPanel({
    super.key,
    required this.isCorrect,
    required this.correctAnswer,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isCorrect ? const Color(0xFF4CAF82) : const Color(0xFFCF6679);
    final bgColor =
        isCorrect ? const Color(0xFF1A2B1F) : const Color(0xFF2B1A1F);
    final iconData =
        isCorrect ? Icons.check_circle_outline : Icons.info_outline_rounded;
    final statusText =
        isCorrect ? 'Jawaban benar' : 'Jawaban kurang tepat';
    final statusColor =
        isCorrect ? const Color(0xFF4CAF82) : const Color(0xFFCF6679);

    return Container(
      padding: AppSpacing.p16,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: borderColor.withValues(alpha: 0.6), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconData, color: statusColor, size: 18),
              const SizedBox(width: AppSpacing.s8),
              Text(
                statusText,
                style: AppTypography.bodySecondary.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            explanation,
            style: AppTypography.bodySecondary.copyWith(
              color: AppColors.primaryText.withValues(alpha: 0.85),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
