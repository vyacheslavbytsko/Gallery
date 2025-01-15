import 'package:flutter/material.dart';
import 'package:gallery/screens/home/timeline/timeline_all_media_fragment.dart';
import 'package:gallery/screens/home/timeline/timeline_timeline_fragment.dart';
import 'package:go_router/go_router.dart';

import 'library_fragment.dart';
import 'search_fragment.dart';
import 'timeline/timeline_fragment.dart';
import 'tools_fragment.dart';

StatefulShellRoute homeScreenRoute = StatefulShellRoute.indexedStack(
    builder: (BuildContext context, GoRouterState state,
        StatefulNavigationShell navigationShell) {
      return HomeScreen(navigationShell: navigationShell);
    },
    branches: List<StatefulShellBranch>.generate(
        destinations.length,
        (index) {
          if(destinations[index].timeline) {
            return StatefulShellBranch(
                routes: [
                  StatefulShellRoute.indexedStack(
                      builder: (BuildContext context, GoRouterState state,
                          StatefulNavigationShell timelineNavigationShell) {
                        return HomeScreenTimelineFragment(navigationShell: timelineNavigationShell);
                      },
                      branches: [
                        StatefulShellBranch(
                            routes: [
                              GoRoute(
                                path: "/",
                                pageBuilder: (context, state) {
                                  return CustomTransitionPage(
                                    key: state.pageKey,
                                    child: const HomeScreenTimelineTimelineFragment(),
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
                              )
                            ]
                        ),
                        StatefulShellBranch(
                            routes: [
                              GoRoute(
                                path: "/all",
                                pageBuilder: (context, state) {
                                  return CustomTransitionPage(
                                    key: state.pageKey,
                                    child: const HomeScreenTimelineAllMediaFragment(),
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
                              )
                            ]
                        )
                      ]
                  )
                ]
            );
          } else {
            return StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  path: destinations[index].path,
                  pageBuilder: (context, state) {
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: destinations[index].fragment!,
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
        })
);

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.orientationOf(context) == Orientation.portrait) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
            backgroundColor: ElevationOverlay.applySurfaceTint(
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surfaceTint,
                3),
            onDestinationSelected: (int index) => _onTap(context, index),
            selectedIndex: navigationShell.currentIndex,
            destinations: List.generate(
                destinations.length, (index) => NavigationDestination(
                    icon: destinations[index].icon,
                    label: destinations[index].label,
                    selectedIcon: destinations[index].selectedIcon
                )
            )
        ),
      );
    } else {
      return Scaffold(
        body: Row(
          children: [
            Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: kToolbarHeight,),
                      Flexible(
                        fit: FlexFit.tight,
                        child: NavigationRail(
                          backgroundColor: ElevationOverlay.applySurfaceTint(
                              Theme.of(context).colorScheme.surface,
                              Theme.of(context).colorScheme.surfaceTint,
                              3),
                          labelType: NavigationRailLabelType.selected,
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
                    ],
                  ),
                  Container(
                    color: ElevationOverlay.applySurfaceTint(
                        Theme.of(context).colorScheme.surface,
                        Theme.of(context).colorScheme.surfaceTint,
                        3),
                    height: MediaQuery.of(context).padding.top + kToolbarHeight,
                    width: MediaQuery.of(context).padding.left + 80,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top, left: MediaQuery.of(context).padding.left),
                        child: const Icon(Icons.landscape)),
                  ),
                ]
            ),
            Expanded(
                child: SafeArea(
                    top: false,
                    bottom: false,
                    left: false,
                    right: false,
                    child: navigationShell
                )
            )
          ],
        ),
      );
    }
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class Destination {
  final String label;
  final Icon icon;
  final Icon selectedIcon;
  final String path;
  final Widget? fragment;
  final bool timeline;

  const Destination(
      this.label, this.icon, this.selectedIcon, this.path, this.fragment, {this.timeline = false});
}

List<Destination> destinations = const [
  Destination("Timeline", Icon(Icons.photo_outlined), Icon(Icons.photo),
      "/", null, timeline: true),
  Destination("Library", Icon(Icons.perm_media_outlined),
      Icon(Icons.perm_media), "/library", HomeScreenLibraryFragment()),
  Destination("Search", Icon(Icons.search_outlined), Icon(Icons.search),
      "/search", HomeScreenSearchFragment()),
  Destination("Tools", Icon(Icons.handyman_outlined), Icon(Icons.handyman),
      "/tools", HomeScreenToolsFragment())
];

class HomeFragment extends StatelessWidget {
  final Widget? appBar;
  final Widget? body;
  final bool controlSafeArea;

  const HomeFragment({super.key, this.appBar, this.body, this.controlSafeArea = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar != null ? PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MediaQuery.removePadding(
          context: context,
          removeLeft: true,
          child: appBar!
        ),
      ) : null,
      body: controlSafeArea ? SafeArea(
        top: false,
        left: false,
        right: true,
        bottom: false,
        child: body != null ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            removeRight: true,
            removeLeft: true,
            child: body != null ? body! : const SizedBox.shrink()
        ) : const SizedBox.shrink()
      ) : MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          removeRight: true,
          removeLeft: true,
          child: body != null ? body! : const SizedBox.shrink()
      )
    );
  }

}
