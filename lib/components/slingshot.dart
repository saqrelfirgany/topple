import 'dart:ui';

import 'package:flame/components.dart';

import '../config.dart';

/// World-space launcher: a wooden base and post carrying a bow at the launch
/// anchor. While you drag, the bowstring pulls back to the nock and a dotted
/// arc previews the shot — the arc integrates the real gravity, and its colour
/// warms from white to orange as you approach full power.
class Slingshot extends PositionComponent {
  /// The launch velocity currently being previewed, or null when not aiming.
  Vector2? aimVelocity;

  @override
  void render(Canvas canvas) {
    final a = Cfg.anchor;
    final g = Cfg.groundY;

    // base platform + upright post holding the bow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(a.x - 0.7, g - 0.5, 1.4, 0.5),
        const Radius.circular(0.1),
      ),
      Paint()..color = Cfg.baseWoodDark,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(a.x - 0.13, a.y, 0.26, g - a.y),
        const Radius.circular(0.08),
      ),
      Paint()..color = Cfg.baseWood,
    );

    // bow limb — a curve bulging toward the target, tips top and bottom
    final topTip = Offset(a.x - 0.1, a.y - 0.95);
    final botTip = Offset(a.x - 0.1, a.y + 0.95);
    canvas.drawPath(
      Path()
        ..moveTo(topTip.dx, topTip.dy)
        ..quadraticBezierTo(a.x + 0.75, a.y, botTip.dx, botTip.dy),
      Paint()
        ..color = Cfg.baseWood
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.16
        ..strokeCap = StrokeCap.round,
    );

    final stringPaint = Paint()
      ..color = Cfg.bowString
      ..strokeWidth = 0.04;

    final v = aimVelocity;
    if (v == null || v.length < 0.001) {
      // relaxed string
      canvas.drawLine(topTip, botTip, stringPaint);
      return;
    }

    // drawn string: pull back to the nock, opposite the launch direction
    final len = v.length;
    final maxLen = Cfg.maxPull * Cfg.launchPower;
    final pull = (len > maxLen ? maxLen : len) / Cfg.launchPower * 0.45;
    final dir = v.normalized();
    final nock = Offset(a.x - dir.x * pull, a.y - dir.y * pull);
    canvas.drawLine(topTip, nock, stringPaint);
    canvas.drawLine(botTip, nock, stringPaint);

    // dotted trajectory, tinted white (soft) -> orange (max power)
    final power = (len / maxLen).clamp(0.0, 1.0);
    final dotColor = Color.lerp(const Color(0xE6FFFFFF), Cfg.targetColor, power)!;
    final grav = Cfg.gravity;
    final p = a.clone();
    final vel = v.clone();
    for (var i = 0; i < Cfg.trajectoryDots; i++) {
      vel.add(grav * Cfg.trajectoryStep);
      p.add(vel * Cfg.trajectoryStep);
      final t = i / Cfg.trajectoryDots;
      final r = 0.11 * (1 - t);
      canvas.drawCircle(
        Offset(p.x, p.y),
        r < 0.035 ? 0.035 : r,
        Paint()..color = dotColor.withAlpha((200 * (1 - t) + 40).toInt()),
      );
    }
  }
}
