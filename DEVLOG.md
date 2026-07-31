# Devlog — Topple

Building a 2D slingshot knock-down physics game in Flutter (Flame + Forge2D), in public. One entry per development stage — each stage is also a post.

## Day 1 — the first physics loop (2026-07-31)

Got the core standing: a Forge2D world with gravity, a floor, a tower of blocks that settles under real physics, and a ball you fling with a drag — pull back, release, watch the tower buckle.

What's real already:

- **Real Box2D physics** via `flame_forge2d` — nothing is faked. Blocks have mass, friction and restitution; they lean, topple and pile up on their own.
- **Drag-to-fling launch**: the pull vector becomes a linear impulse on a `bullet`-flagged projectile, so a fast shot can't tunnel through a thin block.
- **Responsive camera**: zoom is derived from the window width, so the framing holds on any screen size.

Primitive shapes on purpose — Day 1 is about the loop *feeling* right, not the art.

## Day 2 — it's a real game (2026-07-31)

Turned the sandbox into an actual game:

- **Levels + ammo + win/lose**: clear every target block to win; run out of balls and it's a retry. A small state machine (aiming → flying → won/lost) drives it.
- **Aiming trajectory preview**: while you pull back, a dotted arc predicts the ball's real path — integrated with the same gravity the physics uses, so what you see is what you get.
- **HUD**: level, targets cleared, balls left — a clean Flutter overlay layered on top of the Flame canvas.
- **Juice**: the screen kicks when a tower topples, and a navy sky gradient replaced the flat black.
- **Impact debris**: each block throws a short shower of tinted squares as it goes down.
- Five hand-made levels now, from a simple tower to twin-target towers.

Still primitive shapes — but it plays like a game, not a demo.

Next (Day 3): star ratings, a ball trail, sound — then a public build.

Clips: `../showcase/topple/day1-first-run.mov`, `../showcase/topple/day2-real-game.mov`
