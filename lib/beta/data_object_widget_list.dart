

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'data_object_grid.dart';
import 'data_object_widget.dart';

List<Widget> getDataObjectWidgets(DataObject data, List<String> fields,
    Map<String, DataSpecification> specifications) {

  var widgets = <Widget>[];
  for (var field in fields) {
    widgets.add(DataObjectWidget(data: data, fieldName: field,
        specifications: specifications));
  }

  return widgets;
}


List<Widget> dataObjectGridBuilder(List<DataObject> data, List<List<String>> fieldNames,
     Map<String, DataSpecification> specifications, {List<List<String>>? rebuildFieldNames, int? preferredColumnCount }) {
  var widgets = <Widget>[];

  var i = 0;
  while (i < data.length) {
    widgets.add(DataObjectGrid(
      data: data[i],
      fieldNames: fieldNames[i],
      specifications: specifications,
      rebuildFields: rebuildFieldNames == null ? null : rebuildFieldNames![i],
      preferredColumnCount: preferredColumnCount,
    ));

    i++;
  }
  return widgets;
}