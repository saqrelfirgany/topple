import 'package:flutter/material.dart';

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
                onTap: game.exitToLevels,
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
            if (s.phase == Phase.aiming)
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
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 15),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: primaryAction,
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
              onPressed: secondaryAction,
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
