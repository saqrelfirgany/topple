# CLAUDE.md — Topple

2D slingshot knock-down physics game. Flutter + Flame ^1.38 + flame_forge2d ^0.19.3 (Box2D). Saqr's original work — commit as himself, **no AI co-author trailer**. Part of the `games/` studio (sibling of `flutter-scene-runner`); reuse patterns from there and the reference in `../knowledge/`.

## Conventions

- **One tuning block:** `lib/config.dart` (`Cfg`) holds every gameplay number. Tune there, not inline.
- **Forge2D coords are +Y DOWN.** Gravity `Vector2(0, 10)` pulls down; "up / top of the tower" = a SMALLER y. The ground sits at a positive y, below the camera center.
- **Bodies live on `world`** (top level) via `world.add(...)` — not nested as children of other components.
- **Projectile uses `bullet: true`** (continuous collision) so a fast shot doesn't tunnel through a thin block.
- **`BodyComponent` auto-draws its fixtures** — the Day-1 MVP uses primitive shapes + `paint` colors, zero assets. Add sprites later.

## Verify the API before writing (it moves)

flame_forge2d 0.19.3 / forge2d 0.14.2 modern surface: `Forge2DGame(gravity:)` has a built-in `camera` (`camera.viewfinder.zoom`); `BodyComponent.createBody()` -> `world.createBody(BodyDef(type:, position:, userData:, bullet:))..createFixture(FixtureDef(shape, density:, friction:, restitution:))`; shapes `EdgeShape()..set(a,b)`, `PolygonShape()..setAsBox(hx,hy,center,angle)`, `CircleShape()..radius`; launch with `body.applyLinearImpulse(Vector2)`; collisions via `with ContactCallbacks` + `beginContact(Object other, Contact c)` (needs `userData` set).

Input GOTCHAS (both hit for real, Day 1):
- `DragCallbacks` and the drag event classes come from **`package:flame/events.dart`** — NOT re-exported by `flame_forge2d`. Import it explicitly or every `Drag*` type is "not found".
- Drag event position fields differ PER TYPE: `DragStartEvent` has `canvasPosition` / `localPosition`; `DragUpdateEvent` has `canvasStartPosition` / `canvasEndPosition` / `canvasDelta` (there is NO single `canvasPosition`); `DragEndEvent` has NO position at all — so capture the current point from `onDragUpdate` (`canvasEndPosition`).

## Run / analyze / test

```bash
flutter pub get
flutter run -d chrome
flutter analyze
flutter test
```

## Roadmap

`PLAN.md` — Day 2 = visual slingshot band + win condition + shot counter; Day 3 = score/stars + multiple levels + HUD + web build + first clip + add to `../hub`.
