import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import 'waterloo_switch_tile.dart';

class DataObjectSwitchTile extends StatelessWidget {
  /// The label for the field
  final String label;

  final DataObject data;

  ///
  final String fieldName;

  const DataObjectSwitchTile({Key? key, required this.label, required this.data, required this.fieldName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooSwitchTile(
      label: label,
      initialValue: data.get(fieldName) ?? false,
      valueBinder: (v) {
        data.set(fieldName, v);
      },
    );
  }
}
