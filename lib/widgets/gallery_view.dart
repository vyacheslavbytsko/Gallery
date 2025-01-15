import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../boxes/media_box_v1.dart';
import '../misc.dart';
import 'dynamic_grid.dart';

class GalleryView extends StatefulWidget {
  final Future<LinkedHashMap<String, List<MediaV1>>> media;
  final String Function(int index) locationBuilder;

  const GalleryView({super.key, required this.media, required this.locationBuilder});

  @override
  State<StatefulWidget> createState() => _GalleryViewState();

}

class _GalleryViewState extends State<GalleryView> {
  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      right: true,
      top: false,
      left: false,
      bottom: false,
      sliver: ListenableBuilder(
        listenable: timelineChangeNotifier,
        builder: (BuildContext context, Widget? child) {
          return FutureBuilder(
            future: widget.media,
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
                                      print(widget.locationBuilder(media.indexOf(mediaOfThisDate[index])));
                                      context.push(widget.locationBuilder(media.indexOf(mediaOfThisDate[index])), extra: mediaOfThisDate[index].getMemoizedThumbnail());
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
            },
          );
        },
      ),
    );
  }

}