import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/waterloo.dart';
import 'data_object_widget.dart';
import 'waterloo_event_handler.dart';
import 'waterloo_form_message.dart';
import 'waterloo_grid.dart';
import 'waterloo_text_button.dart';
import 'waterloo_theme.dart';

class DataObjectForm extends StatelessWidget {
  final List<DataObject> data;
  final List<List<String>> fieldNames;
  final Map<String, DataSpecification> specifications;
  final GlobalKey formKey = GlobalKey();
  final WaterlooEventHandler eventHandler;
  final List<EventSpecification> events;
  final String formHeaderText;

  DataObjectForm(
      {Key? key,
      required this.eventHandler,
      required this.data,
      required this.fieldNames,
      required this.specifications,
      required this.events,
      this.formHeaderText = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    var error = FormError();
    widgets.add(WaterlooFormMessage(
      error: error,
      text: formHeaderText,
    ));
    var i = 0;
    while (i < data.length) {
      widgets.add(DataObjectGrid(
        data: data[i],
        fieldNames: fieldNames[i],
        specifications: specifications,
      ));
      i++;
    }

    var buttons = <Widget>[];
    for (var event in events) {
      buttons.add(WaterlooTextButton(
        text: event.description,
        exceptionHandler: eventHandler.handleException,
        onPressed: () {
          if (event.mustValidate) {
            var formState = formKey.currentState as FormState;
            if (formState.validate()) {
              eventHandler.handleEvent(context,
                  event: event.event, output: data);
            }
          } else {
            eventHandler.handleEvent(context, event: event.event, output: data);
          }
        },
      ));
    }

    widgets.add(WaterlooGridRow(children: buttons));

    return WaterlooFormContainer(
      children: widgets,
      formKey: formKey,
    );
  }
}

class DataObjectGrid extends StatelessWidget {
  final DataObject data;
  final List<String> fieldNames;
  final Map<String, DataSpecification> specifications;

  const DataObjectGrid(
      {Key? key,
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
          specifications: specifications,
          fieldName: field,
        ));
      }
    }

    return WaterlooGrid(
        children: widgets,
        minimumColumnWidth: Provider.of<WaterlooTheme>(context)
            .dataObjectFormTheme
            .minimumColumnWidth,
        pad: false);
  }
}

class DataObjectFormTheme {
  final double minimumColumnWidth;
  final EdgeInsets margin;

  const DataObjectFormTheme(
      {this.minimumColumnWidth = 401,
      this.margin = const EdgeInsets.fromLTRB(20, 20, 20, 20)});
}
