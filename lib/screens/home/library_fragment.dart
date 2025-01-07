import 'package:flutter/material.dart';
import 'package:gallery/main.dart';
import 'package:go_router/go_router.dart';

import '../../misc.dart';
import 'home_screen.dart';

class HomeScreenLibraryFragment extends StatefulWidget {
  const HomeScreenLibraryFragment({super.key});

  @override
  State<HomeScreenLibraryFragment> createState() => _HomeScreenLibraryFragmentState();
}

class _HomeScreenLibraryFragmentState extends State<HomeScreenLibraryFragment> {
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
          title: const Text("Library"),
        ),
        body: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 0, left: 16, right: 16),
                        child: Text("Device folders", style: Theme.of(context).textTheme.labelLarge, maxLines: 1, softWrap: false,),
                      ),
                      ListenableBuilder(
                          listenable: localFoldersChangeNotifier,
                          builder: (BuildContext context, Widget? child) {
                            return FutureBuilder(
                                future: mediaBox.getLocalFoldersAsync(),
                                builder: (BuildContext context, snapshot) {
                                  List<Widget> foldersAsWidgets = <Widget>[];
                                  if(snapshot.hasData) {
                                    for(var folder in snapshot.requireData) {
                                      foldersAsWidgets.add(
                                        SizedBox(
                                          height: 128,
                                          width: 128+8+8,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Card(
                                                  color: Theme
                                                      .of(context)
                                                      .colorScheme
                                                      .primary,
                                                  margin: EdgeInsets.zero,
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(16),
                                                    onTap: () => context.push("/localFolder/${folder.id}"),
                                                    child: const SizedBox(
                                                      width: 128,
                                                      height: 128,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8,),
                                                Text(
                                                  folder.name,
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.fade,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      );
                                    }
                                  }
                                  return SizedBox(
                                    height: 188,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: flatten([
                                        const SizedBox(width: 8,),
                                        foldersAsWidgets,
                                        const SizedBox(width: 8,)
                                      ])
                                    ),
                                  );
                                  /*return Column(
                                    children: foldersAsWidgets,
                                  );*/
                                }
                            );
                          }
                      ),
                      const SizedBox(height: 10000,)
                    ]
                ),
              ),
            ]
        )
    );
  }
}