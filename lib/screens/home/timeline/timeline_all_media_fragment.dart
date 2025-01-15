import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../widgets/gallery_view.dart';
import '../home_screen.dart';

class HomeScreenTimelineAllMediaFragment extends StatefulWidget {
  const HomeScreenTimelineAllMediaFragment({super.key});

  @override
  State<HomeScreenTimelineAllMediaFragment> createState() => _HomeScreenTimelineAllMediaFragmentState();
}

class _HomeScreenTimelineAllMediaFragmentState extends State<HomeScreenTimelineAllMediaFragment> {
  @override
  Widget build(BuildContext context) {
    return HomeFragment(
      controlSafeArea: false,
      body: MediaQuery.removePadding(
        context: context,
        removeLeft: true,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              scrolledUnderElevation: 3,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 48,),
                  Text("All Media")
                ],
              ),
              centerTitle: true,
              floating: true,
              pinned: !true,
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {},
                  itemBuilder: (BuildContext context) {
                    return {"Settings"}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            GalleryView(
              media: () => mediaBox.getMediaDatedAsync(),
              locationBuilder: (index) => "/all/item/$index",
            )
          ],
        ),
      ),
    );
  }

}