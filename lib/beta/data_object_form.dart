import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/waterloo.dart';
import 'data_object_grid.dart';
import 'waterloo_event_handler.dart';
import 'waterloo_form_container.dart';
import '../src/waterloo_form_message.dart';
import 'waterloo_grid.dart';
import '../src/waterloo_text_button.dart';
import '../src/waterloo_theme.dart';
import '../src/waterloo_text_provider.dart';

class DataObjectForm extends StatelessWidget {
  final List<DataObject> data;
  final GlobalKey formKey = GlobalKey();
  final WaterlooEventHandler eventHandler;
  final List<EventSpecification> events;
  final String formMessage;
  final String formTitle;
  final String? formSubtitle;
  final bool act;
  final List<List<String>> fieldNames;
  final List<List<String>>? rebuildFieldNames;
  final Map<String, DataSpecification> specifications;
  final int? preferredColumnCount;

  DataObjectForm(
      {Key? key,
      required this.eventHandler,
      required this.data,
      required this.events,
      required this.formTitle,
      this.formSubtitle,
      this.act = false,
      this.formMessage = '',
      required this.fieldNames,
      required this.specifications,
      this.rebuildFieldNames,
      this.preferredColumnCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = _dataWidgetsBuilder();

    return BespokeDataObjectForm(
        data: data,
        eventHandler: eventHandler,
        events: events,
        formMessage: formMessage,
        formTitle: formTitle,
        formSubtitle: formSubtitle,
        act: act,
        children: children);
  }

  List<Widget> _dataWidgetsBuilder() {
    var widgets = <Widget>[];

    var i = 0;
    while (i < data.length) {
      widgets.add(DataObjectGrid(
        data: data[i],
        fieldNames: fieldNames[i],
        specifications: specifications,
        rebuildFields: rebuildFieldNames == null ? null : rebuildFieldNames![i],
        preferredColumnCount: preferredColumnCount,
      ));

      i++;
    }
    return widgets;
  }
}

class BespokeDataObjectForm extends StatelessWidget {
  final List<DataObject> data;
  final GlobalKey formKey = GlobalKey();
  final WaterlooEventHandler eventHandler;
  final List<EventSpecification> events;
  final String formMessage;
  final String formTitle;
  final String? formSubtitle;
  final bool act;
  final List<Widget> children;

  BespokeDataObjectForm({
    Key? key,
    required this.eventHandler,
    required this.data,
    required this.events,
    required this.formTitle,
    this.formSubtitle,
    this.act = false,
    this.formMessage = '',
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    var error = FormError();
    widgets.add(WaterlooFormMessage(error: error, text: Provider.of<WaterlooTextProvider>(context, listen: false).get(formMessage) ?? ''));

    widgets.addAll(children);

    var buttons = <Widget>[];
    for (var event in events) {
      buttons.add(WaterlooTextButton(
        text: event.description,
        exceptionHandler: eventHandler.handleException,
        onPressed: () {
          error.error = '';
          if (event.mustValidate) {
            var formState = formKey.currentState as FormState;
            if (formState.validate()) {
              var s = event.additionalValidation == null ? null : event.additionalValidation!();
              for (var d in data) {
                s ??= d.validate();
              }
              s == null
                  ? eventHandler.handleEvent(context, event: event.event, output: data)
                  : error.error = Provider.of<WaterlooTextProvider>(context, listen: false).get(s) ?? '';
            }
          } else {
            eventHandler.handleEvent(context, event: event.event, output: data);
          }
        },
      ));
    }

    widgets.add(WaterlooGridRow(children: buttons));

    return Scaffold(
        appBar: WaterlooAppBar.get(
            title: Provider.of<WaterlooTextProvider>(context, listen: false).get(formTitle) ?? '',
            context: context,
            subtitle: Provider.of<WaterlooTextProvider>(context, listen: false).get(formSubtitle) ?? '',
            handleAction: act
                ? () {
                    eventHandler.handleEvent(context, event: Provider.of<WaterlooTheme>(context, listen: false).dataObjectFormTheme.homeEvent);
                  }
                : null),
        body: WaterlooFormContainer(
          children: widgets,
          formKey: formKey,
        ));
  }
}

class DataObjectFormTheme {
  final double minimumColumnWidth;
  final double preferredColumnWidth;
  final EdgeInsets margin;
  final String homeEvent;

  const DataObjectFormTheme(
      {this.minimumColumnWidth = 299,
      this.preferredColumnWidth = 300,
      this.margin = const EdgeInsets.fromLTRB(20, 20, 20, 20),
      this.homeEvent = 'home'});
}
