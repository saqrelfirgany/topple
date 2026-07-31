import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';

import '../config.dart';

/// One dynamic box. Target blocks are the ones a level asks you to knock down;
/// a target counts as "knocked" once its body has been displaced far enough
/// from where it started (checked from the game loop — no contact plumbing).
///
/// Targets render as a little character standing in the cell; other blocks
/// render as a bevelled slab whose fill and physics follow [material] (stone is
/// heavy, glass is light and shatters). Everything is drawn in the body's local
/// frame (origin = centre, +y down, world units), so it topples with the body.
class Block extends BodyComponent {
  Block(
    this.startPosition, {
    this.isTarget = false,
    this.material = BlockMaterial.wood,
  });

  final Vector2 startPosition;
  final bool isTarget;
  final BlockMaterial material;

  bool get isGlass => material == BlockMaterial.glass;

  bool get knocked =>
      isMounted && (body.position - startPosition).length > Cfg.knockedDistance;

  Color get _fill => switch (material) {
        BlockMaterial.stone => Cfg.stoneColor,
        BlockMaterial.glass => Cfg.glassFill,
        BlockMaterial.wood => Cfg.blockColor,
      };

  @override
  void render(Canvas canvas) {
    if (isTarget) {
      _drawPerson(canvas);
    } else {
      _drawBlock(canvas);
    }
  }

  void _drawBlock(Canvas canvas) {
    const w = Cfg.blockW;
    const h = Cfg.blockH;
    final slab = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: w, height: h),
      const Radius.circular(Cfg.blockRadius),
    );
    canvas.drawRRect(slab, Paint()..color = _fill);
    // base shade for a bit of 3D volume
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(-w / 2, h / 2 - h * 0.28, w, h * 0.28),
        bottomLeft: const Radius.circular(Cfg.blockRadius),
        bottomRight: const Radius.circular(Cfg.blockRadius),
      ),
      Paint()..color = Cfg.blockShade,
    );
    // top sheen
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(-w / 2, -h / 2, w, h * 0.34),
        topLeft: const Radius.circular(Cfg.blockRadius),
        topRight: const Radius.circular(Cfg.blockRadius),
      ),
      Paint()..color = Cfg.blockHighlight,
    );
    // edge: glass reads with a bright rim, everything else a soft dark one
    canvas.drawRRect(
      slab,
      Paint()
        ..color = isGlass ? Cfg.glassEdge : const Color(0x22000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isGlass ? 0.05 : 0.03,
    );
  }

  void _drawPerson(Canvas canvas) {
    final body = Paint()..color = Cfg.targetColor;
    final head = Paint()..color = Cfg.personHead;
    final face = Paint()..color = Cfg.personFace;
    // feet
    canvas.drawCircle(const Offset(-0.13, 0.45), 0.09, body);
    canvas.drawCircle(const Offset(0.13, 0.45), 0.09, body);
    // torso
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-0.26, -0.04, 0.52, 0.5),
        const Radius.circular(0.16),
      ),
      body,
    );
    // head
    canvas.drawCircle(const Offset(0, -0.24), 0.22, head);
    // eyes
    canvas.drawCircle(const Offset(-0.08, -0.26), 0.04, face);
    canvas.drawCircle(const Offset(0.08, -0.26), 0.04, face);
    // smile (lower arc; +y is down, so this opens upward)
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(0, -0.2), radius: 0.1),
      0.35,
      2.4,
      false,
      Paint()
        ..color = Cfg.personFace
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.03
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  Body createBody() {
    final def = BodyDef(type: BodyType.dynamic, position: startPosition);
    final body = world.createBody(def);
    final shape = PolygonShape()
      ..setAsBox(Cfg.blockW / 2, Cfg.blockH / 2, Vector2.zero(), 0);
    final (density, friction, restitution) = switch (material) {
      BlockMaterial.stone => (
          Cfg.stoneDensity,
          Cfg.stoneFriction,
          Cfg.blockRestitution
        ),
      BlockMaterial.glass => (
          Cfg.glassDensity,
          Cfg.glassFriction,
          Cfg.glassRestitution
        ),
      BlockMaterial.wood => (
          Cfg.blockDensity,
          Cfg.blockFriction,
          Cfg.blockRestitution
        ),
    };
    body.createFixture(
      FixtureDef(
        shape,
        density: density,
        friction: friction,
        restitution: restitution,
      ),
    );
    return body;
  }
}
