import 'package:flutter/material.dart';

import 'home_screen.dart';

class HomeScreenSearchFragment extends StatefulWidget {
  const HomeScreenSearchFragment({super.key});

  @override
  State<HomeScreenSearchFragment> createState() => _HomeScreenSearchFragmentState();
}

class _HomeScreenSearchFragmentState extends State<HomeScreenSearchFragment> {
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
          title: const Text("Search"),
        ),
        body: CustomScrollView(
            slivers: [
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
        )
    );
  }
}