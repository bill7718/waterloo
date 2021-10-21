

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';

///
/// This widgets rebuilds its ren using a [builder] if any of the fields in [fieldNames] in any of the
/// data objects in [data] notify this widget of a change.
///
class DataObjectChangeNotifier extends StatelessWidget {

  /// The [DataObject]s ot be listened to
  final List<DataObject> data;

  /// The fields within the data objects that trigger a rebuild
  final List<List<String>> fieldNames;

  /// Builds the child widget
  final Function builder;

  const DataObjectChangeNotifier({Key? key,
    required this.data, required this.fieldNames, required this.builder
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final notify = _DataChangeNotifier();

    var i = 0;
    while (i < data.length) {
      for (var field in fieldNames[i]) {
        data[i].addListener(field, () {
          notify.notify();
        });
      }
      i++;
    }


    return ChangeNotifierProvider<_DataChangeNotifier>.value(
      value: notify,
      child: Consumer<_DataChangeNotifier> (
      key: GlobalKey(),
          builder: (context, n, _) {
        return  builder(context);
      }),

    );
  }
}

class _DataChangeNotifier extends ChangeNotifier {

  int value = 1;

  void notify() {
    value++;
    notifyListeners();
  }
}