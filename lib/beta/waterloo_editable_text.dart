import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo.dart';

class WaterlooEditableText extends StatelessWidget {
  /// {@macro initialValue}
  final String? initialValue;

  /// {@macro valueBinder}
  final Function valueBinder;

  const WaterlooEditableText(
      {Key? key, this.initialValue, this.valueBinder = emptyBinder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<WaterlooTheme>(context).editableTextTheme;

    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor)),
        padding: const EdgeInsets.all(5),
        child: EditableText(

          focusNode: FocusNode(),
          backgroundCursorColor: Theme.of(context).dividerColor,
          cursorColor: Theme.of(context).dividerColor,
          style: theme.style,
          controller: TextEditingController(text: initialValue),
          minLines: theme.minLines,
          maxLines: theme.maxLines,
          onChanged: (v) { valueBinder(v); } ,
        ));
  }

  static void emptyBinder(String? v) {}
}

/// Parameters for the display of the [WaterlooEditableText]
class WaterlooEditableTextTheme {
  /// Teh style of the text being edited in this field
  final TextStyle style;

  final int minLines;
  final int maxLines;

  const WaterlooEditableTextTheme(
      {this.style = const TextStyle(fontSize: 16),
      this.minLines = 5,
      this.maxLines = 10});
}
