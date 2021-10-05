import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'waterloo_text_provider.dart';

import 'waterloo_theme.dart';

///
/// A wrapper around a [SwitchListTile] that provides a label. Use this to show and update Yes/No values
/// instead of a Tick box.
///
/// It flex's it's width based on available space
///
class WaterlooSwitchTile extends StatefulWidget {

  /// The initial value for this widget
  final bool initialValue;

  /// Binds the value to an external object
  final Function valueBinder;

  /// The text for the [SwitchListTile] [title] widget. This widget accepts a reference value in the label
  /// and it uses [WaterlooTextProvider] to convert the reference into the required text value.
  final String label;

  const WaterlooSwitchTile(
      {Key? key,
      required this.label,
      this.initialValue = false,
      this.valueBinder = WaterlooSwitchTileState.emptyBinder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooSwitchTileState();
}

class WaterlooSwitchTileState extends State<WaterlooSwitchTile> {
  bool itemValue = true;

  @override
  void initState() {
    itemValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var w = min(constraints.maxWidth, Provider.of<WaterlooTheme>(context).switchTileTheme.fieldWidth);
      return Container(
          margin: Provider.of<WaterlooTheme>(context).textFieldTheme.margin,
          child: Row(
            children: [
              SizedBox(
                  width: w,
                  child: SwitchListTile(
                    title: Text(Provider.of<WaterlooTextProvider>(context).get(widget.label)!),
                    value: itemValue,
                    onChanged: (b) {
                      setState(() {
                        itemValue = b;
                        widget.valueBinder(b);
                      });
                    },
                  ))
            ],
          ));
    });
  }

  static void emptyBinder(bool? v) {}
}

///
/// Default parameters used by the [WaterlooSwitchTile]
///
class WaterlooSwitchTileTheme {

  /// The default width for this widget.
  final double fieldWidth;

  const WaterlooSwitchTileTheme({this.fieldWidth = 400});
}
