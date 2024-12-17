import 'dart:async';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/screens/home/home_screen.dart';
import 'package:gallery/screens/settings/settings_screen.dart';
import 'package:go_router/go_router.dart';

import 'boxes/media_box.dart';
import 'isolates/media_isolate.dart';

late MediaBox mediaBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  mediaBox = await MediaBox.create();

  MediaIsolate().start();

  runApp(const MyApp());
}

GoRouter router = GoRouter(
  initialLocation: "/timeline",
  routes: [
    homeScreenRoute,
    GoRoute(
      path: "/settings",
      builder: (context, state) => const SettingsScreen()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent));

    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme lightColorScheme = lightDynamic?.harmonized() ??
              ColorScheme.fromSeed(seedColor: Colors.green);
          ColorScheme darkColorScheme = darkDynamic?.harmonized() ??
              ColorScheme.fromSeed(
                  seedColor: Colors.green, brightness: Brightness.dark);
          return MaterialApp.router(
            routerConfig: router,
            title: 'Gallery',
            theme: ThemeData(colorScheme: lightColorScheme),
            darkTheme: ThemeData(colorScheme: darkColorScheme),
            themeMode: ThemeMode.system,
          );
        });
  }
}