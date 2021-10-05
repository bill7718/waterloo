import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'waterloo_text_provider.dart';

///
/// A simple wrapper around a [TextButton]
///
/// The child widget is a [Text] widget and it accepts an [exceptionHandler] Function to
/// use if the [onPressed] method generates an exception.
///
class WaterlooTextButton extends StatelessWidget {
  /// The Text of the Button
  final String text;

  /// Function to call when the button is pressed
  final Function onPressed;

  /// The exception handler to use if the build method or the [onPressed] function throws an exception
  final Function exceptionHandler;

  const WaterlooTextButton({Key? key, required this.text, required this.exceptionHandler, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(Provider.of<WaterlooTextProvider>(context).get(text)!),
      onPressed: () async {
        try {
          await onPressed();
        } catch (ex, st) {
          exceptionHandler(context, ex, st);
        }
      },
    );
  }
}
