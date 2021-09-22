

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WaterlooSwitchTile extends StatefulWidget {

  final bool initialValue;
  final Function valueBinder;
  final String label;

  const WaterlooSwitchTile({Key? key, required this.label, required this.initialValue, this.valueBinder = WaterlooSwitchTileState.emptyBinder}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooSwitchTileState();
}

class WaterlooSwitchTileState extends State<WaterlooSwitchTile> {
  bool itemValue = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 400,
        child: SwitchListTile(
          contentPadding: const EdgeInsets.all(0),
          title: Text(widget.label),
          value: itemValue,
          onChanged: (b) {
            setState(() {
              itemValue = b;
              widget.valueBinder(b);
            });
          },
        ));
  }

  static void emptyBinder(bool? v) {}
}