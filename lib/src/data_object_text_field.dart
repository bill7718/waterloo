import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import 'waterloo_text_field.dart';

class DataObjectTextField extends StatelessWidget {
  /// The label for the field
  final String label;

  /// Validates the entered value. Returns an error message
  final FormFieldValidator<String> validator;

  /// Optional help to be shown with the field
  final String help;

  /// If true then the text value is obscured - normally used for passwords
  final bool obscure;

  final DataObject data;

  ///
  final String fieldName;

  const DataObjectTextField(
      {Key? key,
      required this.label,
      required this.data,
      required this.fieldName,
      this.validator = WaterlooTextField.emptyValidator,
      this.obscure = false,
      this.help = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooTextField(
      label: label,
      valueBinder: (v) {
        data.set(fieldName, v);
      },
      obscure: obscure,
      initialValue: data.get(fieldName) ?? '',
      help: help,
    );
  }
}
