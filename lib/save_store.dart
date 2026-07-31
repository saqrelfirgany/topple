import 'package:shared_preferences/shared_preferences.dart';

/// Persists the player's progress so it survives across sessions:
///  - the best star rating earned on each level (1..3)
///  - how many levels are unlocked (level 0 is always unlocked; clearing a
///    level unlocks the next one)
///
/// Progress is kept in memory and mirrored to shared_preferences. If the
/// platform's preferences store can't be reached, the game still runs with an
/// in-memory store — progress just won't survive a reload. Never let storage
/// break startup.
class SaveStore {
  SaveStore._(this._prefs, this._best, this._unlocked, this._levelCount);

  /// In-memory store used when persistence isn't available.
  factory SaveStore.empty(int levelCount) =>
      SaveStore._(null, <int, int>{}, 1, levelCount);

  final SharedPreferences? _prefs;
  final Map<int, int> _best;
  int _unlocked;
  final int _levelCount;

  static const String _kUnlocked = 'unlockedCount';
  static String _kStars(int i) => 'stars_$i';

  /// Loads saved progress for a game of [levelCount] levels. Falls back to an
  /// empty in-memory store if preferences can't be opened.
  static Future<SaveStore> load(int levelCount) async {
    final SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (_) {
      return SaveStore.empty(levelCount);
    }
    final best = <int, int>{};
    for (var i = 0; i < levelCount; i++) {
      final s = prefs.getInt(_kStars(i));
      if (s != null && s > 0) best[i] = s;
    }
    var unlocked = prefs.getInt(_kUnlocked) ?? 1;
    if (unlocked < 1) unlocked = 1;
    if (unlocked > levelCount) unlocked = levelCount;
    return SaveStore._(prefs, best, unlocked, levelCount);
  }

  /// Wipe all saved progress: every star cleared, only level 0 unlocked again.
  void reset() {
    _best.clear();
    _unlocked = 1;
    _prefs?.setInt(_kUnlocked, 1);
    for (var i = 0; i < _levelCount; i++) {
      _prefs?.remove(_kStars(i));
    }
  }

  int stars(int i) => _best[i] ?? 0;
  bool isUnlocked(int i) => i < _unlocked;
  int get unlockedCount => _unlocked;
  int get totalStars => _best.values.fold(0, (a, b) => a + b);

  /// The level the "Continue" button should drop into: the first unlocked
  /// level not yet three-starred, otherwise the last unlocked level.
  int get continueLevel {
    for (var i = 0; i < _unlocked; i++) {
      if (stars(i) < 3) return i;
    }
    return _unlocked - 1;
  }

  /// Record a cleared level: raise its best stars and unlock the next level.
  void recordWin(int levelIndex, int starsEarned, int levelCount) {
    final prev = _best[levelIndex] ?? 0;
    if (starsEarned > prev) {
      _best[levelIndex] = starsEarned;
      _prefs?.setInt(_kStars(levelIndex), starsEarned);
    }
    var needUnlocked = levelIndex + 2;
    if (needUnlocked > levelCount) needUnlocked = levelCount;
    if (needUnlocked > _unlocked) {
      _unlocked = needUnlocked;
      _prefs?.setInt(_kUnlocked, _unlocked);
    }
  }
}
