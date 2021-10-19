import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'waterloo_text_field.dart';

///
/// A wrapper around a [WaterlooTextField] that collects an integer and saves it
/// to a field in a [DataObject]
///
class DataObjectIntegerField extends StatelessWidget {
  static const String integerError = 'integerError';

  /// The label for the field
  final String label;

  /// Optional help to be shown with the field
  final String help;

  /// Optional hint to be shown with the field
  final String hint;

  /// The object containing the data
  final DataObject data;

  ///The name of the field
  final String fieldName;

  /// Validates the entered value. Returns an error message if
  /// - the value is not an integer
  /// - it fails the validation in the [DataObject]
  /// - it fails any bespoke validation passed in to this widget
  final FormFieldValidator<String> validator;

  const DataObjectIntegerField(
      {Key? key,
      required this.label,
      required this.data,
      required this.fieldName,
      this.help = '',
      this.hint = '',
      this.validator = WaterlooTextField.emptyValidator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooTextField(
        label: label,
        help: help,
        hint: hint,
        valueBinder: (v) {
          if (int.tryParse(v) != null) {
            data.set(fieldName, int.parse(v));
          }
        },
        initialValue: data.get(fieldName) == null ? '' : data.get(fieldName).toString(),
        validator: (v) {
          if (int.tryParse(v ?? '0') == null) {
            return integerError;
          }

          var s = validator(v);
          s ??= data.validate(fields: [fieldName]);
          return s;
        });
  }
}
