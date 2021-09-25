import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'data_object_widget.dart';
import 'waterloo_event_handler.dart';
import 'waterloo_grid.dart';
import 'waterloo_text_button.dart';
import 'waterloo_theme.dart';

class DataObjectForm extends StatelessWidget {
  final DataObject data;
  final List<String> fieldNames;
  final Map<String, DataSpecification> specifications;
  final GlobalKey formKey = GlobalKey();
  final WaterlooEventHandler eventHandler;

  DataObjectForm(
      {Key? key,
      required this.eventHandler,
      required this.data,
      required this.fieldNames,
      required this.specifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (var field in fieldNames) {
      if (specifications[field] != null) {
        widgets.add(DataObjectWidget(
          data: data,
          dataSpecification: specifications[field]!,
          fieldName: field,
        ));
      }
    }

    widgets.add(WaterlooGridRow(children: [
      WaterlooTextButton(
          text: 'Cancel',
          exceptionHandler: eventHandler.handleException,
          onPressed: () {
            eventHandler.handleEvent(context, event: 'Cancel');
          }),
      WaterlooTextButton(
          text: 'Ok',
          exceptionHandler: eventHandler.handleException,
          onPressed: () {
            var formState = formKey.currentState as FormState;
            if (formState.validate()) {
              eventHandler.handleEvent(context, event: 'Ok', output: data);
            }
          })
    ]));

    return Form(
        key: formKey,
        child: Card(
            margin: Provider.of<WaterlooTheme>(context).dataObjectFormTheme.margin,
            child: Container(
                margin: Provider.of<WaterlooTheme>(context).dataObjectFormTheme.margin,
                child: WaterlooGrid(
                  children: widgets,
                  minimumColumnWidth: Provider.of<WaterlooTheme>(context).dataObjectFormTheme.minimumColumnWidth,
                  pad: false,
                )
                //child: GridView.count(crossAxisCount: 1, children: children,))
                )));
  }
}

class DataObjectFormTheme {
  final double minimumColumnWidth;
  final EdgeInsets margin;

  const DataObjectFormTheme({this.minimumColumnWidth = 401, this.margin = const EdgeInsets.fromLTRB(20, 20, 20, 20)});
}
