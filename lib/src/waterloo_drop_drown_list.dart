
import 'package:flutter/material.dart';

import 'waterloo_text_field.dart';

class WaterlooDropDownList extends StatefulWidget {
  final List<ListItem> items;

  final String? initialValue;

  final Function valueBinder;

  const WaterlooDropDownList({Key? key, required this.items, required this.valueBinder, this.initialValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooDropDownListState();
}

class WaterlooDropDownListState extends State<WaterlooDropDownList> {
  bool _expanded = false;
  String textValue = '';
  String? value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    for (var item in widget.items) {
      if (item.id == value) {
        textValue = item.description;
      }
    }

    var header = Row(children: [
      SizedBox(
          width: 350,
          child: WaterlooTextField(
            label: 'Hello Drop Down',
            initialValue: textValue,
            readOnly: true,
          )),
      IconButton(
        icon: const Icon(Icons.keyboard_arrow_down),
        onPressed: () {
          setState(() {
            _expanded = !_expanded;
          });

        },
      )
    ]);

    if (_expanded) {
      var widgets = <Widget>[];
      widgets.add(header);
      for (var item in widget.items) {
        widgets.add(Align(
          child: ListTile(
            title: Text(item.description),
            onTap: () {
              setState(() {
                _expanded = false;
                value = item.id;
                widget.valueBinder(item.id);
              });
            },
          ),
          alignment: Alignment.topLeft,
        ));
      }
      return Column(mainAxisAlignment: MainAxisAlignment.start, children: widgets);
    } else {
      return header;
    }
  }
}

class ListItem {
  final String id;
  final String description;

  ListItem(this.id, this.description);
}