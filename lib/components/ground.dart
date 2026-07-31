import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// Static floor. A single horizontal edge is the cheapest solid ground in
/// Box2D — nothing falls through it and it costs one fixture.
///
/// The edge sits at local y = 0; render draws a thin grass strip right at the
/// surface and a deep dirt fill below it, so blocks visibly rest on grass.
class Ground extends BodyComponent {
  @override
  void render(Canvas canvas) {
    const hw = Cfg.groundHalfWidth;
    const grassH = 0.34;
    // dirt below the surface (well past the bottom of the view)
    canvas.drawRect(
      Rect.fromLTWH(-hw, grassH, hw * 2, 40),
      Paint()..color = Cfg.dirtColor,
    );
    // grass cap sitting exactly on the collision edge
    canvas.drawRect(
      Rect.fromLTWH(-hw, 0, hw * 2, grassH),
      Paint()..color = Cfg.grassColor,
    );
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
