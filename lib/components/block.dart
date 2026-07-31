import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// One dynamic box in the tower. `isTarget` blocks are the ones a level asks
/// you to knock down; they're painted differently and checked for a win later.
class Block extends BodyComponent with ContactCallbacks {
  Block(this.startPosition, {this.isTarget = false}) {
    paint = isTarget ? Cfg.targetPaint : Cfg.blockPaint;
  }

  final Vector2 startPosition;
  final bool isTarget;

  @override
  Body createBody() {
    final def = BodyDef(
      type: BodyType.dynamic,
      position: startPosition,
      userData: this, // required so contact callbacks resolve to this component
    );
    final body = world.createBody(def);
    final shape = PolygonShape()
      ..setAsBox(Cfg.blockW / 2, Cfg.blockH / 2, Vector2.zero(), 0);
    body.createFixture(
      FixtureDef(
        shape,
        density: Cfg.blockDensity,
        friction: Cfg.blockFriction,
        restitution: Cfg.blockRestitution,
      ),
    );
    return body;
  }
}
