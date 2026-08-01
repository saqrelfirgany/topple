# Devlog — Topple

Building a 2D bow-and-arrow knock-down physics game in Flutter (Flame + Forge2D), in public. One entry per development stage — each stage is also a post.

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

## Day 3 — stars, sound, and a public build (2026-07-31)

Made it feel finished and put it online:

- **Star ratings** — three stars for a clean clear, fewer as you spend more balls.
- **Ball trail** streaming behind a shot in the air.
- **Procedural sound** — launch, hit, win and lose, all synthesised from maths (zero third-party licensing) — plus a mute toggle.
- **Shipped live** on GitHub Pages and linked from the games hub.

## Day 4 — from primitives to a look (2026-07-31)

Same physics, a proper face:

- Blocks became **rounded slabs with a top sheen**; the ground became a **grass-and-dirt** strip; the ball got a **shine that spins with it** as it rolls; and **soft parallax clouds** drift behind the play.

## Day 5 — a whole game around the game (2026-07-31)

Wrapped the loop in an actual product:

- **Start menu** — logo, Continue/Play, Select Level, total stars.
- **Level-select grid** with per-level star ratings and locked-until-you-reach-them levels.
- **Saved progress** — best stars and unlocks persist across sessions (`shared_preferences`).
- **Music + clicks** — a seamless procedural ambient loop and soft button sounds.
- **"LEVEL N" card** at the start of each level, and a **"New Best!"** note when you beat your rating.
- A **cinematic opening camera pan** that frames the target before easing to the slingshot, and an **aim line that reddens** as you pull toward maximum power.

## Day 6 — depth, feel, and shippability (2026-07-31)

The "make it excellent" pass:

- **Block materials** — heavy **stone** that shrugs off your shots and works as a wall, and **glass** that shatters into shards and lets the ball punch through, each with its own sound.
- **Victory slow-motion** — time dilates on the final knock so you watch the tower come down, then the panel drops.
- **Pause overlay** (resume / restart / levels / sound) and **reset-progress** in the menu.
- **13 levels** now, mixing wood, stone and glass.
- **Web presentation** — branded title, favicon and app icons, a dark loading screen (no white flash), and a link-preview image so the deployed link looks sharp when it's shared.

## Day 7 — the reskin: a bow, an arrow, and someone to knock down (2026-07-31)

Same physics engine, a different game to look at. This was the day it stopped looking like a tech demo:

- **The ball became an arrow** — a real shaft with a head and fletching that rotates to face the way it is flying, so a shot reads as a shot.
- **The slingshot became a bow** — wooden limbs planted on a base, with a string that draws back as you pull.
- **The orange blocks became characters** — little figures standing on the towers, so knocking one down actually means something.
- **Blocks got depth** — a soft shade band along the base fakes volume, so a flat stack reads as a wall.
- **It survives a hostile browser** — if local storage is blocked the game falls back to memory instead of hanging, and any startup error now prints on screen instead of spinning forever.

## Day 8 — the launch check (2026-08-01)

Before promoting the game anywhere I played the live build the way a stranger would, and found the things I had stopped seeing:

- **The reward screen was broken.** The star rating was drawn with the text characters ★ and ☆. The web font does not carry them, so the moment you cleared a level the game showed you three empty boxes. The mute button had the same problem with its emoji. Both are Material icons now — the same ones the level select was already using correctly.
- **The HUD still said BALLS**, two days after the ball became an arrow. It reads ARROWS now, and running out is *Out of Arrows*.
- **The title screen still said "Fling. Topple. Clear the orange."** next to a ball logo. It is a bow aimed at a tower now, and the line is *aim the bow, topple the targets* — the same words as the link preview.
- Added `deploy.sh`, so refreshing the live build is one command instead of five.

None of this touched the physics. All of it touched the first thirty seconds, which is the only part most people ever see.

Clips: `../showcase/topple/day1-first-run.mov`, `../showcase/topple/day2-real-game.mov`
