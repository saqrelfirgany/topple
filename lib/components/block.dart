import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// One dynamic box. Target blocks are the ones a level asks you to knock down;
/// a target counts as "knocked" once its body has been displaced far enough
/// from where it started (checked from the game loop — no contact plumbing).
class Block extends BodyComponent {
  Block(this.startPosition, {this.isTarget = false}) {
    paint = isTarget ? Cfg.targetPaint : Cfg.blockPaint;
  }

  final Vector2 startPosition;
  final bool isTarget;

  bool get knocked =>
      isMounted && (body.position - startPosition).length > Cfg.knockedDistance;

  @override
  Body createBody() {
    final def = BodyDef(type: BodyType.dynamic, position: startPosition);
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
