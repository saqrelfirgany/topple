import 'package:flutter/material.dart';

import 'game.dart';

/// Flutter overlay drawn on top of the game: a top stat bar (level, targets,
/// balls), an aiming hint, and a win/lose panel. It rebuilds off the game's
/// `hud` ValueNotifier, so it always matches the game state.
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
            Positioned(
              top: 18,
              left: 18,
              right: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _chip('LEVEL ${s.level}'),
                  _chip('TARGETS  ${s.targets - s.targetsLeft}/${s.targets}'),
                  _chip('BALLS  ${s.shotsLeft}'),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: GestureDetector(
                onTap: game.toggleMute,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0x99000000),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      s.muted ? '🔇' : '🔊',
                      style: const TextStyle(fontSize: 19),
                    ),
                  ),
                ),
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
    return Container(
      color: const Color(0xAA060D1A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              won ? 'Level Complete' : 'Out of Balls',
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
                  color: Color(0xFFFFC46B),
                  fontSize: 34,
                  letterSpacing: 4,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              won ? 'Nice shot.' : 'So close — try again.',
              style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: won ? game.nextLevel : game.restartLevel,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54C5F8),
                foregroundColor: const Color(0xFF04101F),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
              child: Text(
                won ? 'Next Level' : 'Retry',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
