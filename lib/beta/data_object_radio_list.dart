import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import '../src/waterloo_radio_button_list.dart';
import '../src/waterloo_drop_down_list.dart';

class DataObjectRadioList extends StatelessWidget {
  /// The label for the field
  final String label;

  final List<ListItem> items;

  final DataObject data;

  ///
  final String fieldName;

  const DataObjectRadioList({
    Key? key,
    required this.label,
    required this.data,
    required this.fieldName,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
    child :WaterlooRadioButtonList(
      label: label,
      valueBinder: (v) {
        data.set(fieldName, v);
      },
      initialValue: data.get(fieldName),
      items: items,
    ));
  }
}
