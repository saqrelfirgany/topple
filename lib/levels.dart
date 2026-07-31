import 'package:flame_forge2d/flame_forge2d.dart';

import 'config.dart';

/// One block placement: a world x, a row (0 = on the ground, up increases), and
/// whether it's a target (the thing you must knock down to clear the level).
class BlockSpec {
  const BlockSpec(
    this.x,
    this.row, {
    this.target = false,
    this.material = BlockMaterial.wood,
  });
  final double x;
  final int row;
  final bool target;
  final BlockMaterial material;
}

class LevelDef {
  const LevelDef({required this.ammo, required this.blocks});
  final int ammo;
  final List<BlockSpec> blocks;
}

/// World position for a spec's block, resting on the ground and stacked up.
Vector2 blockPos(BlockSpec b) {
  final baseY = Cfg.groundY - Cfg.blockH / 2;
  final y = baseY - b.row * (Cfg.blockH + Cfg.blockGap);
  return Vector2(b.x, y);
}

const double _c0 = 5.0;
const double _c1 = 6.04; // one block + gap to the right
const double _c2 = 7.08;

/// Hand-made levels. Keep the tower to the right; the launch anchor is on the
/// left. Each level names its targets and how many balls you get.
final List<LevelDef> kLevels = [
  // L1 — a 2-wide, 4-tall tower, the top row is the targets.
  LevelDef(
    ammo: 3,
    blocks: [
      for (var r = 0; r < 4; r++) ...[
        BlockSpec(_c0, r, target: r == 3),
        BlockSpec(_c1, r, target: r == 3),
      ],
    ],
  ),
  // L2 — two separate pillars, a target on top of each.
  LevelDef(
    ammo: 4,
    blocks: [
      for (var r = 0; r < 3; r++) BlockSpec(4.4, r, target: r == 2),
      for (var r = 0; r < 3; r++) BlockSpec(8.2, r, target: r == 2),
    ],
  ),
  // L3 — a 3-wide, 5-tall stack, targets tucked in the upper-right column.
  LevelDef(
    ammo: 4,
    blocks: [
      for (var r = 0; r < 5; r++) ...[
        BlockSpec(_c0, r),
        BlockSpec(_c1, r, target: r >= 3),
        BlockSpec(_c2, r),
      ],
    ],
  ),
  // L4 — a pyramid: wide base narrowing upward, one target crowning it.
  LevelDef(
    ammo: 5,
    blocks: [
      BlockSpec(4.5, 0),
      BlockSpec(5.54, 0),
      BlockSpec(6.58, 0),
      BlockSpec(7.62, 0),
      BlockSpec(5.02, 1),
      BlockSpec(6.06, 1),
      BlockSpec(7.1, 1),
      BlockSpec(5.54, 2),
      BlockSpec(6.58, 2),
      BlockSpec(6.06, 3, target: true),
    ],
  ),
  // L5 — two towers, a target crowning each; clear both to win.
  LevelDef(
    ammo: 5,
    blocks: [
      for (var r = 0; r < 4; r++) BlockSpec(4.2, r),
      for (var r = 0; r < 4; r++) BlockSpec(8.4, r),
      BlockSpec(4.2, 4, target: true),
      BlockSpec(8.4, 4, target: true),
    ],
  ),
  // L6 — a reinforced 2-wide, 5-tall wall; the targets ride near the top, so
  // you have to topple the whole thing rather than clip a corner.
  LevelDef(
    ammo: 4,
    blocks: [
      for (var r = 0; r < 5; r++) ...[
        BlockSpec(_c0, r, target: r == 3),
        BlockSpec(_c1, r, target: r == 3),
      ],
    ],
  ),
  // L7 — two short pillars (the targets) flanking a heavy STONE guard tower;
  // stone barely budges, so arc your shots over it onto the pillars.
  LevelDef(
    ammo: 4,
    blocks: [
      for (var r = 0; r < 3; r++) BlockSpec(4.4, r, target: r == 2),
      for (var r = 0; r < 5; r++)
        BlockSpec(6.3, r, material: BlockMaterial.stone),
      for (var r = 0; r < 3; r++) BlockSpec(8.2, r, target: r == 2),
    ],
  ),
  // L8 — a precision spire: one block wide, six tall, target on the very top.
  LevelDef(
    ammo: 3,
    blocks: [
      for (var r = 0; r < 6; r++) BlockSpec(6.0, r, target: r == 5),
    ],
  ),
  // L9 — the finale: a pyramid and a side tower, a target crowning each.
  LevelDef(
    ammo: 5,
    blocks: [
      BlockSpec(4.5, 0),
      BlockSpec(5.54, 0),
      BlockSpec(6.58, 0),
      BlockSpec(7.62, 0),
      BlockSpec(5.02, 1),
      BlockSpec(6.06, 1),
      BlockSpec(7.1, 1),
      BlockSpec(5.54, 2),
      BlockSpec(6.58, 2),
      BlockSpec(6.06, 3, target: true),
      for (var r = 0; r < 4; r++) BlockSpec(9.4, r),
      BlockSpec(9.4, 4, target: true),
    ],
  ),
  // L10 — a GLASS wall guards the target; smash straight through it, the shards
  // scatter, and the shot carries on to the block behind.
  LevelDef(
    ammo: 5,
    blocks: [
      for (var r = 0; r < 4; r++) ...[
        BlockSpec(5.6, r, material: BlockMaterial.glass),
        BlockSpec(6.64, r, material: BlockMaterial.glass),
      ],
      for (var r = 0; r < 2; r++) BlockSpec(8.5, r),
      BlockSpec(8.5, 2, target: true),
    ],
  ),
  // L11 — two wood targets rising between stubby stone guards; clip their tops.
  LevelDef(
    ammo: 5,
    blocks: [
      BlockSpec(5.0, 0, material: BlockMaterial.stone),
      BlockSpec(6.04, 0, target: true),
      BlockSpec(6.04, 1, target: true),
      BlockSpec(7.08, 0, material: BlockMaterial.stone),
    ],
  ),
  // L12 — a tall glass tower crowned with a target; shatter its base and the
  // whole thing comes down.
  LevelDef(
    ammo: 3,
    blocks: [
      for (var r = 0; r < 5; r++)
        BlockSpec(6.2, r, material: BlockMaterial.glass),
      BlockSpec(6.2, 5, target: true),
    ],
  ),
  // L13 — the mix: stone footings, a glass midsection, two targets, and a glass
  // screen down the middle. Everything you've learned in one.
  LevelDef(
    ammo: 6,
    blocks: [
      BlockSpec(4.6, 0, material: BlockMaterial.stone),
      BlockSpec(4.6, 1, material: BlockMaterial.glass),
      BlockSpec(4.6, 2, target: true),
      BlockSpec(8.2, 0, material: BlockMaterial.stone),
      BlockSpec(8.2, 1, material: BlockMaterial.glass),
      BlockSpec(8.2, 2, target: true),
      for (var r = 0; r < 3; r++)
        BlockSpec(6.4, r, material: BlockMaterial.glass),
    ],
  ),
];
