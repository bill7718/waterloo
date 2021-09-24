import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'waterloo_text_button.dart';
import 'waterloo_text_field.dart';

class WaterlooDropDownList extends StatefulWidget {
  final List<ListItem> items;

  final String? initialValue;

  final String label;

  final Function valueBinder;

  const WaterlooDropDownList(
      {Key? key, required this.label, required this.items, required this.valueBinder, this.initialValue})
      : super(key: key);

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

    return Row(children: [
      SizedBox(
          width: 350,
          child: WaterlooTextField(
            label: widget.label,
            initialValue: textValue,
            readOnly: true,
          )),
      PopupMenuButton<ListItem>(
        icon: const Icon(Icons.keyboard_arrow_down),
        onSelected: (item) {
          setState(() {
            value = item.id;
          });
        },
        itemBuilder: (context) {
          //_expanded = !_expanded;
          var widgets = <PopupMenuItem<ListItem>>[];
          for (var item in widget.items) {
            widgets.add(PopupMenuItem<ListItem>(
                child: Align(
              child: ListTile(
                title: Text(item.description),
                onTap: () {
                  Navigator.pop(context, item);
                },
              ),
              alignment: Alignment.topLeft,
            )));
          }
          return widgets;
        },
      )
    ]);
  }
}

class ListItem {
  final String id;
  final String description;

  ListItem(this.id, this.description);
}
