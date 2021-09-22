import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'waterloo_drop_drown_list.dart';

class DataObjectDropDownList extends StatelessWidget {
  /// The label for the field
  final String label;

  final List<ListItem> items;

  final DataObject data;

  ///
  final String fieldName;

  const DataObjectDropDownList({
    Key? key,
    required this.label,
    required this.data,
    required this.fieldName,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooDropDownList(
      label: label,
      valueBinder: (v) {
        data.set(fieldName, v);
      },
      initialValue: data.get(fieldName),
      items: items,
    );
  }
}