import 'package:flutter/material.dart';

///
/// A wrapper around a [TextFormField]
///
///
class WaterlooTextField extends StatelessWidget {


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

  const WaterlooTextField(
      {Key? key,
      required this.valueBinder,
      required this.label,
      required this.validator,
      this.obscure = false,
        this.initialValue = '',
      this.help = ''})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    var focus = FocusNode();
    return Container(
      width: 400,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: TextFormField(
        initialValue: initialValue,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscure,
        focusNode: focus,
        decoration: InputDecoration(labelText: label, helperText: help),
        validator: validator,
        onChanged: (v) =>valueBinder(v),

      ),
    );
  }
}
