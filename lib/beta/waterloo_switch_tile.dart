import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../src/waterloo_theme.dart';

class WaterlooSwitchTile extends StatefulWidget {
  final bool initialValue;
  final Function valueBinder;
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
                    title: Text(widget.label),
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

class WaterlooSwitchTileTheme {
  final double fieldWidth;

  const WaterlooSwitchTileTheme({this.fieldWidth = 400});
}
