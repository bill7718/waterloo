import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/waterloo_text_field.dart';
import '../src/waterloo_theme.dart';

///
/// Shows a list of values as a [PopupMenuEntry] which wraps a [ListTile]
///
class WaterlooDropDownList extends StatefulWidget {

  /// The items to be selected. They should be sorted by the ancestor widget
  final List<ListItem> items;

  /// The initial value to show
  final String? initialValue;

  /// The label of the field
  final String label;

  /// Binds the selected value to an external object
  final Function valueBinder;

  const WaterlooDropDownList(
      {Key? key, required this.label, required this.items, required this.valueBinder, this.initialValue})
      : super(key: key);

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

/// Contains the id and description of the data shown in a list
class ListItem {

  /// The id of a list item
  final String id;

  /// The description corresponding to the id
  final String description;

  ListItem(this.id, this.description);
}

class FutureWaterlooDropDownList extends StatelessWidget {

  final ListGetter getter;

  final String? initialValue;

  final String label;

  final Function valueBinder;

  const FutureWaterlooDropDownList(
      {Key? key, required this.label, required this.getter, required this.valueBinder, this.initialValue})
      : super(key: key);


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ListItem>>(future: getter.getList(), builder: (context, snapshot) {
      if (snapshot.hasData) {
        return WaterlooDropDownList(label: label, items: snapshot.data ?? [],
            valueBinder: valueBinder, initialValue: initialValue);
      } else {
        return WaterlooTextField(
          label: label,
          readOnly: true,
        );
      }
    });
  }


}

abstract class ListGetter {

  Future<List<ListItem>> getList();
}



class WaterlooDropDownListTheme {
  final double inputFieldWidth;
  final IconData dropIcon;

  const WaterlooDropDownListTheme({this.inputFieldWidth = 250, this.dropIcon =  Icons.keyboard_arrow_down });
}