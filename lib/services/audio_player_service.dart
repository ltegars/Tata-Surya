import 'package:flutter/foundation.dart';

/// Audio Player State
enum AudioPlayerState { idle, loading, playing, paused, unavailable }

/// Audio Player Service
/// Phase 3: UI foundation — stub implementation.
/// Replace _startPlayback / _pausePlayback / _stopPlayback with a real
/// audio package (e.g. just_audio) in Phase 4 without changing the public API.
class AudioPlayerService extends ChangeNotifier {
  // ────────────────────────── State ──────────────────────────

  AudioPlayerState _state = AudioPlayerState.idle;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String? _currentAsset;

  // ────────────────────────── Getters ──────────────────────────

  AudioPlayerState get state => _state;
  Duration get position => _position;
  Duration get duration => _duration;
  String? get currentAsset => _currentAsset;

  bool get isPlaying => _state == AudioPlayerState.playing;
  bool get isPaused => _state == AudioPlayerState.paused;
  bool get isUnavailable => _state == AudioPlayerState.unavailable;
  bool get isLoading => _state == AudioPlayerState.loading;
  bool get isIdle => _state == AudioPlayerState.idle;

  /// Progress as 0.0–1.0, safe against zero duration.
  double get progress {
    if (_duration == Duration.zero) return 0.0;
    return (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0);
  }

  // ────────────────────────── Public API ──────────────────────────

  /// Load a new asset path. Pass null or empty string to mark as unavailable.
  Future<void> loadAsset(String? assetPath) async {
    if (assetPath == null || assetPath.isEmpty) {
      _setState(AudioPlayerState.unavailable);
      _currentAsset = null;
      _position = Duration.zero;
      _duration = Duration.zero;
      return;
    }

    if (_currentAsset == assetPath) return; // already loaded

    _setState(AudioPlayerState.loading);
    _currentAsset = assetPath;
    _position = Duration.zero;

    // Phase 3 stub: simulate a brief check then mark unavailable
    // because no real assets exist yet.
    // In Phase 4, replace this block with: await _realPlayer.setAsset(assetPath);
    await Future<void>.delayed(const Duration(milliseconds: 80));
    _duration = Duration.zero;
    _setState(AudioPlayerState.unavailable);
  }

  /// Toggle play / pause. No-op when unavailable.
  Future<void> togglePlayPause() async {
    if (_state == AudioPlayerState.unavailable ||
        _state == AudioPlayerState.loading) {
      return;
    }
    if (_state == AudioPlayerState.playing) {
      await _pausePlayback();
    } else {
      await _startPlayback();
    }
  }

  /// Seek to a specific progress (0.0–1.0). No-op when unavailable.
  Future<void> seekTo(double progress) async {
    if (_state == AudioPlayerState.unavailable || _duration == Duration.zero) {
      return;
    }
    final targetMs = (progress * _duration.inMilliseconds).round();
    _position = Duration(milliseconds: targetMs);
    notifyListeners();
    // Phase 4: await _realPlayer.seek(_position);
  }

  @override
  void dispose() {
    _stopPlayback();
    super.dispose();
  }

  // ────────────────────────── Private ──────────────────────────

  void _setState(AudioPlayerState s) {
    _state = s;
    notifyListeners();
  }

  Future<void> _startPlayback() async {
    // Phase 4: await _realPlayer.play();
    _setState(AudioPlayerState.playing);
  }

  Future<void> _pausePlayback() async {
    // Phase 4: await _realPlayer.pause();
    _setState(AudioPlayerState.paused);
  }

  void _stopPlayback() {
    // Phase 4: _realPlayer.stop();
    _state = AudioPlayerState.idle;
    _position = Duration.zero;
  }
}

/// Utility: format Duration as m:ss
String formatAudioDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(1, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
