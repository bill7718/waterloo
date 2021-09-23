import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import 'waterloo_date_field.dart';

class DataObjectDateField extends StatelessWidget {
  /// The label for the field
  final String label;

  /// Optional help to be shown with the field
  final String help;

  final DataObject data;

  ///
  final String fieldName;

  final Duration? maxDurationBefore;

  final Duration? maxDurationAfter;

  const DataObjectDateField(
      {Key? key, required this.label, required this.data, required this.fieldName,
        this.help = '',
      this.maxDurationAfter,
      this.maxDurationBefore
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooDateField(
      label: label,
      valueBinder: (v) {
        data.set(fieldName, fromDateTime(v));
      },
      initialValue: toDateTime(data.get(fieldName)),
      maxFutureDuration: maxDurationAfter ?? const Duration(),
      maxPastDuration: maxDurationBefore ?? const Duration(),

    );
  }
}
