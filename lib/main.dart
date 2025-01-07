import 'dart:async';
import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery/screens/home/home_screen.dart';
import 'package:gallery/screens/local_folder/local_folder_screen.dart';
import 'package:gallery/screens/settings/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'boxes/media_box_v1.dart';
import 'isolates/media_isolate.dart';
import 'misc.dart';

late MediaBox mediaBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  mediaBox = await MediaBox.create();

  MediaIsolate().start();

  Directory temp = await getTemporaryDirectory();
  runApp(TemporaryDirectory(
    temp: temp,
    child: const MyApp(),
  ));
}

GoRouter router = GoRouter(
  initialLocation: "/",
  routes: [
    homeScreenRoute,
    GoRoute(
      path: "/settings",
      builder: (context, state) => const SettingsScreen()),
    GoRoute(
      path: "/localFolder/:localFolderId",
      builder: (context, state) => LocalFolderScreen(localFolder: (mediaBox.getLocalFolder(state.pathParameters["localFolderId"]!))!)
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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