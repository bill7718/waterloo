

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'data_object_widget.dart';

List<Widget> getDataObjectWidgets(DataObject data, List<String> fields,
    Map<String, DataSpecification> specifications) {

  var widgets = <Widget>[];
  for (var field in fields) {
    widgets.add(DataObjectWidget(data: data, fieldName: field,
        dataSpecification: specifications[field]!));
  }

  return widgets;
}