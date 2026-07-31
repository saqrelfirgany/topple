import 'package:flame_audio/flame_audio.dart';

/// Tiny sound layer. Every clip is a short procedural wav in `assets/audio/`
/// (FlameAudio's default prefix) — generated maths, zero third-party licensing,
/// same approach as the runner's audio.
class Sfx {
  static bool muted = false;

  static void preload() {
    // fire-and-forget; FlameAudio also loads on first play if this hasn't run
    FlameAudio.audioCache
        .loadAll(['launch.wav', 'hit.wav', 'win.wav', 'lose.wav']);
  }

  static void _play(String file, double volume) {
    if (!muted) FlameAudio.play(file, volume: volume);
  }

  static void launch() => _play('launch.wav', 0.5);
  static void hit() => _play('hit.wav', 0.45);
  static void win() => _play('win.wav', 0.6);
  static void lose() => _play('lose.wav', 0.5);
}
