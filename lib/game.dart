import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';

import 'audio.dart';
import 'components/block.dart';
import 'components/ground.dart';
import 'components/particles.dart';
import 'components/projectile.dart';
import 'components/slingshot.dart';
import 'config.dart';
import 'levels.dart';

enum Phase { aiming, flying, won, lost }

/// Small immutable snapshot the Flutter HUD listens to.
class HudState {
  const HudState({
    required this.level,
    required this.shotsLeft,
    required this.targets,
    required this.targetsLeft,
    required this.phase,
    this.stars = 0,
    this.muted = false,
  });
  final int level;
  final int shotsLeft;
  final int targets;
  final int targetsLeft;
  final Phase phase;
  final int stars;
  final bool muted;
}

class ToppleGame extends Forge2DGame with DragCallbacks {
  ToppleGame() : super(gravity: Cfg.gravity);

  /// Drives the HUD overlay (see hud.dart).
  final ValueNotifier<HudState> hud = ValueNotifier<HudState>(
    const HudState(
      level: 1,
      shotsLeft: 0,
      targets: 0,
      targetsLeft: 0,
      phase: Phase.aiming,
    ),
  );

  final _rng = math.Random();
  final List<Block> _blocks = [];
  late final Slingshot _slingshot;
  late final Fx _fx;
  Projectile? _ball;

  int _levelIndex = 0;
  int _shotsLeft = 0;
  int _ammo = 0;
  int _ballsUsed = 0;
  int _stars = 0;
  Phase _phase = Phase.aiming;

  double _flyTime = 0;
  double _shake = 0;
  double _hitCd = 0;
  final Set<Block> _knockedSet = {};

  Vector2? _dragStart; // canvas px
  Vector2 _dragCurrent = Vector2.zero();

