import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// The ball you fling. `bullet: true` turns on continuous collision detection
/// so a fast shot can't tunnel through a thin block in one step.
///
/// Rendered as a filled disc with a rim shade and an off-centre shine; because
/// the body spins as it rolls, the shine rotates with it and reads as spin.
class Projectile extends BodyComponent {
  Projectile(this.startPosition);

  final Vector2 startPosition;

  @override
  void render(Canvas canvas) {
    const r = Cfg.ballRadius;
    canvas.drawCircle(Offset.zero, r, Paint()..color = Cfg.ballColor);
    // rim shade for a touch of volume
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..color = const Color(0x22001018)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.06,
    );
    // shine highlight, upper-left
    canvas.drawCircle(
      Offset(-r * 0.32, -r * 0.32),
      r * 0.30,
      Paint()..color = Cfg.ballShine,
    );
  }

  @override
  Body createBody() {
    final def = BodyDef(
      type: BodyType.dynamic,
      position: startPosition,
      bullet: true,
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
