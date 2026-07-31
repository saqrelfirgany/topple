import 'package:flutter/material.dart';

import 'app.dart';
import 'levels.dart';
import 'save_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await SaveStore.load(kLevels.length);
  runApp(ToppleApp(store: store));
}
