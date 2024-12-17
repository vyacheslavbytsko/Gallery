import 'package:flutter/material.dart';

import '../home_app_bar.dart';

class HomeScreenSearchFragment extends StatefulWidget {
  const HomeScreenSearchFragment({super.key});

  @override
  State<HomeScreenSearchFragment> createState() => _HomeScreenSearchFragmentState();
}

class _HomeScreenSearchFragmentState extends State<HomeScreenSearchFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          slivers: [
            const HomeAppBar(title: "Search"),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text("Search", style: Theme.of(context).textTheme.labelLarge, maxLines: 1, softWrap: false,),
                    ),
                  ]
              ),
            ),
          ]
      ),
    );
  }
}