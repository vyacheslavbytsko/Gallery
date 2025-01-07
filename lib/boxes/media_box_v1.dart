import 'dart:io';
import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

import '../objectbox.g.dart';

class MediaBox {
  late final Store _store;
  late final Box<MediaV1> _mediaBox;
  late final Box<LocalFolderV1> _localFoldersBox;
  late final Query<MediaV1> _localMediaSyncedIsNull;
  late final Query<MediaV1> _localMediaSyncedIsTrue;
  late final Query<MediaV1> _localMediaSyncedIsFalse;
  late final Query<MediaV1> _mediaSorted;
  late final Query<MediaV1> _shownMediaSorted;

  MediaBox._create(this._store) {
    _mediaBox = Box<MediaV1>(_store);
    _localFoldersBox = Box<LocalFolderV1>(_store);
    _localMediaSyncedIsNull = (_mediaBox.query(MediaV1_.localId.notNull())).build();
    _localMediaSyncedIsFalse = (_mediaBox.query(MediaV1_.localId.notNull().and(MediaV1_.synced.equals(false)))).build();
    _localMediaSyncedIsTrue = (_mediaBox.query(MediaV1_.localId.notNull().and(MediaV1_.synced.equals(true)))).build();
    _mediaSorted = (_mediaBox.query()..order(MediaV1_.date, flags: Order.descending)).build();
    _shownMediaSorted = (_mediaBox.query(MediaV1_.show.equals(true))..order(MediaV1_.date, flags: Order.descending)).build();
  }

  static Future<MediaBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final storeDir = join(docsDir.path, "gallery_mediabox_v1");
    final Store store;
    if (Store.isOpen(storeDir)) {
      store = Store.attach(getObjectBoxModel(), storeDir);
    } else {
      store = await openStore(directory: storeDir);
    }
    return MediaBox._create(store);
  }

  Future<void> addLocalFolderAsync(LocalFolderV1 folder) => _localFoldersBox.putAsync(folder, mode: PutMode.insert);
  Future<List<LocalFolderV1>> getLocalFoldersAsync() => _localFoldersBox.getAllAsync();
  Future<void> setLocalFolderAsync(LocalFolderV1 folder) => _localFoldersBox.putAsync(folder, mode: PutMode.update);
  Future<LocalFolderV1?> getLocalFolderAsync(String id) => (_localFoldersBox.query(LocalFolderV1_.id.equals(id))).build().findFirstAsync();
  LocalFolderV1? getLocalFolder(String id) => (_localFoldersBox.query(LocalFolderV1_.id.equals(id))).build().findFirst();
  Future<List<MediaV1>> getLocalFolderMediaAsync(LocalFolderV1 folder) => (_mediaBox.query(MediaV1_.localFolderId.equals(folder.id))).build().findAsync();
  Future<List<MediaV1>> getLocalFolderMediaSortedAsync(LocalFolderV1 folder) => (_mediaBox.query(MediaV1_.localFolderId.equals(folder.id))..order(MediaV1_.date, flags: Order.descending)).build().findAsync();

  Future<List<MediaV1>> getLocalMediaAsync() => _localMediaSyncedIsNull.findAsync();
  Future<List<MediaV1>> getLocalSyncedMediaAsync() => _localMediaSyncedIsTrue.findAsync();
  Future<List<MediaV1>> getLocalNotSyncedMediaAsync() => _localMediaSyncedIsFalse.findAsync();
  Future<List<MediaV1>> getMediaSortedAsync() => _mediaSorted.findAsync();
  Future<List<MediaV1>> getShownMediaSortedAsync() => _shownMediaSorted.findAsync();
  Future<void> addMediaAsync(MediaV1 media) => _mediaBox.putAsync(media, mode: PutMode.insert);
  Future<void> addManyMediaAsync(List<MediaV1> media) => _mediaBox.putManyAsync(media, mode: PutMode.insert);
  Future<void> removeMediaAsync(MediaV1 media) => _mediaBox.removeAsync(media.objectBoxId);
  Future<void> removeManyMediaAsync(List<MediaV1> media) => _mediaBox.removeManyAsync(List.generate(media.length, (i) => media[i].objectBoxId));
  Future<void> hideManyMediaAsync(List<MediaV1> media) => _mediaBox.putManyAsync(List.generate(media.length, (i) => media[i]..show = false));
  Future<void> showManyMediaAsync(List<MediaV1> media) => _mediaBox.putManyAsync(List.generate(media.length, (i) => media[i]..show = true));
  int get mediaLength => _mediaBox.count();
}

@Entity()
class LocalFolderV1 {
  @Id()
  int objectBoxId;
  @Unique()
  String id;
  String name;
  bool show;
  bool sync;

  LocalFolderV1({this.objectBoxId = 0, required this.id, required this.name, required this.show, required this.sync});

  @override
  String toString() {
    return "LocalFolderV1($id)";
  }
}

@Entity()
class MediaV1 {
  @Id()
  int objectBoxId;
  @Unique()
  String id;
  String? localId;
  String? localFolderId;
  DateTime? localModifiedAt;
  String name;
  String type;
  int? localTypeInt;
  int height;
  int width;
  @Property(type: PropertyType.date)
  DateTime date;
  bool show;
  bool synced;

  MediaV1({this.objectBoxId = 0, required this.id, required this.localId, required this.localFolderId, required this.localModifiedAt, required this.name, required this.type, required this.localTypeInt, required this.height, required this.width, required this.date, required this.show, required this.synced/*, required this.modifiedAt*/});

  @override
  String toString() {
    return "MediaV1($id, $localId)";
  }

  Future<bool> ensureThumbnail({Directory? tempDir}) async {
    File dbFolderAssetThumbnailFile = File("${(tempDir ?? await getTemporaryDirectory()).path}/thumbnails/$id.jpg");
    if(dbFolderAssetThumbnailFile.existsSync()) return true;
    AssetEntity asset = AssetEntity(id: localId!, typeInt: localTypeInt!, width: width, height: height);
    Uint8List thumbnail = (await asset.thumbnailDataWithSize(const ThumbnailSize.square(256), quality: 75))!;
    dbFolderAssetThumbnailFile
        .createSync(recursive: true);
    dbFolderAssetThumbnailFile
        .writeAsBytesSync(thumbnail.buffer.asUint8List(thumbnail.offsetInBytes, thumbnail.lengthInBytes));
    return true;
  }
}