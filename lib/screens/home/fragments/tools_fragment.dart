import 'package:flutter/material.dart';

import '../home_app_bar.dart';

class HomeScreenToolsFragment extends StatefulWidget {
  const HomeScreenToolsFragment({super.key});

  @override
  State<HomeScreenToolsFragment> createState() => _HomeScreenToolsFragmentState();
}

class _HomeScreenToolsFragmentState extends State<HomeScreenToolsFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          slivers: [
            const HomeAppBar(title: "Tools & Settings"),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text("Tools & settings", style: Theme.of(context).textTheme.labelLarge, maxLines: 1, softWrap: false,),
                    ),
                  ]
              ),
            ),
          ]
      ),
    );
  }
}