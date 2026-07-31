import 'dart:ui';

import 'package:flame/components.dart';

import '../config.dart';

/// World-space aiming overlay: a small marker at the launch anchor, and — while
/// the player is dragging — a pull "band" plus a dotted prediction of where the
/// ball will fly. The prediction integrates the same gravity the physics uses,
/// so the dots trace the real path.
class Slingshot extends PositionComponent {
  /// The launch velocity currently being previewed, or null when not aiming.
  Vector2? aimVelocity;

  @override
  void render(Canvas canvas) {
    final a = Cfg.anchor;
    canvas.drawCircle(Offset(a.x, a.y), 0.2, Cfg.aimDotPaint);

    final v = aimVelocity;
    if (v == null) return;

    // pull band: a line from the anchor back, opposite the launch direction
    final len = v.length;
    final pull = len > Cfg.maxPull * Cfg.launchPower
        ? Cfg.maxPull * Cfg.launchPower
        : len;
    if (len > 0.001) {
      final back = a - v.normalized() * (pull / Cfg.launchPower * 0.45);
      canvas.drawLine(Offset(a.x, a.y), Offset(back.x, back.y), Cfg.bandPaint);
    }

    // dotted trajectory prediction
    final g = Cfg.gravity;
    final p = a.clone();
    final vel = v.clone();
    for (var i = 0; i < Cfg.trajectoryDots; i++) {
      vel.add(g * Cfg.trajectoryStep);
      p.add(vel * Cfg.trajectoryStep);
      final t = i / Cfg.trajectoryDots;
      final r = 0.11 * (1 - t);
      canvas.drawCircle(Offset(p.x, p.y), r < 0.035 ? 0.035 : r, Cfg.aimDotPaint);
    }
  }
}
