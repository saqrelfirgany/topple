import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// One dynamic box. Target blocks are the ones a level asks you to knock down;
/// a target counts as "knocked" once its body has been displaced far enough
/// from where it started (checked from the game loop — no contact plumbing).
///
/// Rendering is a hand-drawn rounded slab with a top sheen and a soft edge,
/// drawn in the body's local frame (origin = centre, +y down, world units),
/// so it topples and spins with the physics for free.
class Block extends BodyComponent {
  Block(this.startPosition, {this.isTarget = false});

  final Vector2 startPosition;
  final bool isTarget;

  bool get knocked =>
      isMounted && (body.position - startPosition).length > Cfg.knockedDistance;

  @override
  void render(Canvas canvas) {
    const w = Cfg.blockW;
    const h = Cfg.blockH;
    final slab = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: w, height: h),
      const Radius.circular(Cfg.blockRadius),
    );
    canvas.drawRRect(
      slab,
      Paint()..color = isTarget ? Cfg.targetColor : Cfg.blockColor,
    );
    // top sheen: a lighter bar across the upper third, top corners matched
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(-w / 2, -h / 2, w, h * 0.34),
        topLeft: const Radius.circular(Cfg.blockRadius),
        topRight: const Radius.circular(Cfg.blockRadius),
      ),
      Paint()..color = Cfg.blockHighlight,
    );
    // soft edge so stacked blocks stay readable
    canvas.drawRRect(
      slab,
      Paint()
        ..color = const Color(0x22000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.03,
    );
  }

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
