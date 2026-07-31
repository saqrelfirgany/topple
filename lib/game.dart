import 'package:flame_forge2d/flame_forge2d.dart';

import 'components/block.dart';
import 'components/ground.dart';
import 'components/projectile.dart';
import 'config.dart';

/// Day-1 playable: a Forge2D world with a floor, a tower of blocks that settles
/// under gravity, and a ball you fling with a drag. Drag anywhere, pull BACK,
/// and release — the ball launches opposite the pull, slingshot-style.
class ToppleGame extends Forge2DGame with DragCallbacks {
  ToppleGame() : super(gravity: Cfg.gravity);

  late Projectile _ball;
  Vector2? _dragStart; // canvas px where this drag began
  Vector2 _dragCurrent = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewfinder.zoom = Cfg.zoom;
    world.add(Ground());
    _buildTower();
    _spawnBall();
  }

  void _buildTower() {
    final rowStep = Cfg.blockH + Cfg.blockGap;
    final colStep = Cfg.blockW + Cfg.blockGap;
    final baseY = Cfg.groundY - Cfg.blockH / 2; // bottom row rests on the ground
    for (var row = 0; row < Cfg.towerRows; row++) {
      for (var col = 0; col < Cfg.towerCols; col++) {
        final x = Cfg.towerX + col * colStep;
        final y = baseY - row * rowStep; // up = smaller y (Forge2D is +y down)
        final isTarget = row == Cfg.towerRows - 1; // top row = the targets
        world.add(Block(Vector2(x, y), isTarget: isTarget));
      }
    }
  }

  void _spawnBall() {
    _ball = Projectile(Cfg.anchor.clone());
    world.add(_ball);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (_ball.launched) {
      _spawnBall(); // last shot is already flying; load a fresh ball
    }
    _dragStart = event.canvasPosition.clone();
    _dragCurrent = event.canvasPosition.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _dragCurrent = event.canvasPosition.clone();
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    final start = _dragStart;
    if (start == null) return;
    _dragStart = null;

    // Pull-back vector, screen px. Screen +y and world +y both point down, so
    // no axis flip: drag down-and-back and the ball flies up-and-forward.
    final pullPx = start - _dragCurrent;
    var pullWorld = pullPx / Cfg.zoom;
    if (pullWorld.length > Cfg.maxPull) {
      pullWorld = pullWorld.normalized() * Cfg.maxPull;
    }
    // impulse = mass * velocity; launch velocity scales with how far you pulled.
    final impulse = pullWorld * (Cfg.launchPower * _ball.body.mass);
    _ball.launch(impulse);
  }
}
