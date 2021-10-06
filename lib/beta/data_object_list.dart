import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import 'waterloo_drop_drown_list.dart';


class DataObjectList extends StatelessWidget {

  final String objectType;

  final String? filterLabel;

  final dynamic filterValue;

  final String descriptionLabel;

  final String? screenFieldLabel;

  final String idLabel;

  final DatabaseReader reader;

  final Function valueBinder;

  const DataObjectList({Key? key, required this.objectType, required this.filterLabel, this.filterValue,
    required this.descriptionLabel, this.idLabel = PersistableDataObject.idLabel, required this.reader,
    required this.valueBinder, this.screenFieldLabel
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FutureWaterlooDropDownList(label: screenFieldLabel ?? descriptionLabel, valueBinder: valueBinder,
    getter: DataListGetter(objectType, filterLabel, filterValue, descriptionLabel, idLabel, reader),);
  }
}

class DataListGetter implements ListGetter {

  final String objectType;

  final String? filterLabel;

  final dynamic filterValue;

  final String descriptionLabel;

  final String idLabel;

  final DatabaseReader reader;

  DataListGetter(this.objectType, this.filterLabel, this.filterValue,
    this.descriptionLabel, this.idLabel, this.reader);

  @override
  Future<List<ListItem>> getList() {
    var c = Completer<List<ListItem>>();

    var f = reader.query(objectType, field: filterLabel, value: filterValue);

    f.then( (r) {
      var response = <ListItem>[];
      for (var map in r) {
        response.add(ListItem(map[idLabel], map[descriptionLabel]));
      }
      c.complete(response);

    });

    return c.future;
  }


}