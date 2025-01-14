import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../singletons/server_list.dart';
import '../objects/display_item.dart';
import '../objects/server.dart';

class BrowserManager {
  final List<List<DisplayItem>> browserCache = [];
  final List<double> scrollCache = [];

  final List<DisplayItem> browserList = [];

  String listName = 'Welcome';
  bool loading = false;

  late final BehaviorSubject<List<DisplayItem>> _browserStream =
      BehaviorSubject<List<DisplayItem>>.seeded(browserList);
  late final BehaviorSubject<String> _browserLabel =
      BehaviorSubject<String>.seeded(listName);

  BrowserManager._privateConstructor();
  static final BrowserManager _instance = BrowserManager._privateConstructor();

  // scroll controller in stream format
  ScrollController sc = ScrollController();

  factory BrowserManager() {
    return _instance;
  }

  void setBrowserLabel(String label) {
    listName = label;
    _browserLabel.sink.add(label);
  }

  void clear() {
    List<DisplayItem> hold = browserCache[0];

    browserCache.clear();
    browserList.clear();

    browserCache.add(hold);

    scrollCache.clear();
  }

  void goToNavScreen() {
    browserCache.clear();
    browserList.clear();

    if (ServerManager().currentServer == null) {
      return;
    }

    DisplayItem newItem1 = new DisplayItem(
        ServerManager().currentServer!,
        'File Explorer',
        'execAction',
        'fileExplorer',
        Icon(Icons.folder, color: Color(0xFFffab00)),
        null);

    DisplayItem newItem2 = new DisplayItem(
        ServerManager().currentServer!,
        'Playlists',
        'execAction',
        'playlists',
        Icon(Icons.queue_music, color: Colors.black),
        null);

    DisplayItem newItem3 = new DisplayItem(
        ServerManager().currentServer!,
        'Albums',
        'execAction',
        'albums',
        Icon(Icons.album, color: Colors.black),
        null);

    DisplayItem newItem4 = new DisplayItem(
        ServerManager().currentServer!,
        'Artists',
        'execAction',
        'artists',
        Icon(Icons.library_music, color: Colors.black),
        null);

    DisplayItem newItem5 = new DisplayItem(
        ServerManager().currentServer!,
        'Rated',
        'execAction',
        'rated',
        Icon(Icons.star, color: Colors.black),
        null);

    DisplayItem newItem6 = new DisplayItem(
        ServerManager().currentServer!,
        'Recent',
        'execAction',
        'recent',
        Icon(Icons.query_builder, color: Colors.black),
        null);

    DisplayItem newItem7 = new DisplayItem(
        ServerManager().currentServer!,
        'Local Files',
        'execAction',
        'localFiles',
        Icon(Icons.folder_open_outlined, color: Colors.black),
        null);

    browserCache.add(
        [newItem1, newItem2, newItem3, newItem4, newItem5, newItem6, newItem7]);
    browserList.add(newItem1);
    browserList.add(newItem2);
    browserList.add(newItem3);
    browserList.add(newItem4);
    browserList.add(newItem5);
    browserList.add(newItem6);
    browserList.add(newItem7);

    _browserStream.sink.add(browserList);
  }

  void noServerScreen() {
    browserCache.clear();
    browserList.clear();
    scrollCache.clear();

    browserList.add(new DisplayItem(null, 'Welcome To mStream', 'addServer', '',
        Icon(Icons.add, color: Colors.black), 'Click here to add server'));

    _browserStream.sink.add(browserList);
  }

  void addListToStack(List<DisplayItem> newList) {
    browserCache.add(newList);

    // TODO: throws an error when you click the file explorer tab from the queue
    // scrollCache.add(sc.offset);

    browserList.clear();
    newList.forEach((element) {
      browserList.add(element);
    });

    _browserStream.sink.add(browserList);
  }

  updateStream() {
    _browserStream.sink.add(browserList);
  }

  void popBrowser() {
    if (BrowserManager().browserCache.length < 2) {
      return;
    }

    browserCache.removeLast();
    browserList.clear();
    browserCache[browserCache.length - 1].forEach((el) {
      browserList.add(el);
    });

    _browserStream.sink.add(browserList);

    // double scrollTo = scrollCache.removeLast();
    // sc.jumpTo(scrollTo);
  }

  void removeAll(String data, Server? server, String type) {
    browserList.removeWhere(
        (e) => e.server == server && e.data == data && e.type == type);
    _browserStream.sink.add(browserList);

    browserCache.forEach((b) {
      b.removeWhere(
          (e) => e.server == server && e.data == data && e.type == type);
    });
  }

  void dispose() {
    _browserStream.close();
    _browserLabel.close();
  }

  Stream<List<DisplayItem>> get browserListStream => _browserStream.stream;
  Stream<String> get broswerLabelStream => _browserLabel.stream;
}
