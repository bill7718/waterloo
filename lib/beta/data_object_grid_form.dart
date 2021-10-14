import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/beta/waterloo_event_handler.dart';
import 'package:waterloo/beta/waterloo_form_container.dart';
import 'package:waterloo/beta/waterloo_journey_scaffold.dart';
import 'package:waterloo/src/waterloo_form_message.dart';
import 'package:waterloo/beta/waterloo_grid.dart';
import 'package:waterloo/src/waterloo_text_button.dart';
import 'package:waterloo/src/waterloo_text_provider.dart';
import 'package:waterloo/src/waterloo_theme.dart';

class DataObjectGridForm extends StatelessWidget {
  final List<DataObject> data;
  final GlobalKey formKey = GlobalKey();
  final WaterlooEventHandler eventHandler;
  final List<EventSpecification> events;
  final String formMessage;
  final String formTitle;
  final String? formSubtitle;
  final bool act;
  final List<Widget> children;
  final double? minimumColumnWidth;
  final double? maximumColumnWidth;
  final int? preferredColumnCount;
  final int? maximumColumnCount;
  final double? preferredColumnWidth;
  final double? columnSeparation;
  final double? rowSeparation;
  final String? initialError;

  /// If true then the form checks that all the data objects are valid before they are returned to the
  /// event handler. Allows cross field validation to be easily applied at the data object level.
  ///
  /// Defaults to true. Set to false if this page leaves the data object invalid or if
  /// it does not capture all the mandatory data for the objects
  final bool validateDataObjects;

  DataObjectGridForm(
      {Key? key,
      required this.eventHandler,
      required this.data,
      required this.events,
      required this.formTitle,
      this.formSubtitle,
      this.act = false,
      this.formMessage = '',
        this.initialError,
      required this.children,
      this.minimumColumnWidth,
      this.maximumColumnWidth,
      this.maximumColumnCount,
      this.preferredColumnWidth,
      this.preferredColumnCount,
      this.rowSeparation,
      this.columnSeparation,
      this.validateDataObjects = true})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    var error = FormError();
    error.error = initialError ?? '';
    widgets.add(WaterlooGridChild(
        layoutRule: WaterlooGridChildLayoutRule.full,
        child: WaterlooFormMessage(error: error, text: Provider.of<WaterlooTextProvider>(context, listen: false).get(formMessage) ?? '')));

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
              if (validateDataObjects) {
                for (var d in data) {
                  s ??= d.validate();
                }
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

    var grid = WaterlooGrid(
      children: widgets,
      maximumColumnCount: maximumColumnCount,
      minimumColumnWidth: minimumColumnWidth,
      maximumColumnWidth: maximumColumnWidth,
      preferredColumnCount: preferredColumnCount,
      preferredColumnWidth: preferredColumnWidth,
      pad: false,
      columnSeparation: columnSeparation,
      rowSeparation: rowSeparation,
    );

    return WaterlooJourneyScaffold(
        eventHandler: eventHandler,
        formKey: formKey,
        title: formTitle,
        subTitle: formSubtitle,
        child: grid);
  }
}

class WaterlooGridDivider extends StatelessWidget with HasWaterlooGridChildLayout {
  const WaterlooGridDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider();
  }

  @override
  WaterlooGridChildLayoutRule get layoutRule => WaterlooGridChildLayoutRule.full;
}

class WaterlooGridTextRow extends StatelessWidget with HasWaterlooGridChildLayout {
  final String text;

  const WaterlooGridTextRow({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }

  @override
  WaterlooGridChildLayoutRule get layoutRule => WaterlooGridChildLayoutRule.full;
}
