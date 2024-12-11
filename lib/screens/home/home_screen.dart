import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'fragments/library_fragment.dart';
import 'fragments/search_fragment.dart';
import 'fragments/timeline_fragment.dart';
import 'fragments/tools_fragment.dart';

StatefulShellRoute homeScreenRoute = StatefulShellRoute.indexedStack(
    builder: (BuildContext context, GoRouterState state,
        StatefulNavigationShell navigationShell) {
      return HomeScreen(navigationShell: navigationShell);
    },
    branches: List<StatefulShellBranch>.generate(
        destinations.length,
        (index) => shellBranchWithFragment(
            destinations[index].fragment, destinations[index].path)));

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.orientationOf(context) == Orientation.portrait
        ? Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
                elevation: 3,
                onDestinationSelected: (int index) => _onTap(context, index),
                selectedIndex: navigationShell.currentIndex,
                destinations: List.generate(
                    destinations.length,
                    (index) => NavigationDestination(
                        icon: destinations[index].icon,
                        label: destinations[index].label,
                        selectedIcon: destinations[index].selectedIcon))))
        : Scaffold(
            appBar: AppBar(
              elevation: 3,
              title: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.landscape),
                    SizedBox(width: 8),
                    Text("Beshence Gallery"),
                  ],
                ),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle_outlined, size: 32)),
                const SizedBox(width: 4),
              ],
            ),
            body: Row(
              children: [
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Material(
                      child: NavigationRail(
                        backgroundColor: ElevationOverlay.applySurfaceTint(Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.surfaceTint, 3),
                        extended: true,
                        labelType: NavigationRailLabelType.none,
                        selectedIndex: navigationShell.currentIndex,
                        onDestinationSelected: (int index) =>
                            _onTap(context, index),
                        destinations: List.generate(
                          destinations.length,
                          (index) => NavigationRailDestination(
                            icon: destinations[index].icon,
                            label: Text(destinations[index].label),
                            selectedIcon: destinations[index].selectedIcon,
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
                Expanded(child: navigationShell)
              ],
            ),
          );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

StatefulShellBranch shellBranchWithFragment(Widget fragment, String link) {
  return StatefulShellBranch(
    routes: <RouteBase>[
      GoRoute(
        path: link,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: fragment,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}

class Destination {
  final String label;
  final Icon icon;
  final Icon selectedIcon;
  final String path;
  final Widget fragment;

  const Destination(
      this.label, this.icon, this.selectedIcon, this.path, this.fragment);
}

List<Destination> destinations = const [
  Destination("Timeline", Icon(Icons.photo_outlined), Icon(Icons.photo),
      "/timeline", HomeScreenTimelineFragment()),
  Destination("Library", Icon(Icons.perm_media_outlined),
      Icon(Icons.perm_media), "/library", HomeScreenLibraryFragment()),
  Destination("Search", Icon(Icons.search_outlined), Icon(Icons.search),
      "/search", HomeScreenSearchFragment()),
  Destination("Tools", Icon(Icons.handyman_outlined), Icon(Icons.handyman),
      "/tools", HomeScreenToolsFragment())
];
