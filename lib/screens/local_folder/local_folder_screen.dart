import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gallery/boxes/media_box_v1.dart';
import 'package:gallery/main.dart';
import 'package:gallery/misc.dart';

import '../../widgets/dynamic_grid.dart';

class LocalFolderScreen extends StatefulWidget {
  final LocalFolderV1 localFolder;

  const LocalFolderScreen({super.key, required this.localFolder});

  @override
  State<StatefulWidget> createState() => _LocalFolderScreenState();

}

class _LocalFolderScreenState extends State<LocalFolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.localFolder.name),
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
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 16
                    ),
                    onTap: () async {
                      setState(() {
                        widget.localFolder.show = !widget.localFolder.show;
                      });
                      await mediaBox.setLocalFolderAsync(widget.localFolder);
                    },
                    leading: const Icon(Icons.photo_outlined),
                    title: const Text("Show in Timeline"),
                    trailing: Switch(
                        padding: EdgeInsets.zero,
                        value: widget.localFolder.show,
                        onChanged: (value) async {
                          setState(() {
                            widget.localFolder.show = value;
                          });
                          await mediaBox.setLocalFolderAsync(widget.localFolder);
                        })
                ),
                ListTile(
                    enabled: widget.localFolder.show,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 16
                    ),
                    onTap: !widget.localFolder.show ? null : () async {
                      setState(() {
                        widget.localFolder.sync = !widget.localFolder.sync;
                      });
                      await mediaBox.setLocalFolderAsync(widget.localFolder);
                    },
                    leading: const Icon(Icons.cloud_outlined),
                    title: const Text("Back up and synchronise"),
                    trailing: Switch(
                        padding: EdgeInsets.zero,
                        value: widget.localFolder.show ? widget.localFolder.sync : false,
                        onChanged: !widget.localFolder.show ? null : (value) async {
                          setState(() {
                            widget.localFolder.sync = value;
                          });
                          await mediaBox.setLocalFolderAsync(widget.localFolder);
                        })
                ),
                const SizedBox(height: 8,),
              ]),
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
                    future: mediaBox.getLocalFolderMediaSortedAsync(widget.localFolder),
                    initialData: const [],
                    builder: (context, snapshot) {
                      late List<MediaV1> media;
                      if(snapshot.hasData) {
                        media = snapshot.requireData.cast<MediaV1>();
                      } else {
                        media = [];
                      }
                      return DynamicGridBuilderView(
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
                      );
                    },
                  );
                },
              ),
            ),
            SliverSafeArea(bottom: true, sliver: SliverList(delegate: SliverChildListDelegate([const SizedBox(height: 8)])))
          ],
        ),
      )
    );
  }

}