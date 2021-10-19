import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/beta/waterloo_grid_form.dart';
import 'package:waterloo/waterloo.dart';
import 'waterloo_event_handler.dart';

class DataObjectForm extends StatelessWidget {
  final List<DataObject> data;
  final GlobalKey formKey = GlobalKey();
  final WaterlooEventHandler eventHandler;
  final List<EventSpecification> events;
  final String formMessage;
  final String formTitle;
  final String? formSubtitle;
  final bool act;
  final List<Widget> children;
  final String? initialError;

  DataObjectForm({
    Key? key,
    required this.eventHandler,
    required this.data,
    required this.events,
    required this.formTitle,
    this.formSubtitle,
    this.act = false,
    this.formMessage = '',
    this.initialError,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WaterlooGridForm(
        eventHandler: eventHandler,
        payload: data,
        events: events,
        formTitle: formTitle,
        formSubtitle: formSubtitle,
        formMessage: formMessage,
        initialError: initialError,
        children: children,
        preferredColumnCount: 1,
        act: act);
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
