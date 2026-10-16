/// Quiz Question Model
/// Used by QuizData and QuizScreen (Phase 5A)
class QuizQuestion {
  /// The question text displayed to the user
  final String question;

  /// List of exactly 4 answer choices
  final List<String> options;

  /// Zero-based index of the correct answer in [options]
  final int correctAnswerIndex;

  /// Brief explanation shown after the user answers
  final String explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}
