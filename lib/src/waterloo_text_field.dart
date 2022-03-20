import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/src/waterloo_text_provider.dart';
import 'waterloo_theme.dart';

/// {@template initialValue}
/// The initial value to use with this form field.
/// {@endtemplate}

/// {@template valueBinder}
/// Called by the [onChange] method. Used to bind the value to an external object
/// {@endtemplate}

/// {@template label}
/// The label to be shown on this field.
///
/// The widget looks this value up in the [WaterlooTextProvider] and substitutes the value
/// found.
///
/// {@endtemplate}


///
/// A wrapper around a [TextFormField]
///
///
class WaterlooTextField extends StatefulWidget {

  static String? empty(String? v) => null;

  static void emptyBinder(String? v) {}

  static const FormFieldValidator<String> emptyValidator = empty;

  /// {@macro initialValue}
  final String? initialValue;

  /// {@macro valueBinder}
  final Function valueBinder;

  /// Validates the entered value. Returns an error message
  final FormFieldValidator<String> validator;

  /// If true then the text value is obscured - normally used for passwords
  final bool obscure;

  /// {@macro label}
  final String label;

  /// Optional help to be shown with the field
  final String help;

  /// Optional hint to be shown with the field
  final String? hint;

  /// Passed to the [readOnly] parameter in the [TextFormField]
  final bool readOnly;

  final int maxLines;

  const WaterlooTextField({
    Key? key,
    required this.label,
    this.initialValue,
    this.obscure = false,
    this.readOnly = false,
    this.hint,
    this.help = '',
    this.valueBinder = emptyBinder,
    this.validator = emptyValidator,
    this.maxLines = 1
  }) : super(
    key: key,
  );

  @override
  State<StatefulWidget> createState()=>WaterlooTextFieldState();
}

class WaterlooTextFieldState extends State<WaterlooTextField> {

  bool previouslyValidated = false;

  @override
  void initState() {
    previouslyValidated = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final formFieldKey = GlobalKey();

    var focus = FocusNode();

    final textProvider = Provider.of<WaterlooTextProvider>(context, listen: false);

    return Container(
        margin: Provider.of<WaterlooTheme>(context).textFieldTheme.margin,
        width: Provider.of<WaterlooTheme>(context).textFieldTheme.width,
        child: TextFormField(
          key: formFieldKey,
          initialValue: widget.initialValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: widget.obscure,
          focusNode: focus,
          decoration: InputDecoration(labelText: textProvider.get(widget.label), helperText: textProvider.get(widget.help), hintText: textProvider.get(widget.hint)),
          validator: (v) {
            if (previouslyValidated || !focus.hasFocus) {
              previouslyValidated = true;
              return textProvider.get(widget.validator(v));
            }
          },
          onChanged: (v) => widget.valueBinder(v),
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
        ));
  }


}

/// Parameters for the display of the WaterlooTextField
class WaterlooTextFieldTheme {
  /// If provided then override the default margin around this widget
  final EdgeInsets margin;

  /// The width of the text field
  final double? width;

  const WaterlooTextFieldTheme({this.margin = const EdgeInsets.fromLTRB(0, 5, 0, 5), this.width });
}
