

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';

class DataObjectChangeNotifier extends StatelessWidget {

  final List<DataObject> data;
  final List<List<String>> fieldNames;
  final Widget child;

  const DataObjectChangeNotifier({Key? key,
    required this.data, required this.fieldNames, required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var notify = _DataChangeNotifier();

    var i = 0;
    while (i < data.length) {
      for (var field in fieldNames[i]) {
        data[i].addListener(field, () {
          notify.notify();
        });
      }
    }
    i++;

    return ChangeNotifierProvider<_DataChangeNotifier>.value(
      value: notify,
      child: Consumer ( builder: (context, n, _) {
        return child;
      }),

    );
  }
}

class _DataChangeNotifier with ChangeNotifier {

  void notify() {
    notifyListeners();
  }
}