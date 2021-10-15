import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import 'waterloo_currency_field.dart';
import 'waterloo_text_field.dart';

///
/// Wrapper around a [WaterlooCurrencyField] that binds the value to a field in a [DataObject]
///
class DataObjectCurrencyField extends StatelessWidget {
  /// The label for the field
  final String label;

  /// Optional help to be shown with the field
  final String help;

  final DataObject data;

  /// The field within the data object that is bound
  final String fieldName;

  /// Validates the entered value. Returns an error message
  final FormFieldValidator<String> validator;

  const DataObjectCurrencyField(
      {Key? key,
      required this.label,
      required this.data,
      required this.fieldName,
      this.help = '',
      this.validator = WaterlooTextField.emptyValidator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooCurrencyField(
        label: label,
        valueBinder: (v) {
          data.set(fieldName, v);
        },
        initialValue: data.get(fieldName),
        validator: (v) {
          var s = validator(v);
          s ??= data.validate(fields: [fieldName]);
          return s;
        },
    help: help,);
  }
}
