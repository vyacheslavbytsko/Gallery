import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery/misc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../boxes/media_box_v1.dart';
import '../../main.dart';

class CarouselScreen extends StatefulWidget {
  final int itemIndex;
  final String path;
  const CarouselScreen({super.key, required this.itemIndex, required this.path});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    final mediaQuery = (context.getElementForInheritedWidgetOfExactType<MediaQuery>()!.widget as MediaQuery).data;
    controller = PageController(
        initialPage: widget.itemIndex,
      viewportFraction: 1 + (16 * 2 / mediaQuery.size.width)
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late Future future;
    // we get path from main.dart
    switch(widget.path.split(".")[0]) {
      case "timeline":
        future = mediaBox.getShownMediaSortedAsync();
        break;
      case "all":
        future = mediaBox.getMediaSortedAsync();
        break;
      case "localFolder":
        future = mediaBox.getLocalFolderMediaSortedAsync(mediaBox.getLocalFolder(widget.path.split(".")[1])!);
        break;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List<MediaV1> items = snapshot.requireData;
              return PageView.builder(
                physics: const CustomPageViewScrollPhysics(),
                /*onPageChanged: (value) => setState(() {
                  context.replace();
                }),*/
                itemCount: items.length,
                controller: controller,
                //allowImplicitScrolling: true,
                //preloadPagesCount: 2,
                itemBuilder: (context, index) {
                  print(index);
                  // TODO: https://github.com/octomato/preload_page_view/issues/7
                  //  https://pub.dev/packages/native_video_player
                  //  https://pub.dev/packages/media_kit
                  //  https://github.com/immich-app/immich/issues/5120
                  //  https://github.com/fluttercommunity/chewie
                  return FractionallySizedBox(
                    widthFactor: 1 / controller.viewportFraction,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        (index == widget.itemIndex && GoRouterState.of(context).extra != null)
                            ? Image.memory(
                            (GoRouterState.of(context).extra as Uint8List?)!, fit: BoxFit.contain
                        )
                            : FutureBuilder(
                            future: items[index].getThumbnail(tempDir: TemporaryDirectory.of(context).temp),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                    snapshot.requireData,
                                    fit: BoxFit.contain);
                              } else {
                                return const SizedBox.shrink();
                              }
                            }
                        ),

                        FutureBuilder(
                            future: AssetEntity(id: items[index].localId!, typeInt: items[index].localTypeInt!, width: items[index].width, height: items[index].height).originBytes,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                    snapshot.requireData!,
                                    fit: BoxFit.contain);
                              } else if (snapshot.hasError) {
                                return const Icon(Icons.error_outline);
                                //return Text("error ${mediaOfThisDate[index].name} ${mediaOfThisDate[index].date}");
                              } else {
                                return const SizedBox.shrink();
                                //return Text("loading ${mediaOfThisDate[index].name} ${mediaOfThisDate[index].date}");
                              }
                            }
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              if(GoRouterState.of(context).extra != null) {
                return SizedBox.expand(
                  child: Image.memory(
                    (GoRouterState
                        .of(context)
                        .extra as Uint8List?)!,
                    fit: BoxFit.contain,),
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          }
      ),
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({super.parent});

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 150,
    stiffness: 100,
    damping: 0.8,
  );
}
