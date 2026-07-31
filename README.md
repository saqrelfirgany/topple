# Topple 🧩

A 2D slingshot knock-down physics game, built in Flutter with **Flame** + **Forge2D** (Box2D). Fling a ball, topple the tower, clear the targets in the fewest shots.

By [Ahmed "Saqr" ElFirgany](https://github.com/saqrelfirgany) — built in public.

## Stack

- `flame` ^1.38.0 — 2D game engine (Flutter's officially recommended path for 2D)
- `flame_forge2d` ^0.19.3 — Box2D physics bridge

## Run

```bash
flutter create .        # generate the platform shells (android/ios/web/...) around lib/
flutter pub get
flutter run -d chrome   # or -d macos
```

## Controls

Drag anywhere, pull **back**, and release — the ball launches opposite the pull, slingshot-style.

## Status

Day 1: physics world + a tower that settles under gravity + drag-to-fling. Full roadmap in `PLAN.md`.
