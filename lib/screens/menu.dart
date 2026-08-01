import 'package:flutter/material.dart';

import '../audio.dart';
import '../config.dart';
import '../levels.dart';
import '../save_store.dart';

/// Title screen: a little bow-and-tower logo, the game name, and the two ways
/// in — Continue/Play (drops into the next sensible level) and Select Level.
class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
    required this.store,
    required this.onPlay,
    required this.onLevels,
    required this.onReset,
  });

  final SaveStore store;
  final VoidCallback onPlay;
  final VoidCallback onLevels;
  final VoidCallback onReset;

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
                  'Aim the bow. Topple the targets.',
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
                if (started) ...[
                  const SizedBox(height: 10),
                  _ResetButton(onReset: onReset),
                ],
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
          onPressed: () {
            Sfx.ui();
            onTap();
          },
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
          onPressed: () {
            Sfx.ui();
            onTap();
          },
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
      width: 168,
      height: 104,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // the tower on the right, with a little character standing on top
          Positioned(left: 118, bottom: 0, child: _block(Cfg.stoneColor)),
          Positioned(left: 118, bottom: 42, child: _block(Cfg.blockColor)),
          Positioned(left: 127, bottom: 84, child: _head()),
          // the bow with a nocked arrow, aimed at it
          const Positioned(
            left: 0,
            bottom: 0,
            top: 0,
            child: SizedBox(
              width: 112,
              child: CustomPaint(painter: _BowPainter()),
            ),
          ),
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

  Widget _head() => Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Cfg.personHead,
          shape: BoxShape.circle,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [_eye(), const SizedBox(width: 5), _eye()],
        ),
      );

  Widget _eye() => Container(
        width: 4,
        height: 4,
        decoration: const BoxDecoration(
          color: Cfg.personFace,
          shape: BoxShape.circle,
        ),
      );
}

/// The menu's bow: two limbs curving away from the target, a string pulled back
/// to the nock, and the arrow sitting on it ready to go.
class _BowPainter extends CustomPainter {
  const _BowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final spine = w * 0.46; // where the bow sits
    final line = h * 0.55; // the arrow's height

    final top = Offset(spine, h * 0.10);
    final bottom = Offset(spine, h * 0.94);
    final nock = Offset(spine + w * 0.13, line);

    // limbs
    canvas.drawPath(
      Path()
        ..moveTo(top.dx, top.dy)
        ..quadraticBezierTo(spine - w * 0.30, line, bottom.dx, bottom.dy),
      Paint()
        ..color = Cfg.baseWood
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // string, drawn back to the nock
    canvas.drawPath(
      Path()
        ..moveTo(top.dx, top.dy)
        ..lineTo(nock.dx, nock.dy)
        ..lineTo(bottom.dx, bottom.dy),
      Paint()
        ..color = Cfg.bowString
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // shaft
    final tip = Offset(w * 0.88, line);
    canvas.drawLine(
      nock,
      tip,
      Paint()
        ..color = Cfg.arrowShaft
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // head
    canvas.drawPath(
      Path()
        ..moveTo(tip.dx + 9, line)
        ..lineTo(tip.dx - 3, line - 6)
        ..lineTo(tip.dx - 3, line + 6)
        ..close(),
      Paint()..color = Cfg.arrowHead,
    );

    // fletching
    canvas.drawPath(
      Path()
        ..moveTo(nock.dx - 1, line)
        ..lineTo(nock.dx + 11, line - 7)
        ..lineTo(nock.dx + 11, line + 7)
        ..close(),
      Paint()..color = Cfg.arrowFletch,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A deliberately low-key "reset progress" control that asks for a second tap
/// to confirm, so nobody wipes their stars by accident.
class _ResetButton extends StatefulWidget {
  const _ResetButton({required this.onReset});

  final VoidCallback onReset;

  @override
  State<_ResetButton> createState() => _ResetButtonState();
}

class _ResetButtonState extends State<_ResetButton> {
  bool _confirm = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_confirm) {
          widget.onReset();
          setState(() => _confirm = false);
        } else {
          setState(() => _confirm = true);
        }
      },
      style: TextButton.styleFrom(
        foregroundColor:
            _confirm ? const Color(0xFFFF8A8A) : const Color(0x66FFFFFF),
      ),
      child: Text(
        _confirm ? 'Tap again to confirm reset' : 'Reset progress',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
