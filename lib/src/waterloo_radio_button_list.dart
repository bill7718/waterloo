import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/waterloo_text_provider.dart';


///
/// Shows a list of radio buttons
///
class WaterlooRadioButtonList extends StatefulWidget {

  /// {@macro listItems}
  final List<ListItem> items;

  /// The initial value to show
  final String? initialValue;

  /// The label of the field
  final String label;

  /// Binds the selected value to an external object
  final Function valueBinder;

  const WaterlooRadioButtonList({Key? key, required this.label, required this.items, required this.valueBinder, this.initialValue}) : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooRadioButtonListState();
}

///
/// The State object corresponding to  [WaterlooRadioButtonList]
///
class WaterlooRadioButtonListState extends State<WaterlooRadioButtonList> {
  String? value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(Text(Provider.of<WaterlooTextProvider>(context, listen: false).get(widget.label) ?? ''));

    for (var item in widget.items) {
      widgets.add(RadioListTile<String>(
        title: Text(item.description),
        value: item.id,
        groupValue: value,
        onChanged: (v) {
          setState(() {
            value = v;
            widget.valueBinder(v);
          });
        },
      ));
    }

    return Column(children: widgets, crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start);
  }
}
