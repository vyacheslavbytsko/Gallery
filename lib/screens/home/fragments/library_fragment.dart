import 'package:flutter/material.dart';

import '../home_app_bar.dart';

class HomeScreenLibraryFragment extends StatefulWidget {
  const HomeScreenLibraryFragment({super.key});

  @override
  State<HomeScreenLibraryFragment> createState() => _HomeScreenLibraryFragmentState();
}

class _HomeScreenLibraryFragmentState extends State<HomeScreenLibraryFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          slivers: [
            if(MediaQuery.orientationOf(context) == Orientation.portrait) const HomeAppBar(title: "Library"),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Text("Albums on device", style: Theme.of(context).textTheme.labelLarge, maxLines: 1, softWrap: false,),
                    ),
                  ]
              ),
            ),
          ]
      ),
    );
  }
}