import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'waterloo_text_field.dart';
import 'waterloo_theme.dart';

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
          WaterlooTextField(
            width: Provider.of<WaterlooTheme>(context).waterlooDropDownListTheme.inputFieldWidth,
            label: widget.label,
            initialValue: textValue,
            readOnly: true,
          ),
      PopupMenuButton<ListItem>(
        icon: Icon(Provider.of<WaterlooTheme>(context).waterlooDropDownListTheme.dropIcon,),
        onSelected: (item) {
          setState(() {
            value = item.id;
            widget.valueBinder(value);
          });
        },
        itemBuilder: (context) {
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

class WaterlooDropDownListTheme {
  final double inputFieldWidth;
  final IconData dropIcon;

  const WaterlooDropDownListTheme({this.inputFieldWidth = 250, this.dropIcon =  Icons.keyboard_arrow_down });
}