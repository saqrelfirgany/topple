import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../config.dart';

class _P {
  _P(this.pos, this.vel, this.life, this.maxLife, this.color);
  final Vector2 pos;
  final Vector2 vel;
  double life;
  final double maxLife;
  final Color color;
}

/// World-space debris. Call [burst] at a block's position when it topples and a
/// short-lived shower of little squares flies out, tinted like the block. Pure
/// cosmetics — it holds no physics bodies, just points it integrates itself.
class Fx extends PositionComponent {
  final List<_P> _ps = [];
  final Random _rng = Random();

  void burst(Vector2 at, Color color) {
    for (var i = 0; i < Cfg.particlesPerKnock; i++) {
      final ang = _rng.nextDouble() * pi * 2;
      final sp = 1.5 + _rng.nextDouble() * 4.5;
      final vel = Vector2(cos(ang) * sp, sin(ang) * sp - 2.2); // biased upward
      final life = 0.45 + _rng.nextDouble() * 0.45;
      _ps.add(_P(at.clone(), vel, life, life, color));
    }
  }

  void clear() => _ps.clear();

  @override
  void update(double dt) {
    for (final p in _ps) {
      p.vel.add(Cfg.gravity * dt);
      p.pos.add(p.vel * dt);
      p.life -= dt;
    }
    _ps.removeWhere((p) => p.life <= 0);
  }

  @override
  void render(Canvas canvas) {
    for (final p in _ps) {
      final a = p.life / p.maxLife;
      final alpha = (a * 255).clamp(0.0, 255.0).toInt();
      final half = 0.08 * a + 0.04;
      canvas.drawRect(
        Rect.fromCircle(center: Offset(p.pos.x, p.pos.y), radius: half),
        Paint()..color = p.color.withAlpha(alpha),
      );
    }
  }
}
