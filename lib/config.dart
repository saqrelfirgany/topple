import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

/// Single tuning block — every number that shapes how the game feels lives here.
/// Forge2D uses a +Y-DOWN world: gravity Vector2(0, g) pulls down, so "up / top
/// of the tower" is a SMALLER y and the ground sits at a positive y.
class Cfg {
  // world
  static Vector2 get gravity => Vector2(0, 10);
  // camera fits this many world units across the window width, then centers on
  // `cameraTarget` (responsive: same framing on any window size).
  static const double viewWorldWidth = 26;
  static Vector2 get cameraTarget => Vector2(2, 2);

  // ground
  static const double groundY = 6.0;
  static const double groundHalfWidth = 40.0;
  static const double groundFriction = 0.6;

  // blocks
  static const double blockW = 1.0;
  static const double blockH = 1.0;
  static const double blockGap = 0.02;
  static const double blockDensity = 1.0;
  static const double blockFriction = 0.5;
  static const double blockRestitution = 0.03;

  // projectile
  static const double ballRadius = 0.55;
  static const double ballDensity = 2.4;
  static const double ballFriction = 0.4;
  static const double ballRestitution = 0.2;
  static Vector2 get anchor => Vector2(-8, groundY - 1.2);

  // slingshot feel
  static const double launchPower = 9.0; // launch velocity per world-unit of pull
  static const double maxPull = 6.0;

  // a target counts as "knocked" once it has been displaced this far from where
  // it started (so a light nudge doesn't count, a real topple does).
  static const double knockedDistance = 1.6;

  // a shot is considered settled once the ball is slower than this (after a
  // short grace period), or once it has left the play area.
  static const double settleSpeed = 0.6;
  static const double settleGrace = 0.45; // seconds after launch before checking

  // screen shake (world units), decays each frame
  static const double shakeOnKnock = 0.35;

  // aiming trajectory preview
  static const int trajectoryDots = 20;
  static const double trajectoryStep = 0.055; // seconds between preview samples

  // colors
  static const Color skyTop = Color(0xFF1E4074);
  static const Color skyBottom = Color(0xFF0B1730);
  static const Color bgColor = Color(0xFF0E1A2F);
  static const Color blockColor = Color(0xFF6F9BD8);
  static const Color targetColor = Color(0xFFFFC46B);
  static const Color ballColor = Color(0xFF54C5F8);
  static const int particlesPerKnock = 14; // debris when a block topples
  static final Paint groundPaint = Paint()..color = const Color(0xFF35507A);
  static final Paint blockPaint = Paint()..color = blockColor;
  static final Paint targetPaint = Paint()..color = targetColor;
  static final Paint ballPaint = Paint()..color = ballColor;
  static final Paint aimDotPaint = Paint()..color = const Color(0xB3FFFFFF);
  static final Paint bandPaint = Paint()
    ..color = const Color(0xFFFFC46B)
    ..strokeWidth = 0.14
    ..style = PaintingStyle.stroke;
}
