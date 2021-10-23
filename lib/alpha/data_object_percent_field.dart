import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'waterloo_percent_field.dart';

class DataObjectPercentField extends StatelessWidget {
  /// The label for the field
  final String label;

  /// Optional help to be shown with the field
  final String help;

  final DataObject data;

  ///
  final String fieldName;

  const DataObjectPercentField({
    Key? key,
    required this.label,
    required this.data,
    required this.fieldName,
    this.help = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooPercentField(
      label: label,
      valueBinder: (v) {
        data.set(fieldName, v);
      },
      initialValue: data.get(fieldName),
    );
  }
}
