import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Map<int, String> locations = {0: "/", 1: "/all"};

class HomeScreenTimelineFragment extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreenTimelineFragment({super.key, required this.navigationShell});

  @override
  State<HomeScreenTimelineFragment> createState() => _HomeScreenTimelineFragmentState();
}

class _HomeScreenTimelineFragmentState extends State<HomeScreenTimelineFragment> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.navigationShell,
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            bottom: MediaQuery.of(context).orientation == Orientation.landscape ? true : false,
            left: false,
            right: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioButton(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)
                      ),
                      text: "Timeline",
                      groupValue: widget.navigationShell.currentIndex,
                      value: 0,
                      onTap: (newValue) => context.go(locations[newValue]!)
                  ),
                  RadioButton(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)
                      ),
                      text: "All media",
                      groupValue: widget.navigationShell.currentIndex,
                      value: 1,
                      onTap: (newValue) => context.go(locations[newValue]!)
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class RadioButton extends StatelessWidget {
  final BorderRadius borderRadius;
  final int value;
  final int groupValue;
  final String text;
  final ValueChanged<int> onTap;

  RadioButton({
    required this.borderRadius,
    required this.value,
    required this.groupValue,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        width: 112,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: ElevationOverlay.applySurfaceTint(isSelected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surfaceTint, 3),
          borderRadius: borderRadius,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}