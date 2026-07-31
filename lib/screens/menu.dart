import 'package:flutter/material.dart';

import '../config.dart';
import '../levels.dart';
import '../save_store.dart';

/// Title screen: a little stacked-block logo, the game name, and the two ways
/// in — Continue/Play (drops into the next sensible level) and Select Level.
class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    required this.store,
    required this.onPlay,
    required this.onLevels,
  });

  final SaveStore store;
  final VoidCallback onPlay;
  final VoidCallback onLevels;

  @override
  Widget build(BuildContext context) {
    final started = store.totalStars > 0;
    final maxStars = kLevels.length * 3;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Cfg.skyTop, Cfg.skyBottom],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _Logo(),
                const SizedBox(height: 28),
                const Text(
                  'TOPPLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fling. Topple. Clear the orange.',
                  style: TextStyle(color: Color(0xB3FFFFFF), fontSize: 15),
                ),
                const SizedBox(height: 40),
                _primary(started ? 'Continue' : 'Play', onPlay),
                const SizedBox(height: 14),
                _secondary('Select Level', onLevels),
                const SizedBox(height: 30),
                _totalStars(store.totalStars, maxStars),
                const SizedBox(height: 18),
                const Text(
                  'by Ahmed “Saqr” ElFirgany',
                  style: TextStyle(color: Color(0x66FFFFFF), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _primary(String label, VoidCallback onTap) => SizedBox(
        width: 240,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Cfg.ballColor,
            foregroundColor: const Color(0xFF04101F),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ),
      );

  Widget _secondary(String label, VoidCallback onTap) => SizedBox(
        width: 240,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Color(0x55FFFFFF)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );

  Widget _totalStars(int total, int max) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Cfg.targetColor, size: 22),
          const SizedBox(width: 6),
          Text(
            '$total / $max',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(left: 42, bottom: 0, child: _block(Cfg.blockColor)),
          Positioned(left: 86, bottom: 0, child: _block(Cfg.blockColor)),
          Positioned(left: 64, bottom: 42, child: _block(Cfg.targetColor)),
          Positioned(left: 6, bottom: 14, child: _ball()),
        ],
      ),
    );
  }

  Widget _block(Color c) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(8),
        ),
      );

  Widget _ball() => Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: Cfg.ballColor,
          shape: BoxShape.circle,
        ),
      );
}