  @override
  Color backgroundColor() => Cfg.bgColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    world.add(Ground());
    _slingshot = Slingshot();
    world.add(_slingshot);
    _fx = Fx();
    world.add(_fx);
    Sfx.preload();
    _loadLevel(0);
  }

  @override
  void render(Canvas canvas) {
    // sky gradient behind everything (screen space, before the world)
    final rect = Offset.zero & Size(size.x, size.y);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = Gradient.linear(
          Offset(size.x / 2, 0),
          Offset(size.x / 2, size.y),
          const [Cfg.skyTop, Cfg.skyBottom],
        ),
    );
    // soft parallax clouds, screen space, behind the world
    final cloud = Paint()..color = const Color(0x12FFFFFF);
    canvas.drawOval(
        Rect.fromLTWH(size.x * 0.10, size.y * 0.12, size.x * 0.17, size.y * 0.06),
        cloud);
    canvas.drawOval(
        Rect.fromLTWH(size.x * 0.60, size.y * 0.08, size.x * 0.22, size.y * 0.07),
        cloud);
    canvas.drawOval(
        Rect.fromLTWH(size.x * 0.40, size.y * 0.20, size.x * 0.13, size.y * 0.05),
        cloud);
    super.render(canvas);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.viewfinder
      ..zoom = size.x / Cfg.viewWorldWidth
      ..position = Cfg.cameraTarget;
  }

  // ---- level lifecycle -------------------------------------------------------

  void _loadLevel(int index) {
    for (final b in _blocks) {
      b.removeFromParent();
    }
    _blocks.clear();
    _ball?.removeFromParent();
    _ball = null;

    _levelIndex = index % kLevels.length;
    final def = kLevels[_levelIndex];
    for (final spec in def.blocks) {
      final b = Block(blockPos(spec), isTarget: spec.target);
      _blocks.add(b);
      world.add(b);
    }
    _shotsLeft = def.ammo;
    _ammo = def.ammo;
    _ballsUsed = 0;
    _stars = 0;
    _phase = Phase.aiming;
    _flyTime = 0;
    _knockedSet.clear();
    _fx.clear();
    _shake = 0;
    camera.viewfinder.position = Cfg.cameraTarget;
    _spawnBall();
    _pushHud();
  }

  void restartLevel() => _loadLevel(_levelIndex);
  void nextLevel() => _loadLevel(_levelIndex + 1);

  void _spawnBall() {
    _ball?.removeFromParent();
    _ball = Projectile(Cfg.anchor.clone());
    world.add(_ball!);
    _slingshot.aimVelocity = null;
  }

  int get _targets => _blocks.where((b) => b.isTarget).length;
  int get _targetsLeft =>
      _blocks.where((b) => b.isTarget && !b.knocked).length;

  void _pushHud() {
    hud.value = HudState(
      level: _levelIndex + 1,
      shotsLeft: _shotsLeft,
      targets: _targets,
      targetsLeft: _targetsLeft,
      phase: _phase,
      stars: _stars,
      muted: Sfx.muted,
    );
  }

  void _awardStars() =>
      _stars = math.max(1, math.min(3, _ammo - _ballsUsed + 1));

  void toggleMute() {
    Sfx.muted = !Sfx.muted;
    _pushHud();
  }

  // ---- per-frame -------------------------------------------------------------

  @override
  void update(double dt) {
    super.update(dt);
    if (_hitCd > 0) _hitCd -= dt;

    // debris + shake + hit sound + HUD refresh whenever a block newly topples
    var newlyKnocked = false;
    for (final b in _blocks) {
      if (b.knocked && !_knockedSet.contains(b)) {
        _knockedSet.add(b);
        _fx.burst(
            b.body.position, b.isTarget ? Cfg.targetColor : Cfg.blockColor);
        newlyKnocked = true;
      }
    }
    if (newlyKnocked) {
      _shake = Cfg.shakeOnKnock;
      if (_hitCd <= 0) {
        Sfx.hit();
        _hitCd = Cfg.hitCooldown;
      }
      _pushHud();
    }
    _applyShake(dt);

    // ball trail while a shot is in the air
    final tb = _ball;
    if (_phase == Phase.flying && tb != null && tb.isMounted) {
      _fx.trail(tb.pos);
    } else {
      _fx.trail(null);
    }

    if (_phase != Phase.flying) return;
    _flyTime += dt;

    if (_targetsLeft == 0) {
      _awardStars();
      _phase = Phase.won;
      Sfx.win();
      _pushHud();
      return;
    }

    final b = _ball;
    final settled = b == null ||
        (_flyTime > Cfg.settleGrace && b.speed < Cfg.settleSpeed) ||
        b.pos.y > Cfg.groundY + 4 ||
        b.pos.x.abs() > 34;
    if (settled) _resolveShot();
  }

  void _resolveShot() {
    _shotsLeft = math.max(0, _shotsLeft - 1);
    if (_targetsLeft == 0) {
      _awardStars();
      _phase = Phase.won;
      Sfx.win();
    } else if (_shotsLeft <= 0) {
      _phase = Phase.lost;
      Sfx.lose();
    } else {
      _phase = Phase.aiming;
      _spawnBall();
    }
    _pushHud();
  }

  void _applyShake(double dt) {
    if (_shake <= 0.0001) return;
    _shake *= math.max(0.0, 1 - dt * 9);
    if (_shake < 0.02) {
      _shake = 0;
      camera.viewfinder.position = Cfg.cameraTarget;
      return;
    }
    final off =
        Vector2(_rng.nextDouble() * 2 - 1, _rng.nextDouble() * 2 - 1) * _shake;
    camera.viewfinder.position = Cfg.cameraTarget + off;
  }

  // ---- input -----------------------------------------------------------------

  Vector2 _launchVelocity() {
    final pullPx = _dragStart! - _dragCurrent;
    var pull = pullPx / camera.viewfinder.zoom;
    if (pull.length > Cfg.maxPull) {
      pull = pull.normalized() * Cfg.maxPull;
    }
    return pull * Cfg.launchPower;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_phase != Phase.aiming) return;
    _dragStart = event.canvasPosition.clone();
    _dragCurrent = event.canvasPosition.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_phase != Phase.aiming || _dragStart == null) return;
    _dragCurrent = event.canvasEndPosition.clone();
    _slingshot.aimVelocity = _launchVelocity();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (_phase != Phase.aiming || _dragStart == null) return;
    final vel = _launchVelocity();
    _dragStart = null;
    _slingshot.aimVelocity = null;
    final ball = _ball;
    if (ball == null || !ball.isMounted) return;
    ball.launch(vel * ball.body.mass); // impulse = mass * velocity
    Sfx.launch();
    _ballsUsed++;
    _phase = Phase.flying;
    _flyTime = 0;
    _pushHud();
  }
}
