import 'package:flutter/material.dart';
import '../../../services/audio_player_service.dart';
import '../../../theme/theme.dart';

/// Audio Player Section
/// Phase 3: Full UI with play/pause, progress bar, position/duration display.
/// Communicates unavailability clearly when no audio asset exists.
/// Wires into [AudioPlayerService] — replace service stub with real audio in Phase 4.
class AudioPlayerSection extends StatefulWidget {
  final AudioPlayerService audioService;

  const AudioPlayerSection({
    super.key,
    required this.audioService,
  });

  @override
  State<AudioPlayerSection> createState() => _AudioPlayerSectionState();
}

class _AudioPlayerSectionState extends State<AudioPlayerSection> {
  @override
  void initState() {
    super.initState();
    widget.audioService.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    widget.audioService.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.audioService;
    final isUnavailable = service.isUnavailable;
    final isLoading = service.isLoading;
    final isPlaying = service.isPlaying;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.roundedCard,
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section label
          Row(
            children: [
              const Icon(
                Icons.headphones_rounded,
                size: 16,
                color: AppColors.mutedLavender,
              ),
              const SizedBox(width: AppSpacing.s8),
              Text(
                'Dengarkan',
                style: AppTypography.caption.copyWith(
                  color: AppColors.mutedLavender,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s12),

          // Unavailable banner
          if (isUnavailable) ...[
            _UnavailableBanner(),
            const SizedBox(height: AppSpacing.s12),
          ],

          // Player controls row
          Row(
            children: [
              // Play/Pause button
              _PlayPauseButton(
                isPlaying: isPlaying,
                isLoading: isLoading,
                isUnavailable: isUnavailable,
                onTap: isUnavailable ? null : service.togglePlayPause,
              ),

              const SizedBox(width: AppSpacing.s12),

              // Progress + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar
                    _ProgressBar(
                      progress: service.progress,
                      isEnabled: !isUnavailable && !isLoading,
                      onSeek: (v) => service.seekTo(v),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    // Time display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatAudioDuration(service.position),
                          style: AppTypography.caption.copyWith(
                            fontSize: 11,
                            color: isUnavailable
                                ? AppColors.secondaryText.withValues(alpha: 0.45)
                                : AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          service.duration == Duration.zero
                              ? '--:--'
                              : formatAudioDuration(service.duration),
                          style: AppTypography.caption.copyWith(
                            fontSize: 11,
                            color: isUnavailable
                                ? AppColors.secondaryText.withValues(alpha: 0.45)
                                : AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ────────────────────────── Sub-widgets ──────────────────────────

class _UnavailableBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.roundedSmall,
        border: Border.all(
          color: AppColors.border,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 14,
            color: AppColors.secondaryText,
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              'Narasi audio belum tersedia.',
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final bool isUnavailable;
  final VoidCallback? onTap;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.isLoading,
    required this.isUnavailable,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = isUnavailable
        ? AppColors.surfaceElevated
        : AppColors.mutedLavender.withValues(alpha: 0.15);
    final iconColor = isUnavailable
        ? AppColors.secondaryText.withValues(alpha: 0.40)
        : AppColors.mutedLavender;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isUnavailable ? AppColors.border : AppColors.mutedLavender.withValues(alpha: 0.35),
            width: 1.0,
          ),
        ),
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.mutedLavender,
                ),
              )
            : Icon(
                isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 22,
                color: iconColor,
              ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;
  final bool isEnabled;
  final ValueChanged<double> onSeek;

  const _ProgressBar({
    required this.progress,
    required this.isEnabled,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragUpdate: isEnabled
              ? (details) {
                  final pos = (details.localPosition.dx / constraints.maxWidth)
                      .clamp(0.0, 1.0);
                  onSeek(pos);
                }
              : null,
          onTapDown: isEnabled
              ? (details) {
                  final pos = (details.localPosition.dx / constraints.maxWidth)
                      .clamp(0.0, 1.0);
                  onSeek(pos);
                }
              : null,
          child: ClipRRect(
            borderRadius: AppRadius.roundedSmall,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColors.border,
              color: isEnabled
                  ? AppColors.mutedLavender
                  : AppColors.secondaryText.withValues(alpha: 0.30),
            ),
          ),
        );
      },
    );
  }
}
