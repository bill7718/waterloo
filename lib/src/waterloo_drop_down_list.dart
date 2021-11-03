import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'waterloo_text_field.dart';
import 'waterloo_theme.dart';

/// {@template listItems}
/// The items to be selected. They should be sorted by the ancestor widget
/// {@endtemplate}


///
/// Shows a list of values as a [PopupMenuEntry] which wraps a [ListTile]
///
class WaterlooDropDownList extends StatefulWidget {

  /// {@macro listItems}
  final List<ListItem> items;

  /// The initial value to show
  final String? initialValue;

  /// The label of the field
  final String label;

  /// Binds the selected value to an external object
  final Function valueBinder;

  const WaterlooDropDownList({Key? key, required this.label, required this.items, required this.valueBinder, this.initialValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooDropDownListState();
}

class WaterlooDropDownListState extends State<WaterlooDropDownList> {
  /// The displayed value of the selected item
  String textValue = '';

  /// The current value of the selected item
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
      Expanded(
          child: WaterlooTextField(
        label: widget.label,
        initialValue: textValue,
        readOnly: true,
      )),
      SizedBox(
          width: Provider.of<WaterlooTheme>(context).waterlooDropDownListTheme.iconWidth,
          child: PopupMenuButton<ListItem>(
            icon: Icon(
              Provider.of<WaterlooTheme>(context).waterlooDropDownListTheme.dropIcon,
            ),
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
                    key: ValueKey(item.id),
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
          ))
    ]);
  }
}

///
/// Default parameters used by the [WaterlooDropDownList]
///
class WaterlooDropDownListTheme {

  /// The icon for the down arrow shown in the drop down list
  final IconData dropIcon;

  /// The width allocated to the drop down icon
  final double iconWidth;

  const WaterlooDropDownListTheme({this.dropIcon = Icons.keyboard_arrow_down, this.iconWidth = 50});
}
