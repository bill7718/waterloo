import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/src/waterloo_text_provider.dart';
import 'waterloo_theme.dart';

///
/// A wrapper around a [TextFormField]
///
///
class WaterlooTextField extends StatelessWidget {
  static const FormFieldValidator<String> emptyValidator = empty;

  /// The initial value to use with this form field
  final String? initialValue;

  /// Called with by the [onChange] method. Used to bind the value to an external object
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

  /// Passed to the [readOnly] parameter in the [TextFormField]
  final bool readOnly;

  /// The width of the
  final double? width;

  const WaterlooTextField(
      {Key? key,
      required this.label,
      this.initialValue,
      this.obscure = false,
      this.readOnly = false,
        this.hint,
        this.help = '',
      this.valueBinder = emptyBinder,
      this.validator = emptyValidator,
      this.width,
      })
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final formFieldKey = GlobalKey();

    var focus = FocusNode();
    return LayoutBuilder(
      builder: (context, constraints) {
        var textProvider = Provider.of<WaterlooTextProvider>(context);
        var w = width ?? Provider.of<WaterlooTheme>(context).textFieldTheme.fieldWidth;
        w = min(constraints.maxWidth, w);
        return Container(
            margin: Provider.of<WaterlooTheme>(context).textFieldTheme.margin,
            child: Row(
              children: [
                SizedBox(
                    width: w,
                    child: TextFormField(
                      key: formFieldKey,
                      initialValue: initialValue,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: obscure,
                      focusNode: focus,
                      decoration: InputDecoration(
                          labelText: textProvider.get(label),
                          helperText: textProvider.get(help),
                          hintText: textProvider.get(hint)),
                      validator: validator,
                      onChanged: (v) => valueBinder(v),
                      readOnly: readOnly,
                    ))
              ],
            ));
      },
    );
  }

  static String? empty(String? v) => null;

  static void emptyBinder(String? v) {}
}

/// Parameters for the display of the WaterlooTextField
class WaterlooTextFieldTheme {

  /// If provided then override the default field width
  final double fieldWidth;

  /// If provided then override the default margin around this widget
  final EdgeInsets margin;

  const WaterlooTextFieldTheme({this.fieldWidth = 400, this.margin = const EdgeInsets.fromLTRB(0, 10, 0, 10)});
}
