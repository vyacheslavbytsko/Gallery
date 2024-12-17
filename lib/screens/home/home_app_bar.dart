import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  final bool floating;

  const HomeAppBar({super.key, required this.title, this.floating = false});

  @override
  Widget build(context) {
    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      child: SliverAppBar(
        scrolledUnderElevation: 3,
        title: Row(
          children: [
            /*if (MediaQuery.orientationOf(context) == Orientation.portrait) const Icon(Icons.landscape),
            if (MediaQuery.orientationOf(context) == Orientation.portrait) const SizedBox(width: 8),*/
            Text(title),
          ],
        ),
        floating: floating,
        pinned: !floating,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
