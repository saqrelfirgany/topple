import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'hud.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget<ToppleGame>(
          game: ToppleGame(),
          overlayBuilderMap: {
            'hud': (context, game) => ToppleHud(game),
          },
          initialActiveOverlays: const ['hud'],
        ),
      ),
    ),
  );
}
