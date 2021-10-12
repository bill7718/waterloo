import 'package:flutter/material.dart';

///
/// Create a List<T> and then fires a notification if
/// - an item is added or removed
/// - the whole list is rebuilt
///
/// Used to auto-regenerate a table if the contents of a list are added to or removed
///
class ChangeNotifierList<T extends Object> with ChangeNotifier {

  /// The list which is listened to
  final List<T> _list = <T>[];

  ChangeNotifierList();

  List<T> get list => _list;

  void add(T value, {T? beforeItem}) {
    if (_list.contains(value)) {
      _list.remove(value);
    }
    if (beforeItem != null) {
      var i = _list.lastIndexOf(beforeItem);
      _list.insert(i, value);
    } else {
      _list.add(value);
    }

    notifyListeners();
  }

  void remove(T value) {
    if (_list.contains(value)) {
      _list.remove(value);
      notifyListeners();
    }
  }

  void replaceAll(Iterable<T> i) {
    _list.clear();
    _list.addAll(i);
    notifyListeners();
  }

  Type get type => T;
}
