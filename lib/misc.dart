import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

List<Widget> flatten(List<dynamic> list) {
  List<Widget> temp = [];
  for(dynamic item in list) {
    if(item is List) {
      temp.addAll(flatten(item));
    } else {
      temp.add(item);
    }
  }
  return temp;
}

class IsolateHandler {

  Future<void> start() async {
    late final ReceivePort mainReceivePort;
    late final SendPort mainSendPort;
    late final ReceivePort intermediateReceivePort;
    late final SendPort intermediateSendPort;
    late final SendPort isolateSendPort;
    late final RootIsolateToken rootIsolateToken;

    mainReceivePort = ReceivePort();
    mainSendPort = mainReceivePort.sendPort;
    intermediateReceivePort = ReceivePort();
    intermediateSendPort = intermediateReceivePort.sendPort;
    rootIsolateToken = RootIsolateToken.instance!;
    
    final isolateData = {
      'intermediateSendPort': intermediateSendPort,
      'rootIsolateToken': rootIsolateToken,
    };
    await Isolate.spawn(_intermediateIsolate, isolateData);

    intermediateReceivePort.listen((message) {
      if(message is SendPort) {
        isolateSendPort = message;
        main(mainReceivePort, isolateSendPort);
        return;
      }
      mainSendPort.send(message);
    });
  }

  void main(ReceivePort mainReceivePort, SendPort isolateSendPort) {}

  Future<void> _intermediateIsolate(isolateData) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData["rootIsolateToken"]);
    SendPort intermediateSendPort = isolateData["intermediateSendPort"];
    ReceivePort isolateReceivePort = ReceivePort();
    intermediateSendPort.send(isolateReceivePort.sendPort);
    isolate(isolateReceivePort, intermediateSendPort);
  }

  Future<void> isolate(ReceivePort isolateReceivePort, SendPort mainSendPort) async {}

}

class TimelineChangeNotifier extends ChangeNotifier {
  /*
  /// Внутреннее приватное состояние корзины.
  final List<Item> _items = [];

  /// Неизменяемое представление товаров в корзине.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// Текущая общая цена всех предметов (при условии, что все предметы стоят по 42 доллара).
  int get totalPrice => _items.length * 42;

  /// Добавляет [item] в корзину. Это и [removeAll] - единственные способы изменить корзину снаружи.
  void add(Item item) {
    _items.add(item);
    // Этот вызов сообщает виджетам, которые слушают эту модель, о необходимости перестроения.
    notifyListeners();
  }

  /// Удаляет все товары из корзины.
  void removeAll() {
    _items.clear();
    // Этот вызов сообщает виджетам, которые слушают эту модель, о необходимости перестроения.
    notifyListeners();
  }*/
  void updateTimeline() {
    notifyListeners();
  }
}

class LocalFoldersChangeNotifier extends ChangeNotifier {
  void updateLocalFolders() {
    notifyListeners();
  }
}

TimelineChangeNotifier timelineChangeNotifier = TimelineChangeNotifier();
LocalFoldersChangeNotifier localFoldersChangeNotifier = LocalFoldersChangeNotifier();

class TemporaryDirectory extends InheritedWidget {
  final Directory temp;

  const TemporaryDirectory(
      {super.key, required this.temp, required super.child});

  static TemporaryDirectory? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TemporaryDirectory>();
  }

  static TemporaryDirectory of(BuildContext context) {
    final TemporaryDirectory? result = maybeOf(context);
    assert(result != null, 'No TemporaryDirectory found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

final DateFormat internalFormatter = DateFormat('dd.MM.yyyy');