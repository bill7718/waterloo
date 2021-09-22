import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/data_object_widgets.dart';
import 'data_object_drop_down_list.dart';
import 'waterloo_drop_drown_list.dart';
import 'data_object_switch_tile.dart';

class DataObjectWidget extends StatelessWidget {
  final DataObject data;
  final String fieldName;
  final DataSpecification dataSpecification;

  const DataObjectWidget({Key? key, required this.data, required this.fieldName, required this.dataSpecification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = data.get(fieldName);
    if (value is bool || (value == null && dataSpecification.type == 'bool')) {
      return DataObjectSwitchTile(
        label: dataSpecification.label ?? '',
        data: data,
        fieldName: fieldName,
      );
    }

    if (dataSpecification.list.isNotEmpty) {
      var items = <ListItem>[];
      for (var entry in dataSpecification.list) {
        items.add(ListItem(entry.id, entry.description));
      }
      return DataObjectDropDownList(
          label: dataSpecification.label ?? '', data: data, fieldName: fieldName, items: items);
    }

    return DataObjectTextField(
      label: dataSpecification.label ?? '',
      data: data,
      fieldName: fieldName,
      obscure: dataSpecification.obscure,
      help: dataSpecification.help ?? '',
      validator: v,
    );
  }

  String? v(String? v) => dataSpecification.validator(v);
}
