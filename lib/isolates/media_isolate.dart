import 'dart:isolate';

import 'package:photo_manager/photo_manager.dart';

import '../boxes/media_box.dart';
import '../misc.dart';


class MediaIsolate extends IsolateHandler {
  @override
  void main(ReceivePort mainReceivePort, SendPort isolateSendPort) {
    isolateSendPort.send("ping");
    mainReceivePort.listen((message) {
      List<String> args = message.split(".");
      var command = args.removeAt(0);
      switch(command) {
        case "pong":
          print("pong!");
          isolateSendPort.send("collect");
          break;
        case "collect":
          print("Isolate sent ${int.parse(args[0])}.");
          timelineChangeNotifier.updateTimeline();
          break;
        case "partial_collect":
          timelineChangeNotifier.updateTimeline();
          break;
      }
    });
  }

  @override
  Future<void> isolate(ReceivePort isolateReceivePort, SendPort mainSendPort) async {
    MediaBox mediaBox = await MediaBox.create();
    isolateReceivePort.listen((message) async {
      List<String> args = message.split(".");
      var command = args.removeAt(0);
      switch(command) {
        case "ping":
          print("ping...");
          mainSendPort.send("pong");
          break;
        case "collect":
          mainSendPort.send("collect.${await collectLocalMedia(mainSendPort, mediaBox)}");
          break;
      }
    });
  }
}

Future<int> collectLocalMedia(SendPort mainSendPort, MediaBox mediaBox) async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  if (!ps.hasAccess) {
    return 0;
  }
  final List<AssetPathEntity> folders = await PhotoManager.getAssetPathList(hasAll: false);
  if (folders.isEmpty) {
    return 0;
  }

  //final mediaDb = MediaDatabase();
  await mediaBox.dropLocalMedia();

  for(AssetPathEntity folder in folders) {
    int currentAssetsCount = 0;
    int totalAssetsCount = await folder.assetCountAsync;
    while(currentAssetsCount < totalAssetsCount) {
      final List<AssetEntity> rawAssets = await folder.getAssetListRange(
          start: currentAssetsCount,
          end: currentAssetsCount + 10
      );
      List<LocalMedia> assets = [];
      for(AssetEntity asset in rawAssets) {
        currentAssetsCount+=1;
        assets.add(LocalMedia(id: asset.id, folder: folder.name, modifiedAt: asset.modifiedDateTime));
        //await mediaBox.addLocalMedia(asset.id, folder.name, asset.modifiedDateTime);
        //await mediaDb.into(mediaDb.localMedia).insert(LocalMediaCompanion.insert(id: asset.id, name: "noname", modifiedAt: asset.modifiedDateTime));
      }
      await mediaBox.addAllLocalMedia(assets);
      mainSendPort.send("partial_collect");
    }
  }
  return mediaBox.localMediaLength();
  /*var path = paths.first;
  var totalEntitiesCount = await path.assetCountAsync;

  List<AssetEntity> total_entities = [];
  int currentEntitiesCount
  while(total_entities.length < totalEntitiesCount) {
    final List<AssetEntity> entities = await path.getAssetListRange(
        start: total_entities.length,
        end: total_entities.length + 100
    );
    total_entities.addAll(entities);
  }
  return total_entities.length;*/
}