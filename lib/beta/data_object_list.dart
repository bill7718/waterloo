import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import '../src/waterloo_drop_down_list.dart';
import '../src/waterloo_future_drop_down_list.dart';


class DataObjectList<T extends PersistableDataObject> extends StatelessWidget {

  final String? filterLabel;

  final dynamic filterValue;

  final String descriptionLabel;

  final String? screenFieldLabel;

  final String? initialValue;

  final String? filterRef;

  final String idLabel;

  final DatabaseReader reader;

  final Function valueBinder;

  const DataObjectList({Key? key, required this.filterLabel, this.filterValue, this.filterRef,
    required this.descriptionLabel, this.idLabel = PersistableDataObject.idLabel, required this.reader,
    required this.valueBinder, this.screenFieldLabel,  this.initialValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WaterlooFutureDropDownList(label: screenFieldLabel ?? descriptionLabel, valueBinder: valueBinder, initialValue: initialValue,
    getter: DataListGetter<T>(filterLabel, filterValue, descriptionLabel, idLabel, filterRef, reader),);
  }
}

class DataListGetter<T extends PersistableDataObject> implements ListGetter {

  final String? filterLabel;

  final String? filterRef;

  final dynamic filterValue;

  final String descriptionLabel;

  final String idLabel;

  final DatabaseReader reader;

  DataListGetter(this.filterLabel, this.filterValue,
    this.descriptionLabel, this.idLabel, this.filterRef, this.reader);

  @override
  Future<List<ListItem>> getList() {
    var c = Completer<List<ListItem>>();

    var f = reader.query<T>(ref: filterRef, field: filterLabel, value: filterValue);

    f.then( (r) {
      var response = <ListItem>[];
      for (var item in r) {
        response.add(ListItem(item.get(idLabel),  item.get(descriptionLabel)));
      }
      c.complete(response);

    });

    return c.future;
  }


}