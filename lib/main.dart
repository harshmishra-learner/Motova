import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'app/theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MotovaApp());
}

class MotovaApp extends StatelessWidget {
  const MotovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Motova',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}