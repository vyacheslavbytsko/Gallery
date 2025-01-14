import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../boxes/media_box_v1.dart';
import '../../main.dart';
import '../../misc.dart';
import '../../widgets/dynamic_grid.dart';
import '../../widgets/wavy_divider.dart';
import 'home_screen.dart';

class HomeScreenTimelineFragment extends StatefulWidget {
  const HomeScreenTimelineFragment({super.key});

  @override
  State<HomeScreenTimelineFragment> createState() => _HomeScreenTimelineFragmentState();
}

class _HomeScreenTimelineFragmentState extends State<HomeScreenTimelineFragment> {
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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                      width: 16 /*button*/ + 4 /*padding next to button*/ +
                          32 /*idk*/),
                  const Text("Beshence Gallery"),
                  const SizedBox(width: 12,),
                  Icon(Icons.cloud_off_outlined, size: 16, color: Theme
                      .of(context)
                      .colorScheme
                      .secondary,)
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
            if(false) SliverSafeArea(
              right: true,
              top: false,
              left: false,
              bottom: false,
              sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)
                        ),
                        color: ElevationOverlay.applySurfaceTint(
                            Theme
                                .of(context)
                                .colorScheme
                                .surface,
                            Theme
                                .of(context)
                                .colorScheme
                                .surfaceTint,
                            3
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .stretch,
                          children: [
                            Card(
                                margin: EdgeInsets.zero,
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(32),
                                      topRight: Radius.circular(32),
                                    )
                                ),
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton.filled(
                                                  onPressed: null,
                                                  icon: Icon(
                                                    Icons.landscape,
                                                    color: Theme
                                                        .of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  )),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 16,),
                                          Text.rich(
                                              const TextSpan(
                                                  text: "Welcome!"
                                              ),
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                color: Theme
                                                    .of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              )
                                          ),
                                          const SizedBox(
                                            width: 16,),
                                          IconButton(
                                            tooltip: "Hide suggestions",
                                            icon: const Icon(
                                                Icons.close),
                                            onPressed: () => {},
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .onPrimary,
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 4,
                                            vertical: 12),
                                        child: Text(
                                            "There are some things that need to be set up to ensure the best experience:",
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                color: Theme
                                                    .of(context)
                                                    .colorScheme
                                                    .onPrimary
                                            ),
                                            textAlign: TextAlign
                                                .start),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            WavyDivider(
                              color: ElevationOverlay
                                  .applySurfaceTint(
                                  Theme
                                      .of(context)
                                      .colorScheme
                                      .surface,
                                  Theme
                                      .of(context)
                                      .colorScheme
                                      .surfaceTint,
                                  0
                              ),
                              height: 2,
                              wavelength: 32,
                              width: 4,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  key: const Key("suggestions"),
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    IconButton.filled(
                                      onPressed: null,
                                      icon: const Icon(Icons
                                          .photo_library_outlined),
                                      disabledColor: Theme
                                          .of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    /*Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Icon(Icons.photo_library_outlined, color: Theme.of(context).colorScheme.onSurface),
                                                ),*/
                                    const SizedBox(width: 16),
                                    const Expanded(child: Text(
                                        "Give access to your photos and videos",
                                        softWrap: true)),
                                    const SizedBox(width: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .end,
                                      children: [
                                        IconButton(icon: const Icon(
                                            Icons.close),
                                            onPressed: () =>
                                            {
                                            } /*setState(() => suggestions.remove("account"))*/),
                                        const SizedBox(width: 4),
                                        IconButton.filled(
                                            onPressed: () => {},
                                            icon: const Icon(Icons
                                                .navigate_next))
                                      ],
                                    )
                                  ],
                                )
                            ),
                            Container(
                              color: ElevationOverlay
                                  .applySurfaceTint(
                                  Theme
                                      .of(context)
                                      .colorScheme
                                      .surface,
                                  Theme
                                      .of(context)
                                      .colorScheme
                                      .surfaceTint,
                                  0
                              ),
                              width: double.infinity,
                              height: 4,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    IconButton.filled(
                                      onPressed: null,
                                      icon: const Icon(
                                          Icons.visibility_outlined),
                                      disabledColor: Theme
                                          .of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(child: Text(
                                        "Choose which folders to show in timeline",
                                        softWrap: true)),
                                    const SizedBox(width: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .end,
                                      children: [
                                        IconButton(icon: const Icon(
                                            Icons.close),
                                            onPressed: () =>
                                            {
                                            } /*setState(() => suggestions.remove("account"))*/),
                                        const SizedBox(width: 4),
                                        IconButton.filled(
                                            onPressed: () => {},
                                            icon: const Icon(Icons
                                                .navigate_next))
                                      ],
                                    )
                                  ],
                                )
                            ),
                            Container(
                              color: ElevationOverlay
                                  .applySurfaceTint(
                                  Theme
                                      .of(context)
                                      .colorScheme
                                      .surface,
                                  Theme
                                      .of(context)
                                      .colorScheme
                                      .surfaceTint,
                                  0
                              ),
                              width: double.infinity,
                              height: 4,
                            ),
                            Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    IconButton.filled(
                                      onPressed: null,
                                      icon: const Icon(
                                          Icons.cloud_outlined),
                                      disabledColor: Theme
                                          .of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(child: Text(
                                        "Turn on media backup and synchronisation",
                                        softWrap: true)),
                                    const SizedBox(width: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .end,
                                      children: [
                                        IconButton(icon: const Icon(
                                            Icons.close),
                                            onPressed: () =>
                                            {
                                            } /*setState(() => suggestions.remove("account"))*/),
                                        const SizedBox(width: 4),
                                        IconButton.filled(
                                            onPressed: () => {},
                                            icon: const Icon(Icons
                                                .navigate_next))
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])
              )
            ),
            SliverSafeArea(
              right: true,
              top: false,
              left: false,
              bottom: false,
              sliver: ListenableBuilder(
                listenable: timelineChangeNotifier,
                builder: (BuildContext context, Widget? child) {
                  return FutureBuilder(
                    future: mediaBox.getShownMediaDatedAsync(),
                    builder: (context, snapshot) {
                      late LinkedHashMap<String, List<MediaV1>> datesAndMedia;
                      late List<String> dates;
                      late List<MediaV1> media;
                      if(snapshot.hasData) {
                        datesAndMedia = snapshot.requireData;
                        dates = datesAndMedia.keys.toList();
                        media = datesAndMedia.values.expand((list) => list).toList();
                      } else {
                       datesAndMedia = LinkedHashMap<String, List<MediaV1>>();
                       dates = [];
                       media = [];
                      }
                      return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            childCount: dates.length,
                            (context, datesIndex) {
                              DateTime date = internalFormatter.parse(dates[datesIndex]);
                              DateTime dateYear = DateTime(date.year);
                              List<MediaV1> mediaOfThisDate = datesAndMedia[dates[datesIndex]]!;
                              String dateTitle = dates[datesIndex];

                              final now = DateTime.now();
                              final today = DateTime(now.year, now.month, now.day);
                              final yesterday = DateTime(now.year, now.month, now.day - 1);
                              final thisYear = DateTime(now.year);
                              //final tomorrow = DateTime(now.year, now.month, now.day + 1);
                              final List months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
                              final List weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                              if(date == today) dateTitle = "Today";
                              else if(date == yesterday) dateTitle = "Yesterday";
                              else {
                                if(dateYear != thisYear) dateTitle = "${weekDays[date.weekday-1]}, ${months[date.month-1]} ${date.day}, ${date.year}";
                                else dateTitle = "${weekDays[date.weekday-1]}, ${months[date.month-1]} ${date.day}";
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                        child: Text(dateTitle, style: Theme.of(context).textTheme.titleMedium/*?.copyWith(fontWeight: FontWeight.bold)*/, maxLines: 1, softWrap: false,),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4),
                                        child: IconButton(onPressed: () {}, icon: const Icon(Icons.check_circle_outline)),
                                      )
                                    ],
                                  ),
                                  DynamicGridBuilderView(
                                    itemCount: mediaOfThisDate.length,
                                    maxWidthOnPortrait: 100,
                                    maxWidthOnLandscape: 150,
                                    sliver: false,
                                    spaceBetween: 2,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        /*color: Color.fromARGB(
                                            255, Random().nextInt(255),
                                            Random.secure().nextInt(255),
                                            Random().nextInt(255)
                                        ),*/
                                        color: Theme.of(context).colorScheme.primaryContainer,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            FutureBuilder(
                                              future: mediaOfThisDate[index].getThumbnail(tempDir: TemporaryDirectory.of(context).temp),
                                              builder: (context, snapshot) {
                                                if(snapshot.hasData) {
                                                  return Image.memory(
                                                      snapshot.requireData,
                                                      fit: BoxFit.cover);
                                                } else if(snapshot.hasError) {
                                                  return const Icon(Icons.error_outline);
                                                  //return Text("error ${mediaOfThisDate[index].name} ${mediaOfThisDate[index].date}");
                                                } else {
                                                  return const SizedBox.shrink();
                                                  //return Text("loading ${mediaOfThisDate[index].name} ${mediaOfThisDate[index].date}");
                                                }
                                              }
                                            ),
                                            GestureDetector(onTap: () {
                                              print("/item/${media.indexOf(mediaOfThisDate[index])}");
                                              context.push("/item/${media.indexOf(mediaOfThisDate[index])}", extra: mediaOfThisDate[index].getMemoizedThumbnail());
                                            })
                                          ]
                                        ),
                                      );
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                      );
                      /*return DynamicGridBuilderView(
                        itemCount: snapshot.requireData.length,
                        maxWidthOnPortrait: 100,
                        maxWidthOnLandscape: 150,
                        sliver: true,
                        spaceBetween: 2,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Color.fromARGB(
                                255, Random().nextInt(255),
                                Random.secure().nextInt(255),
                                Random().nextInt(255)
                            ),
                            child: FutureBuilder(
                                future: media[index].ensureThumbnail(tempDir: TemporaryDirectory.of(context).temp),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData) {
                                    return Image.memory(
                                        File("${TemporaryDirectory.of(context).temp.path}/thumbnails/${media[index].id}.jpg").readAsBytesSync(),
                                        fit: BoxFit.cover);
                                  } else if(snapshot.hasError) {
                                    return Text("error ${media[index].name} ${media[index].date}");
                                  } else {
                                    return Text("loading ${media[index].name} ${media[index].date}");
                                  }
                                }
                            ),
                          );
                        },
                      );*/
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}