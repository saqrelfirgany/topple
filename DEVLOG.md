# Devlog — Topple

Building a 2D slingshot knock-down physics game in Flutter (Flame + Forge2D), in public. One entry per development stage — each stage is also a post.

## Day 1 — the first physics loop (2026-07-31)

Got the core standing: a Forge2D world with gravity, a floor, a tower of blocks that settles under real physics, and a ball you fling with a drag — pull back, release, watch the tower buckle.

What's real already:

- **Real Box2D physics** via `flame_forge2d` — nothing is faked. Blocks have mass, friction and restitution; they lean, topple and pile up on their own.
- **Drag-to-fling launch**: the pull vector becomes a linear impulse on a `bullet`-flagged projectile, so a fast shot can't tunnel through a thin block.
- **Responsive camera**: zoom is derived from the window width, so the framing holds on any screen size.

Primitive shapes on purpose — Day 1 is about the loop *feeling* right, not the art.

Next (Day 2): a visual slingshot band, a real win condition (clear the targets), and a shot counter.

Clip: `../showcase/topple/day1-first-run.mov` · still: `../showcase/topple/day1-topple.png`
