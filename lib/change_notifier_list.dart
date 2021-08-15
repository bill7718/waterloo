

import 'package:flutter/material.dart';

class ChangeNotifierList<T extends Object>  with ChangeNotifier {

  final List<T> _list = <T>[];


  ChangeNotifierList();

  List<T> get list =>_list;

  void add(T value, { T? beforeItem }) {
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

  Type get type=>T;
}