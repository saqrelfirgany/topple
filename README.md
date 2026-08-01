# Topple 🏹

A 2D bow-and-arrow knock-down physics game, built in Flutter with **Flame** + **Forge2D** (Box2D). Draw the bow, loose the arrow, topple the tower, clear the targets in the fewest shots.

**Play it:** https://saqrelfirgany.github.io/topple/

By [Ahmed "Saqr" ElFirgany](https://github.com/saqrelfirgany) — built in public. One entry per day in `DEVLOG.md`.

## What's in it

- **Real Box2D physics.** Nothing is faked. Every block has mass, friction and restitution, and falls on its own.
- **Three materials.** Wood, heavy stone that shrugs off a hit and works as a wall, and glass that shatters into shards and lets the arrow punch through.
- **13 hand-built levels**, 39 stars, saved progress, and a level select that unlocks as you go.
- **Procedural audio.** Every sound — launch, hit, shatter, win, lose, and the ambient loop — was generated from maths rather than recorded or licensed. Eight short wavs, about 800 KB in total.
- **Trajectory preview** integrated with the same gravity the physics uses, so what you aim is what you get.
- Victory slow-motion, screen shake, debris, parallax clouds, and a cinematic opening pan.

## Stack

- `flame` ^1.38.0 — 2D game engine (Flutter's officially recommended path for 2D)
- `flame_forge2d` ^0.19.3 — Box2D physics bridge
- `shared_preferences` — saved stars and unlocks

## Run

```bash
flutter pub get
flutter run -d chrome   # or -d macos
```

## Controls

Drag anywhere, pull **back**, and release. The arrow flies opposite the pull — the further you pull, the harder it lands.

## Deploy

```bash
bash deploy.sh   # analyze, build web, push to gh-pages
```
