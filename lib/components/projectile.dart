import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// The ball you fling. `bullet: true` turns on continuous collision detection
/// so a fast shot can't tunnel through a thin block in one step.
class Projectile extends BodyComponent {
  Projectile(this.startPosition) {
    paint = Cfg.ballPaint;
  }

  final Vector2 startPosition;

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
