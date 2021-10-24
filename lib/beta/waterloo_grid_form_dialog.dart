import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/beta/waterloo_event_handler.dart';

import 'waterloo_grid_form.dart';

class WaterlooGridFormDialog extends StatelessWidget {
  final dynamic payload;
  final String formMessage;
  final String formTitle;
  final String? formSubtitle;
  final List<Widget> children;
  final double? minimumColumnWidth;
  final double? maximumColumnWidth;
  final int? preferredColumnCount;
  final int? maximumColumnCount;
  final double? preferredColumnWidth;
  final double? columnSeparation;
  final double? rowSeparation;

  /// If true then the form checks that all the data objects are valid before they are returned to the
  /// event handler. Allows cross field validation to be easily applied at the data object level.
  ///
  /// Defaults to true. Set to false if this page leaves the data object invalid or if
  /// it does not capture all the mandatory data for the objects
  final bool validatePayload;

  const WaterlooGridFormDialog(
      {Key? key,
      required this.payload,
      required this.formTitle,
      this.formSubtitle,
      this.formMessage = '',
      required this.children,
      this.minimumColumnWidth,
      this.maximumColumnWidth,
      this.maximumColumnCount,
      this.preferredColumnWidth,
      this.preferredColumnCount,
      this.rowSeparation,
      this.columnSeparation,
      this.validatePayload = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var handler = DialogEventHandler();

    // Provide the dialog handler so that child widgets of Waterloo Grid form can access the correct EventHandler
    return Provider<WaterlooEventHandler>.value(
        value: handler,
        child: Dialog(
          child: WaterlooGridForm(
              eventHandler: handler,
              events: const [
                EventSpecification(event: 'Cancel', description: 'Cancel', mustValidate: false),
                EventSpecification(event: 'Ok', description: 'Ok', mustValidate: true),
              ],
              payload: payload,
              formTitle: formTitle,
              formSubtitle: formSubtitle,
              act: false,
              children: children,
              minimumColumnWidth: minimumColumnWidth,
              maximumColumnWidth: maximumColumnWidth,
              maximumColumnCount: maximumColumnCount,
              preferredColumnWidth: preferredColumnWidth,
              preferredColumnCount: preferredColumnCount,
              rowSeparation: rowSeparation,
              columnSeparation: columnSeparation,
              validatePayload: validatePayload),
        ));
  }
}

void showWaterlooGridFormDialog(BuildContext context,
    {required dynamic payload,
    required String formTitle,
    String formSubtitle = '',
    required Function callback,
    String formMessage = '',
    required List<Widget> children,
    double? minimumColumnWidth,
    double? maximumColumnWidth,
    int? maximumColumnCount,
    int? preferredColumnWidth,
    int? preferredColumnCount,
    double? rowSeparation,
    double? columnSeparation,
    bool validatePayload = true}) {
  var f = showDialog(
      context: context,
      builder: (context) {
        return WaterlooGridFormDialog(
          payload: payload,
          children: children,
          formTitle: formTitle,
          formSubtitle: formSubtitle,
          formMessage: formMessage,
          minimumColumnWidth: minimumColumnWidth,
          maximumColumnWidth: maximumColumnWidth,
          maximumColumnCount: maximumColumnCount,
          preferredColumnCount: preferredColumnCount,
          rowSeparation: rowSeparation,
          columnSeparation: columnSeparation,
          validatePayload: validatePayload,
        );
      });

  f.then((r) {
    callback(r);
  });
}
