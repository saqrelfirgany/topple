import 'package:flame_audio/flame_audio.dart';

/// Sound layer. Every clip is a short procedural wav in `assets/audio/`
/// (FlameAudio's default prefix) — generated maths, zero third-party licensing.
/// `music.wav` is a seamless ambient loop played through FlameAudio's bgm
/// channel; the rest are one-shot effects.
///
/// Browsers block audio until the first user gesture, so [startMusic] is called
/// from the first tap/drag rather than on load. All playback is gated on
/// [muted], and the in-game toggle routes through [applyMute].
class Sfx {
  static bool muted = false;
  static bool _musicStarted = false;

  static void preload() {
    FlameAudio.audioCache.loadAll(
      [
        'launch.wav',
        'hit.wav',
        'win.wav',
        'lose.wav',
        'ui.wav',
        'glass.wav',
        'thud.wav',
      ],
    );
  }

  static void _play(String file, double volume) {
    if (!muted) FlameAudio.play(file, volume: volume);
  }

  static void launch() => _play('launch.wav', 0.5);
  static void hit() => _play('hit.wav', 0.45);
  static void win() => _play('win.wav', 0.6);
  static void lose() => _play('lose.wav', 0.5);
  static void glass() => _play('glass.wav', 0.5);
  static void thud() => _play('thud.wav', 0.55);

  /// Soft click for menu / HUD buttons. Also the natural first gesture, so it
  /// doubles as the trigger that kicks off background music.
  static void ui() {
    _play('ui.wav', 0.4);
    startMusic();
  }

  /// Begin the looping background music. Safe to call repeatedly; no-ops if the
  /// music is already running or the game is muted.
  static void startMusic() {
    if (_musicStarted || muted) return;
    _musicStarted = true;
    FlameAudio.bgm.initialize(); // hooks app-lifecycle pause; safe to call once
    FlameAudio.bgm.play('music.wav', volume: 0.35);
  }

  /// Keep the music in sync with the mute toggle.
  static void applyMute() {
    if (muted) {
      FlameAudio.bgm.pause();
    } else if (_musicStarted) {
      FlameAudio.bgm.resume();
    } else {
      startMusic();
    }
  }
}
