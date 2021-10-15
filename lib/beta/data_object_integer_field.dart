import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';

import '../src/waterloo_currency_field.dart';
import '../src/waterloo_text_field.dart';
import '../src/waterloo_text_provider.dart';

class DataObjectIntegerField extends StatelessWidget {

  static const String integerError = 'integerError';

  /// The label for the field
  final String label;

  /// Optional help to be shown with the field
  final String help;

  final DataObject data;

  ///
  final String fieldName;

  /// Validates the entered value. Returns an error message
  final FormFieldValidator<String> validator;

  const DataObjectIntegerField(
      {Key? key,
      required this.label,
      required this.data,
      required this.fieldName,
      this.help = '',
      this.validator = WaterlooTextField.emptyValidator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooTextField(
        label: label,
        valueBinder: (v) {
          data.set(fieldName, int.tryParse(v));
        },
        initialValue: data.get(fieldName) == null ? '' : data.get(fieldName).toString(),
        validator: (v) {

          if (int.tryParse(v ?? '0') == null) {
            return Provider.of<WaterlooTextProvider>(context, listen: false).get(integerError);
          }

          var s = validator(v);
          s ??= data.validate(fields: [fieldName]);
          return s == null ? null : Provider.of<WaterlooTextProvider>(context, listen: false).get(s);
        });
  }
}
