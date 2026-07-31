import 'package:flutter/material.dart';

import 'app.dart';
import 'levels.dart';
import 'save_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load saved progress, but never let storage block startup: if it throws or
  // stalls, fall back to an in-memory store and run anyway.
  SaveStore store;
  try {
    store = await SaveStore.load(kLevels.length)
        .timeout(const Duration(seconds: 4));
  } catch (_) {
    store = SaveStore.empty(kLevels.length);
  }
  runApp(ToppleApp(store: store));
}
