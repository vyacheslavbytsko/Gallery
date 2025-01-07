import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

import '../boxes/media_box_v1.dart';
import '../misc.dart';


class MediaIsolate extends IsolateHandler {
  @override
  void main(ReceivePort mainReceivePort, SendPort isolateSendPort) {
    mainReceivePort.listen((message) {
      List<String> args = message.split(".");
      var command = args.removeAt(0);
      switch(command) {
        case "pong":
          print("pong!");
          isolateSendPort.send("folders");
          break;
        case "folders":
          if(args[0] == "new") {
            localFoldersChangeNotifier.updateLocalFolders();
          }
          isolateSendPort.send("media");
          break;
        case "media":
          print(message);
          if(args[0] == "partial" || args[0] == "new") {
            timelineChangeNotifier.updateTimeline();
          }
          if(args[0] == "new" || args[0] == "noNew") {
            // go check new items
          }
          break;
        case "thumbnails":
          break;
        /*case "partial_collect":
          //print(message);
          timelineChangeNotifier.updateTimeline();
          break;*/
      }
    });
    isolateSendPort.send("ping");
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
        case "folders":
          final List<AssetPathEntity> pmFolders = await PhotoManager.getAssetPathList(hasAll: false);

          if (pmFolders.isEmpty) {
            mainSendPort.send("folders.noNew");
            return;
          }

          bool flag = false;
          for(AssetPathEntity folder in pmFolders) {
            LocalFolderV1? dbFolder = mediaBox.getLocalFolder(folder.id);
            if(dbFolder == null) {
              LocalFolderV1 newDbFolder = LocalFolderV1(
                  id: folder.id,
                  name: folder.name,
                  show: false,
                  sync: false
              );
              await mediaBox.addLocalFolderAsync(newDbFolder);
              flag = true;
            }
          }

          if(flag) {
            mainSendPort.send("folders.new");
          } else {
            mainSendPort.send("folders.noNew");
          }

          break;
        case "media":
          final Map<LocalFolderV1, AssetPathEntity> folders = {};

          List<LocalFolderV1> dbFolders = await mediaBox.getLocalFoldersAsync();
          List<AssetPathEntity> pmFolders = await PhotoManager.getAssetPathList(hasAll: false);
          List<MediaV1> dbAssets = await mediaBox.getLocalMediaAsync(); // we will use this
                                                                        // to delete no more known
                                                                        // items from database

          for(LocalFolderV1 dbFolder in dbFolders) {
            for(AssetPathEntity pmFolder in pmFolders) {
              if(dbFolder.id == pmFolder.id) {
                folders[dbFolder] = pmFolder;
                break;
              }
              pmFolders.remove(folders[dbFolder]);
            }
          }

          // clear lists as they will be no longer in use
          dbFolders = [];
          pmFolders = [];

          bool flag = false;

          for(MapEntry<LocalFolderV1, AssetPathEntity> entry in folders.entries) {
            LocalFolderV1 dbFolder = entry.key;
            AssetPathEntity pmFolder = entry.value;
            List<AssetEntity> pmFolderAssets;
            int offset = 0;
            //print(pmFolder);
            do {
              pmFolderAssets = await pmFolder.getAssetListRange(start: offset, end: offset+=100);
              List<MediaV1> toAdd = [];
              List<MediaV1> toHide = [];
              List<MediaV1> toShow = [];
              for(var pmFolderAsset in pmFolderAssets) {
                try {
                  // get corresponding db asset
                  MediaV1 dbFolderAsset = dbAssets.firstWhere((
                      dbAsset) => dbAsset.localId == pmFolderAsset.id);
                  // and remove from snapshot we made earlier
                  dbAssets.remove(dbFolderAsset);

                  //print("found. $dbFolderAsset $pmFolderAsset ${dbAssets.remove(dbFolderAsset)}");
                  // then dbAssets will have assets that are not on the device

                  if(dbFolder.show == false && dbFolderAsset.show == true) {
                    //print("and we will hide it.");
                    // user stated that they don't want to see items from this folder.
                    // this means this item should be removed from the db
                    toHide.add(dbFolderAsset);
                    //await mediaBox.removeMediaAsync(dbFolderAsset);
                    flag = true;
                  } else if(dbFolder.show == true && dbFolderAsset.show == false) {
                    //print("and we will show it.");
                    toShow.add(dbFolderAsset);
                    flag = true;
                  }
                } on StateError {
                  // dbFolderAsset is null, meaning we never knew about this asset
                  // we should add corresponding pmFolderAsset to the database
                  // but only if user stated that they want to see items from this folder
                  //if(dbFolder.show) {
                  MediaV1 dbFolderAsset = MediaV1(
                      id: const Uuid().v4(),
                      localId: pmFolderAsset.id,
                      localFolderId: pmFolder.id,
                      localModifiedAt: pmFolderAsset.modifiedDateTime,
                      name: await pmFolderAsset.titleAsyncWithSubtype,
                      type: pmFolderAsset.type == AssetType.image
                          ? "image"
                          : "video",
                      localTypeInt: pmFolderAsset.typeInt,
                      height: pmFolderAsset.height,
                      width: pmFolderAsset.width,
                      date: pmFolderAsset.modifiedDateTime,
                      show: dbFolder.show,
                      synced: false
                  );

                  //print("new. $dbFolderAsset $pmFolderAsset");
                  toAdd.add(dbFolderAsset);
                  //await mediaBox.addMediaAsync(dbFolderAsset);
                  flag = true;
                  //}
                }
              }
              if(toAdd.isNotEmpty) await mediaBox.addManyMediaAsync(toAdd);
              if(toHide.isNotEmpty) await mediaBox.hideManyMediaAsync(toHide);
              if(toShow.isNotEmpty) await mediaBox.showManyMediaAsync(toShow);
              //print("${toAdd.isNotEmpty} ${toHide.isNotEmpty} ${toShow.isNotEmpty}");
              if(toAdd.isNotEmpty || toHide.isNotEmpty || toShow.isNotEmpty) mainSendPort.send("media.partial");
            } while(pmFolderAssets.isNotEmpty);
          }

          // then we remove all untouched assets from db
          // **that are not synced**
          List<MediaV1> dbAssetsToMarkCloud = [];
          for(MediaV1 remainingAsset in dbAssets) {
            if(remainingAsset.synced == true) {
              dbAssets.remove(remainingAsset);
              dbAssetsToMarkCloud.add(remainingAsset);
            }
          }
          //print("dbAssetsToRemove ${dbAssets.length}");
          await mediaBox.removeManyMediaAsync(dbAssets);
          // TODO: await mediaBox.markManyMediaCloudAsync(dbAssetsToMarkCloud)

          print(mediaBox.mediaLength);
          mainSendPort.send("media.${flag ? "new" : "noNew"}");
      }
    });
  }
}

