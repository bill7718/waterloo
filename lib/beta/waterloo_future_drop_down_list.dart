import 'package:flutter/material.dart';
import 'package:waterloo/waterloo.dart';

import '../src/waterloo_drop_down_list.dart';

class FutureWaterlooDropDownList extends StatelessWidget {
  final ListGetter getter;

  final String? initialValue;

  final String label;

  final Function valueBinder;

  const FutureWaterlooDropDownList({Key? key, required this.label, required this.getter, required this.valueBinder, this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListItem>>(
        future: getter.getList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WaterlooDropDownList(label: label, items: snapshot.data ?? [], valueBinder: valueBinder, initialValue: initialValue);
          } else {
            return WaterlooTextField(
              label: label,
              readOnly: true,
            );
          }
        });
  }
}

abstract class ListGetter {
  Future<List<ListItem>> getList();
}
