import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'waterloo_theme.dart';

///
/// A wrapper around a [TextFormField]
///
///
class WaterlooTextField extends StatelessWidget {
  static const FormFieldValidator<String> emptyValidator = empty;

  ///
  final String initialValue;

  final Function valueBinder;

  /// Validates the entered value. Returns an error message
  final FormFieldValidator<String> validator;

  /// If true then the text value is obscured - normally used for passwords
  final bool obscure;

  /// The label for the field
  final String label;

  /// Optional help to be shown with the field
  final String help;

  /// Optional hint to be shown with the field
  final String? hint;

  final bool readOnly;

  const WaterlooTextField(
      {Key? key,
      this.valueBinder = emptyBinder,
      required this.label,
      this.validator = emptyValidator,
      this.obscure = false,
      this.readOnly = false,
      this.initialValue = '',
        this.hint,
      this.help = ''})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {

    final formFieldKey = GlobalKey();

    var focus = FocusNode();

    return Container(
      width: Provider.of<WaterlooTheme>(context).textFieldTheme.fieldWidth,
      margin: Provider.of<WaterlooTheme>(context).textFieldTheme.margin,
      child: TextFormField(
        key: formFieldKey,
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscure,
        focusNode: focus,
        decoration: InputDecoration(labelText: label, helperText: help, hintText: hint),
        validator: validator,
        onChanged: (v) => valueBinder(v),
        readOnly: readOnly,
      ),
    );
  }

  static String? empty(String? v) => null;

  static void emptyBinder(String? v) {}
}


class WaterlooTextFieldTheme {
  final double fieldWidth;
  final EdgeInsets margin;

  const WaterlooTextFieldTheme({this.fieldWidth = 400, this.margin = const EdgeInsets.fromLTRB(0, 10, 0, 10)});
}
