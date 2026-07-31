import 'package:flutter/material.dart';

import '../audio.dart';
import '../config.dart';
import '../levels.dart';
import '../save_store.dart';

/// A grid of every level. Unlocked tiles show their number and best-star
/// rating and are tappable; locked tiles show a padlock and do nothing.
class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({
    super.key,
    required this.store,
    required this.onBack,
    required this.onPick,
  });

  final SaveStore store;
  final VoidCallback onBack;
  final void Function(int level) onPick;

  @override
  Widget build(BuildContext context) {
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _circleBtn(Icons.arrow_back_rounded, onBack),
                  const SizedBox(width: 14),
                  const Text(
                    'Select Level',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star_rounded,
                      color: Cfg.targetColor, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    '${store.totalStars} / $maxStars',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 132,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1,
                  ),
                  itemCount: kLevels.length,
                  itemBuilder: (context, i) => _tile(i),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(int i) {
    final unlocked = store.isUnlocked(i);
    final s = store.stars(i);
    return GestureDetector(
      onTap: unlocked
          ? () {
              Sfx.ui();
              onPick(i);
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: unlocked ? const Color(0x1AFFFFFF) : const Color(0x0DFFFFFF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: unlocked ? const Color(0x40FFFFFF) : const Color(0x1AFFFFFF),
            width: 1.5,
          ),
        ),
        child: unlocked
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${i + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _miniStars(s),
                ],
              )
            : const Center(
                child: Icon(Icons.lock_rounded, color: Color(0x59FFFFFF)),
              ),
      ),
    );
  }

  Widget _miniStars(int s) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (k) {
          final filled = k < s;
          return Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            size: 16,
            color: filled ? Cfg.targetColor : const Color(0x40FFFFFF),
          );
        }),
      );

  Widget _circleBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: () {
          Sfx.ui();
          onTap();
        },
        child: Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Color(0x1AFFFFFF),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      );
}
