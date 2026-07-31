import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// Static floor. A single horizontal edge is the cheapest solid ground in
/// Box2D — nothing falls through it and it costs one fixture.
class Ground extends BodyComponent {
  Ground() {
    paint = Cfg.groundPaint;
  }

  @override
  Body createBody() {
    final def = BodyDef(
      type: BodyType.static,
      position: Vector2(0, Cfg.groundY),
    );
    final body = world.createBody(def);
    final shape = EdgeShape()
      ..set(
        Vector2(-Cfg.groundHalfWidth, 0),
        Vector2(Cfg.groundHalfWidth, 0),
      );
    body.createFixture(FixtureDef(shape, friction: Cfg.groundFriction));
    return body;
  }
}
