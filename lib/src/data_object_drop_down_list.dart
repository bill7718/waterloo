import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'waterloo_drop_down_list.dart';

///
/// Shows a drop down list corresponding to the field referenced by the [fieldName] in the [DataObject] [data]
///
class DataObjectDropDownList extends StatelessWidget {
  /// The label for the field
  final String label;

  /// The list of items to show in the dropdown list
  final List<ListItem> items;

  /// The object that provides the data
  final DataObject data;

  /// The field name of the field to be shown
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
