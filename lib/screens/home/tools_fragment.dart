import 'package:flutter/material.dart';

import 'home_screen.dart';

class HomeScreenToolsFragment extends StatefulWidget {
  const HomeScreenToolsFragment({super.key});

  @override
  State<HomeScreenToolsFragment> createState() => _HomeScreenToolsFragmentState();
}

class _HomeScreenToolsFragmentState extends State<HomeScreenToolsFragment> {
  @override
  Widget build(BuildContext context) {
    return HomeFragment(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
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
          centerTitle: true,
          title: const Text("Tools & Settings"),
        ),
        body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text("Tools & Settings", style: Theme.of(context).textTheme.labelLarge, maxLines: 1, softWrap: false,),
                      ),
                    ]
                ),
              ),
            ]
        )
    );
  }
}