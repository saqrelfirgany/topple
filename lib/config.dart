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
  // seconds the opening camera pan (frames the target, then eases home) takes
  static const double introDuration = 0.85;

  // victory: physics slows to this fraction for `winSlowmoTime` real seconds so
  // you watch the last target fall, then the panel appears.
  static const double winSlowmoScale = 0.35;
  static const double winSlowmoTime = 0.6;

  // screen flash (white overlay alpha, decays each frame)
  static const double flashOnTarget = 0.22;
  static const double flashOnWin = 0.5;
  static const double flashDecay = 3.5;

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

  // min seconds between "hit" sounds, so a whole tower toppling isn't a wall of noise
  static const double hitCooldown = 0.07;

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
  static const Color grassColor = Color(0xFF3E8E5A);
  static const Color dirtColor = Color(0xFF223146);
  static const Color blockHighlight = Color(0x30FFFFFF);
  static const Color ballShine = Color(0x70FFFFFF);
  static const double blockRadius = 0.15;

  // materials — wood is the baseline block* values above; stone is heavy and
  // stubborn, glass is light and shatters when struck.
  static const double stoneDensity = 3.4;
  static const double stoneFriction = 0.72;
  static const double glassDensity = 0.55;
  static const double glassFriction = 0.2;
  static const double glassRestitution = 0.1;
  static const Color stoneColor = Color(0xFF8A93A6);
  static const Color glassFill = Color(0x5CBFEFFF); // translucent
  static const Color glassEdge = Color(0xCCE8FBFF);
  static const int glassShards = 16;

  // depth shading — a soft dark band along a block's base fakes 3D volume
  static const Color blockShade = Color(0x22000000);

  // arrow projectile
  static const double arrowLength = 1.7;
  static const Color arrowShaft = Color(0xFF8A5A2B);
  static const Color arrowHead = Color(0xFFCFD8E3);
  static const Color arrowFletch = Color(0xFFE24C4C);

  // bow launcher (base + limbs + string)
  static const Color baseWood = Color(0xFF6E4A28);
  static const Color baseWoodDark = Color(0xFF48301A);
  static const Color bowString = Color(0xCCE8EEF6);

  // person-shaped targets (the body reuses targetColor)
  static const Color personHead = Color(0xFFFFE0B0);
  static const Color personFace = Color(0xFF5A3A1A);

  static final Paint aimDotPaint = Paint()..color = const Color(0xB3FFFFFF);
  static final Paint bandPaint = Paint()
    ..color = const Color(0xFFFFC46B)
    ..strokeWidth = 0.14
    ..style = PaintingStyle.stroke;
}

/// What a block is made of — changes how it looks, how heavy it is, and (for
/// glass) whether it shatters when struck.
enum BlockMaterial { wood, stone, glass }
