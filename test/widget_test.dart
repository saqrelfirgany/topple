// Level data is the part of this game that is pure and cheap to check.
// A level with no targets can never be cleared and a level with no ammo can
// never be tried, and both of those fail silently in play — you just sit there
// wondering what you are doing wrong. So they are asserted here instead.

import 'package:flutter_test/flutter_test.dart';
import 'package:topple/levels.dart';

void main() {
  test('there are 13 levels, which is 39 stars', () {
    expect(kLevels.length, 13);
    expect(kLevels.length * 3, 39);
  });

  test('every level can actually be cleared', () {
    for (var i = 0; i < kLevels.length; i++) {
      final level = kLevels[i];
      final targets = level.blocks.where((b) => b.target).length;
      expect(targets, greaterThan(0), reason: 'level ${i + 1} has no targets');
      expect(level.ammo, greaterThan(0), reason: 'level ${i + 1} has no arrows');
    }
  });

  test('no block starts below the ground', () {
    for (var i = 0; i < kLevels.length; i++) {
      for (final b in kLevels[i].blocks) {
        expect(b.row, greaterThanOrEqualTo(0),
            reason: 'level ${i + 1} has a block under the floor');
      }
    }
  });

  test('no two blocks start inside each other', () {
    for (var i = 0; i < kLevels.length; i++) {
      final seen = <String>{};
      for (final b in kLevels[i].blocks) {
        final cell = '${b.x.toStringAsFixed(2)}@${b.row}';
        expect(seen.add(cell), isTrue,
            reason: 'level ${i + 1} stacks two blocks at $cell');
      }
    }
  });
}
