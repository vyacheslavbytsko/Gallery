import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';

class MediaBox {
  late final Store _store;
  late final Box<LocalMedia> _localMediaBox;
  late final Query<LocalMedia> localMediaSortedQuery;

  MediaBox._create(this._store) {
    _localMediaBox = Box<LocalMedia>(_store);
    localMediaSortedQuery = (_localMediaBox.query()..order(LocalMedia_.modifiedAt, flags: Order.descending)).build();
  }

  static Future<MediaBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final storeDir = join(docsDir.path, "mediabox");
    final Store store;
    if (Store.isOpen(storeDir)) {
      store = Store.attach(getObjectBoxModel(), storeDir);
    } else {
      store = await openStore(directory: storeDir);
    }
    return MediaBox._create(store);
  }

  Future<void> addLocalMedia(String id, String folder, DateTime modifiedAt) =>
      _localMediaBox.putAsync(
          LocalMedia(
              id: id,
              folder: folder,
              modifiedAt: modifiedAt
          )
      );


  Future<void> addAllLocalMedia(List<LocalMedia> assets) => _localMediaBox.putManyAsync(assets, mode: PutMode.put);

  Future<void> dropLocalMedia() => _localMediaBox.removeAllAsync();

  int localMediaLength() => _localMediaBox.count();

  Future<List<LocalMedia>> getAllLocalMedia() => _localMediaBox.getAllAsync();

  Future<List<LocalMedia>> getAllLocalMediaSorted() => localMediaSortedQuery.findAsync();
}

@Entity()
class LocalMedia {
  @Id()
  int objectBoxId;
  @Unique()
  String id;
  String folder;
  DateTime modifiedAt;

  LocalMedia({this.objectBoxId = 0, required this.id, required this.folder, required this.modifiedAt});
}

/*import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'media.g.dart';

/*class Media extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  TextColumn get content => text().named('body')();
  IntColumn get category =>
      integer().nullable().references(TodoCategory, #id)();
  DateTimeColumn get createdAt => dateTime().nullable()();
}*/

// Таблица локальных медиа, нужна для того, чтобы потом с ней работать при синхронизации с сервером
class LocalMedia extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get modifiedAt => dateTime()();


  @override
  Set<Column<Object>> get primaryKey => {id};
}

// Таблица, которая показывает
/*class ServerMedia extends Table {
  TextColumn get id => text()();
  IntColumn get type => integer()();
  TextColumn get name => text()();
  DateTimeColumn get datetime => dateTime()();
}*/

/*class TodoCategory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
}*/

@DriftDatabase(tables: [LocalMedia])
class MediaDatabase extends _$MediaDatabase {
  MediaDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    return driftDatabase(name: 'media_db');
  }
}*/