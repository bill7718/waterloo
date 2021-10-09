import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
/// A wrapper around [Text] widgets that is designed to show messages on the top of a form.
///
/// A default message is passed in but if the [error] property has an error message set then the error is show instead.
///
/// This allows the same piece of screen real estate to be used for both an initial explanatory message and an form wide error
/// messages
///
///
class WaterlooFormMessage extends StatelessWidget {
  /// The message to show in the absence of an error
  final String text;

  /// Contains the error message to be shown instead of the default message
  final FormError error;

  const WaterlooFormMessage({Key? key, this.text = '', required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormError>.value(
        value: error,
        child: Consumer<FormError>(builder: (consumerContext, error, _) {
          if (error.error.isEmpty) {
            return Container(alignment: Alignment.centerLeft, child: Text(text));
          } else {
            return Container(alignment: Alignment.centerLeft, child: Text(error.error));
          }
        }));
  }
}

///
/// A simple class that holds a String and fires a Change Notification when the value is changed.
///
class FormError with ChangeNotifier {
  String _error = '';

  set error(String e) {
    _error = e;
    notifyListeners();
  }

  String get error => _error;
}
