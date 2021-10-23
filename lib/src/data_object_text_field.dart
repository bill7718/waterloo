import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';

import 'waterloo_text_field.dart';
import 'waterloo_text_provider.dart';

/// {@template dataObjectFieldValidator}
/// Adds additional validation to this field.
///
///
/// Note that this class calls the [validate] method for the corresponding [DataObject] by default.
/// {@endtemplate}

/// {@template data}
/// The [DataObject] that contains the data items that is being maintained
/// {@endtemplate}

/// {@template fieldName}
/// The reference to the field within the [data] [DataObject] that is being maintained
/// {@endtemplate}



///
/// Wrapper around a [WaterlooTextField] that binds the value to a field in a [DataObject]
///
class DataObjectTextField extends StatelessWidget {

  /// {@macro label}
  final String label;

  /// {@macro dataObjectFieldValidator}
  final FormFieldValidator<String> validator;

  /// Optional help to be shown with the field
  final String help;

  /// If true then the text value is obscured - normally used for passwords
  final bool obscure;

  /// {@macro data}
  final DataObject data;

  /// {@macro fieldName}
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
      validator: (v) {
        var s = validator(v);
        s ??= data.validate(fields: [fieldName]);
        return Provider.of<WaterlooTextProvider>(context, listen: false).get(s);
      },
    );
  }
}
