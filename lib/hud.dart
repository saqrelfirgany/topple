import 'package:flutter/material.dart';

import 'audio.dart';
import 'config.dart';
import 'game.dart';

/// Flutter overlay drawn on top of the game: a levels button, a compact stat
/// bar (level, targets, balls), a mute toggle, an aiming hint, and the
/// win/lose panel. It rebuilds off the game's `hud` ValueNotifier, so it always
/// matches the game state.
class ToppleHud extends StatelessWidget {
  const ToppleHud(this.game, {super.key});

  final ToppleGame game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<HudState>(
      valueListenable: game.hud,
      builder: (context, s, _) {
        return Stack(
          children: [
            // top-left: back to the level picker
            Positioned(
              top: 16,
              left: 14,
              child: _roundButton(
                child: const Icon(Icons.apps_rounded,
                    color: Colors.white, size: 22),
                onTap: () {
                  Sfx.ui();
                  game.exitToLevels();
                },
              ),
            ),
            // top-right: stats, scaled down rather than overflowing on phones
            Positioned(
              top: 18,
              left: 70,
              right: 14,
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _chip('LEVEL ${s.level}'),
                      const SizedBox(width: 8),
                      _chip(
                          'TARGETS ${s.targets - s.targetsLeft}/${s.targets}'),
                      const SizedBox(width: 8),
                      _chip('BALLS ${s.shotsLeft}'),
                    ],
                  ),
                ),
              ),
            ),
            // bottom-right: mute
            Positioned(
              bottom: 16,
              right: 16,
              child: _roundButton(
                child: Center(
                  child: Text(
                    s.muted ? '🔇' : '🔊',
                    style: const TextStyle(fontSize: 19),
                  ),
                ),
                onTap: game.toggleMute,
              ),
            ),
            // bottom-left: pause (only while actively playing)
            if ((s.phase == Phase.aiming || s.phase == Phase.flying) &&
                !s.paused)
              Positioned(
                bottom: 16,
                left: 14,
                child: _roundButton(
                  child: const Icon(Icons.pause_rounded,
                      color: Colors.white, size: 22),
                  onTap: game.togglePause,
                ),
              ),
            if (s.phase == Phase.aiming && !s.paused)
              const Positioned(
                bottom: 22,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Center(
                    child: Text(
                      'Drag back and release',
                      style: TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            if (s.phase == Phase.aiming || s.phase == Phase.flying)
              _LevelBanner(s.level, key: ValueKey(s.level)),
            if (s.paused) Positioned.fill(child: _pausePanel(s)),
            if (s.phase == Phase.won || s.phase == Phase.lost)
              Positioned.fill(child: _panel(s)),
          ],
        );
      },
    );
  }

  Widget _roundButton({required Widget child, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0x99000000),
            shape: BoxShape.circle,
          ),
          child: child,
        ),
      );

  Widget _chip(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0x99000000),
          borderRadius: BorderRadius.all(Radius.circular(999)),
        ),
        child: Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _pausePanel(HudState s) {
    return Container(
      color: const Color(0xCC060D1A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paused',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                Sfx.ui();
                game.togglePause();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Cfg.ballColor,
                foregroundColor: const Color(0xFF04101F),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Resume',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    Sfx.ui();
                    game.restartLevel();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xCCFFFFFF),
                  ),
                  child: const Text('Restart',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () {
                    Sfx.ui();
                    game.exitToLevels();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xCCFFFFFF),
                  ),
                  child: const Text('Levels',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: game.toggleMute,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0x22FFFFFF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(s.muted ? '🔇' : '🔊',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(
                      s.muted ? 'Sound off' : 'Sound on',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel(HudState s) {
    final won = s.phase == Phase.won;
    final last = game.isLastLevel;
    final title =
        won ? (last ? 'All Cleared!' : 'Level Complete') : 'Out of Balls';
    final subtitle = won
        ? (last ? 'You toppled every level.' : 'Nice shot.')
        : 'So close — try again.';

    late final String primaryLabel;
    late final VoidCallback primaryAction;
    late final String secondaryLabel;
    late final VoidCallback secondaryAction;
    if (won && !last) {
      primaryLabel = 'Next Level';
      primaryAction = game.nextLevel;
      secondaryLabel = 'Levels';
      secondaryAction = game.exitToLevels;
    } else if (won && last) {
      primaryLabel = 'Back to Levels';
      primaryAction = game.exitToLevels;
      secondaryLabel = 'Replay';
      secondaryAction = game.restartLevel;
    } else {
      primaryLabel = 'Retry';
      primaryAction = game.restartLevel;
      secondaryLabel = 'Levels';
      secondaryAction = game.exitToLevels;
    }

    return Container(
      color: const Color(0xAA060D1A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (won) ...[
              const SizedBox(height: 10),
              Text(
                '★' * s.stars + '☆' * (3 - s.stars),
                style: const TextStyle(
                  color: Cfg.targetColor,
                  fontSize: 34,
                  letterSpacing: 4,
                ),
              ),
            ],
            if (won && s.newBest) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Cfg.targetColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'NEW BEST!',
                  style: TextStyle(
                    color: Cfg.targetColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 15),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                Sfx.ui();
                primaryAction();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Cfg.ballColor,
                foregroundColor: const Color(0xFF04101F),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                primaryLabel,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Sfx.ui();
                secondaryAction();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xCCFFFFFF),
              ),
              child: Text(
                secondaryLabel,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A "LEVEL N" title that fades in, holds, and fades out at the start of a
/// level. Keyed by level number in the HUD, so it replays for each new level
/// but not on a retry (the number is unchanged there).
class _LevelBanner extends StatefulWidget {
  const _LevelBanner(this.level, {super.key});

  final int level;

  @override
  State<_LevelBanner> createState() => _LevelBannerState();
}

class _LevelBannerState extends State<_LevelBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  double _opacityFor(double t) {
    if (t < 0.12) return t / 0.12; // fade in
    if (t > 0.72) return (1 - (t - 0.72) / 0.28).clamp(0.0, 1.0); // fade out
    return 1.0; // hold
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final op = _opacityFor(_c.value);
          if (op <= 0.001) return const SizedBox.shrink();
          return Align(
            alignment: const Alignment(0, -0.42),
            child: Opacity(
              opacity: op,
              child: Text(
                'LEVEL ${widget.level}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(color: Color(0x99000000), blurRadius: 12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