/*Future<int> collectLocalMedia(SendPort mainSendPort, MediaBox mediaBox) async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();
  if (!ps.hasAccess) {
    return 0;
  }
  final List<AssetPathEntity> folders = await PhotoManager.getAssetPathList(hasAll: false);
  if (folders.isEmpty) {
    return 0;
  }

  /*await mediaBox.dropLocalFolders();
  //await mediaBox.dropLocalMedia();

  for(AssetPathEntity folder in folders) {
    // first of all, we ensure that this folder is in database.
    await mediaBox.addLocalFolder(LocalFolder(id: folder.id, name: folder.name));

    // then we get all items of this folder from the database.
    // we need this to get the list of deleted assets
    Map<String, LocalMedia> knownDbAssets = await mediaBox.getAllAssetsOfLocalFolder(folder.id);

    // then we manipulate this list.
    int totalAssetsCount = await folder.assetCountAsync;
    int currentAssetsCount = 0;

    while(currentAssetsCount < totalAssetsCount) {
      // we get the portion of assets.
      final List<AssetEntity> rawAssets = await folder.getAssetListRange(
          start: currentAssetsCount,
          end: currentAssetsCount + 100
      );
      currentAssetsCount+=rawAssets.length;

      // and we create lists to work with.
      List<AssetEntity> newAssets = [];
      List<AssetEntity> modifiedAssets = [];

      for(AssetEntity asset in rawAssets) {
        // check if everything is okay with this asset:
        // more specifically, this asset was not changed.

        // 1. check if asset is present in the db.
        LocalMedia? knownDbAsset = knownDbAssets.remove(asset.id);

        if (knownDbAsset == null) {
          newAssets.add(asset);
          continue;
        }

        // 2. check if asset was not modified by looking at its modified date
        if(knownDbAsset.modifiedAt != asset.modifiedDateTime) {
          modifiedAssets.add(asset);
        }
      }

      // 3. now we handle all the changes.
      List<LocalMedia> newDbAssets = [];
      for(AssetEntity newAsset in newAssets) {
        newDbAssets.add(LocalMedia(id: newAsset.id, folder: folder.id, modifiedAt: newAsset.modifiedDateTime, filePath: (await newAsset.loadFile())!.path));
      }
      await mediaBox.addAllLocalMedia(newDbAssets);

      List<LocalMedia> modifiedDbAssets = [];
      for(AssetEntity modifiedAsset in modifiedAssets) {
        modifiedDbAssets.add(LocalMedia(id: modifiedAsset.id, folder: folder.id, modifiedAt: modifiedAsset.modifiedDateTime, filePath: (await modifiedAsset.loadFile())!.path));
      }
      await mediaBox.updateAllLocalMedia(modifiedDbAssets);

      if(newAssets.length + modifiedAssets.length > 0) {
        mainSendPort.send("partial_collect.1 ${folder.name}: ${newAssets.length} ${modifiedAssets.length}");
      }
    }

    // 4. after partially adding/updating assets of this folder,
    // we should delete all assets that are removed from the device
    // in one db request. they are located in knownDbAssets
    List<LocalMedia> deletedDbAssets = knownDbAssets.values.toList();
    await mediaBox.deleteAllLocalMedia(deletedDbAssets);
    if (deletedDbAssets.isNotEmpty) {
      mainSendPort.send("partial_collect.2 ${folder.name}: ${deletedDbAssets.length}");
    }

    // it is all for now for this folder! moving on to the next one.
  }
  return mediaBox.localMediaLength();*/
}*/