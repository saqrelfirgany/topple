import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// The ball you fling. `bullet: true` turns on continuous collision detection
/// so a fast shot can't tunnel straight through a thin block in one step.
class Projectile extends BodyComponent with ContactCallbacks {
  Projectile(this.startPosition) {
    paint = Cfg.ballPaint;
  }

  final Vector2 startPosition;

  /// Set once the ball has been launched, so the game knows to respawn a fresh
  /// one for the next shot instead of re-flinging a ball that's already flying.
  bool launched = false;

  @override
  Body createBody() {
    final def = BodyDef(
      type: BodyType.dynamic,
      position: startPosition,
      bullet: true,
      userData: this,
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

  void launch(Vector2 impulse) {
    launched = true;
    body.applyLinearImpulse(impulse);
  }
}
