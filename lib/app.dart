import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'config.dart';
import 'game.dart';
import 'hud.dart';
import 'levels.dart';
import 'save_store.dart';
import 'screens/level_select.dart';
import 'screens/menu.dart';

enum _Screen { menu, levels, game }

/// Top-level shell that routes between the menu, the level picker, and a live
/// game. It owns the persistent [SaveStore]; the game reports results back into
/// it, so the picker always shows fresh stars when you return.
class ToppleApp extends StatefulWidget {
  const ToppleApp({super.key, required this.store});

  final SaveStore store;

  @override
  State<ToppleApp> createState() => _ToppleAppState();
}

class _ToppleAppState extends State<ToppleApp> {
  _Screen _screen = _Screen.menu;
  int _level = 0;

  SaveStore get _store => widget.store;

  void _goMenu() => setState(() => _screen = _Screen.menu);
  void _goLevels() => setState(() => _screen = _Screen.levels);
  void _play(int i) => setState(() {
        _level = i;
        _screen = _Screen.game;
      });
  void _resetProgress() => setState(() => _store.reset());

  @override
  Widget build(BuildContext context) {
    final Widget child = switch (_screen) {
      _Screen.menu => MenuScreen(
          key: const ValueKey('menu'),
          store: _store,
          onPlay: () => _play(_store.continueLevel),
          onLevels: _goLevels,
          onReset: _resetProgress,
        ),
      _Screen.levels => LevelSelectScreen(
          key: const ValueKey('levels'),
          store: _store,
          onBack: _goMenu,
          onPick: _play,
        ),
      _Screen.game => _GameScreen(
          key: ValueKey('game-$_level'),
          store: _store,
          startLevel: _level,
          onExit: _goLevels,
        ),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Cfg.bgColor,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: child,
        ),
      ),
    );
  }
}

class _GameScreen extends StatefulWidget {
  const _GameScreen({
    super.key,
    required this.store,
    required this.startLevel,
    required this.onExit,
  });

  final SaveStore store;
  final int startLevel;
  final VoidCallback onExit;

  @override
  State<_GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<_GameScreen> {
  late final ToppleGame _game = ToppleGame(
    startLevel: widget.startLevel,
    onLevelResult: (i, stars) {
      final prev = widget.store.stars(i);
      widget.store.recordWin(i, stars, kLevels.length);
      return prev > 0 && stars > prev;
    },
    onExit: widget.onExit,
  );

  @override
  Widget build(BuildContext context) {
    return GameWidget<ToppleGame>(
      game: _game,
      overlayBuilderMap: {
        'hud': (context, game) => ToppleHud(game),
      },
      initialActiveOverlays: const ['hud'],
    );
  }
}
