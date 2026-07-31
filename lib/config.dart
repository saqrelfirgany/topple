import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

/// Single tuning block. Every number that shapes how the game feels lives here,
/// so tuning is one place, not a hunt through the code (same discipline as the
/// 3D runner). Forge2D uses a +Y-DOWN world: gravity Vector2(0, g) pulls down,
/// and "up / on top of the tower" means a SMALLER y.
class Cfg {
  // world
  static Vector2 get gravity => Vector2(0, 10);
  // camera fits this many world units across the window width, then centers on
  // `cameraTarget`. Deriving zoom from the window keeps framing consistent on
  // any screen size (a fixed zoom looked fine on one window, tiny on another).
  static const double viewWorldWidth = 26;
  static Vector2 get cameraTarget => Vector2(2, 2);

  // ground: a static floor line. Sits below the camera center (so +y).
  static const double groundY = 6.0;
  static const double groundHalfWidth = 40.0;
  static const double groundFriction = 0.6;

  // blocks that make the tower
  static const double blockW = 1.0;
  static const double blockH = 1.0;
  static const double blockGap = 0.02; // tiny gap so they settle, not overlap
  static const double blockDensity = 1.0;
  static const double blockFriction = 0.5;
  static const double blockRestitution = 0.03;
  static const int towerRows = 5;
  static const int towerCols = 2;
  static const double towerX = 5.0; // left edge of the tower, world x

  // projectile (the thing you fling)
  static const double ballRadius = 0.55;
  static const double ballDensity = 2.4;
  static const double ballFriction = 0.4;
  static const double ballRestitution = 0.2;
  static Vector2 get anchor => Vector2(-8, groundY - 1.2); // launch point

  // slingshot feel
  static const double launchPower = 9.0; // velocity per world-unit of pull
  static const double maxPull = 6.0; // clamp pull length (world units)

  // colors
  static const Color bgColor = Color(0xFF0E1A2F); // deep navy sky (brand-ish)
  static final Paint groundPaint = Paint()..color = const Color(0xFF3A4A63);
  static final Paint blockPaint = Paint()..color = const Color(0xFF6F9BD8);
  static final Paint targetPaint = Paint()..color = const Color(0xFFFFC46B);
  static final Paint ballPaint = Paint()..color = const Color(0xFF54C5F8);
}
