import 'dart:math' as math;
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// The arrow you loose. Physics stays a small `bullet` circle — reliable
/// collision with no tunnelling — while the long arrow is drawn on top, rotated
/// to point along its flight (or, while nocked, along [aimAngle]).
/// `fixedRotation` stops the body spinning, so the drawn heading is the only
/// rotation you see.
class Projectile extends BodyComponent {
  Projectile(this.startPosition);

  final Vector2 startPosition;

  /// Heading used while the arrow is at rest — set from the drag as you aim.
  double aimAngle = -0.5;

  @override
  void render(Canvas canvas) {
    final v = body.linearVelocity;
    final moving = v.length2 > 0.25;
    final ang = moving ? math.atan2(v.y, v.x) : aimAngle;
    canvas.save();
    canvas.rotate(ang);
    _drawArrow(canvas);
    canvas.restore();
  }

  void _drawArrow(Canvas c) {
    final half = Cfg.arrowLength / 2;
    // shaft — thin so it reads as an arrow, not a bar
    c.drawLine(
      Offset(-half, 0),
      Offset(half * 0.66, 0),
      Paint()
        ..color = Cfg.arrowShaft
        ..strokeWidth = 0.07
        ..strokeCap = StrokeCap.round,
    );
    // steel head, pointing +x (the direction of travel)
    c.drawPath(
      Path()
        ..moveTo(half, 0)
        ..lineTo(half * 0.66, -0.16)
        ..lineTo(half * 0.66, 0.16)
        ..close(),
      Paint()..color = Cfg.arrowHead,
    );
    // fletching: two swept-back feathers at the tail
    final fl = Paint()..color = Cfg.arrowFletch;
    final tail = -half;
    c.drawPath(
      Path()
        ..moveTo(tail - 0.02, -0.02)
        ..lineTo(tail + 0.34, -0.2)
        ..lineTo(tail + 0.26, -0.02)
        ..lineTo(tail + 0.12, -0.02)
        ..close(),
      fl,
    );
    c.drawPath(
      Path()
        ..moveTo(tail - 0.02, 0.02)
        ..lineTo(tail + 0.34, 0.2)
        ..lineTo(tail + 0.26, 0.02)
        ..lineTo(tail + 0.12, 0.02)
        ..close(),
      fl,
    );
  }

  @override
  Body createBody() {
    final def = BodyDef(
      type: BodyType.dynamic,
      position: startPosition,
      bullet: true,
      fixedRotation: true,
    );
    final body = world.createBody(def);
    final shape = CircleShape()..radius = Cfg.ballRadius;
    body.createFixture(
      FixtureDef(
        shape,
        density: Cfg.ballDensity,
        friction: Cfg.ballFriction,
        restitution: Cfg.ballRestitution,
      ),
    );
    return body;
  }

  void launch(Vector2 impulse) => body.applyLinearImpulse(impulse);

  double get speed => isMounted ? body.linearVelocity.length : 0;
  Vector2 get pos => body.position;
}
