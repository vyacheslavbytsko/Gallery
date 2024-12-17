import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery/boxes/media_box.dart';
import 'package:gallery/main.dart';
import 'package:gallery/misc.dart';

import '../../../widgets/dynamic_grid.dart';
import '../../../widgets/suggestion.dart';
import '../home_app_bar.dart';

class HomeScreenTimelineFragment extends StatefulWidget {
  const HomeScreenTimelineFragment({super.key});

  @override
  State<HomeScreenTimelineFragment> createState() => _HomeScreenTimelineFragmentState();
}

class _HomeScreenTimelineFragmentState extends State<HomeScreenTimelineFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
              slivers: [
                HomeAppBar(title: "Timeline", floating: MediaQuery.orientationOf(context) == Orientation.portrait),
                ListenableBuilder(
                  listenable: timelineChangeNotifier,
                  builder: (BuildContext context, Widget? child) {
                    return FutureBuilder(
                      future: mediaBox.getAllLocalMediaSorted(),
                      initialData: [],
                      builder: (context, snapshot) {
                        List<Widget> localItems = <Widget>[];
                        if(snapshot.hasData) {
                          for(LocalMedia item in snapshot.data!) {
                            localItems.add(Container(child: Text("${item.id}\n${item.modifiedAt}"),));
                          }
                        }
                        return SliverList(
                            delegate: SliverChildListDelegate(
                                flatten([
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          DynamicGridView(
                                              maxWidthOnPortrait: 300,
                                              maxWidthOnLandscape: 400,
                                              sliver: false,
                                              height: const DynamicGridViewHeight.fixed(84),
                                              spaceBetween: 16,
                                              children: [
                                                if (/*suggestions.contains("permission")*/true) Suggestion(
                                                    icon: Icon(Icons.lightbulb_outlined, color: Theme.of(context).textTheme.bodySmall?.color),
                                                    title: "Give access to your photos and videos",
                                                    button: IconButton.filled(onPressed: () => {}, icon: const Icon(Icons.navigate_next)),
                                                    cancelButton: IconButton(icon: const Icon(Icons.close), onPressed: () => {}/*setState(() => suggestions.remove("permission"))*/)
                                                ),
                                                if(/*suggestions.contains("account")*/true) Suggestion(
                                                    icon: Icon(Icons.lightbulb_outlined, color: Theme.of(context).textTheme.bodySmall?.color),
                                                    title: "Sign in to synchronise",
                                                    button: IconButton.filled(onPressed: () => {}, icon: const Icon(Icons.navigate_next)),
                                                    cancelButton: IconButton(icon: const Icon(Icons.close), onPressed: () => {}/*setState(() => suggestions.remove("account"))*/)
                                                ),
                                              ]
                                          ),
                                          const SizedBox(height: 16)
                                        ]
                                    ),
                                  ),
                                  DynamicGridView(
                                      maxWidthOnPortrait: 100,
                                      maxWidthOnLandscape: 150,
                                      sliver: false,
                                      spaceBetween: 2,
                                      children: List.generate(
                                          localItems.length, (index) =>
                                          Container(
                                            child: localItems[index],
                                              color: Color.fromARGB(255, Random().nextInt(255), Random.secure().nextInt(255), Random().nextInt(255)
                                              )
                                          )
                                      ))
                                  /*List.generate(localItems.length, (index) => [, ])]),
                                  localItems*/
                                ])
                                  //List.generate(100, (index) => ).cast()
                            )
                        );
                      },
                    );
                  },
                ),
              ]
          ),
        ],
      ),
    );
  }
}