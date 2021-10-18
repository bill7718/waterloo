import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import '../src/waterloo_date_field.dart';

///
/// Wrapper around a [WaterlooDateField] that binds the value to a field in a [DataObject]
///
class DataObjectDateField extends StatelessWidget {

  /// The label for the field
  final String label;

  /// Optional help to be shown with the field
  final String help;

  /// The data object that contains the field being shown
  final DataObject data;

  /// The name of the field to show
  final String fieldName;


  /// {@macro maxDurationBefore}
  final Duration? maxDurationBefore;

  /// {@macro maxDurationAfter}
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
      validator: (v) {
        return data.validate(fields: [fieldName]);
      },
      initialValue: toDateTime(data.get(fieldName)),
      maxFutureDuration: maxDurationAfter ?? const Duration(),
      maxPastDuration: maxDurationBefore ?? const Duration(),

    );
  }
}
