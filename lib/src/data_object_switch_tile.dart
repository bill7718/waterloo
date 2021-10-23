import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import 'waterloo_switch_tile.dart';

/// A wrapper around [WaterlooSwitchTile] which maintains a Yes/No field in a [DataObject]
class DataObjectSwitchTile extends StatelessWidget {

  /// {@macro label}
  final String label;

  /// {@macro data}
  final DataObject data;

  /// {@macro fieldName}
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
