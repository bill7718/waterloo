import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/waterloo_event_handler.dart';

import 'data_object_form.dart';

class DataObjectDialog extends StatelessWidget {
  final List<DataObject> data;
  final List<List<String>> fieldNames;
  final Map<String, DataSpecification> specifications;

  const DataObjectDialog(
      {Key? key,
      required this.data,
      required this.fieldNames,
      required this.specifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: DataObjectForm(
      data: data,
      fieldNames: fieldNames,
      specifications: specifications,
      eventHandler: DataObjectDialogEventHandler(),
      events: [
        EventSpecification(event: 'Ok', description: 'Ok'),
        EventSpecification(
            event: 'cancel', description: 'Cancel', mustValidate: false)
      ],
    ));
  }
}

class DataObjectDialogEventHandler implements WaterlooEventHandler {
  @override
  Future<void> handleEvent(context, {String event = '', output}) {
    var c = Completer<void>();
    if (event == 'Ok') {
      Navigator.pop(context, output);
    } else {
      Navigator.pop(context);
    }
    c.complete();
    return c.future;
  }

  @override
  void handleException(context, Exception ex, StackTrace? st) {
    Navigator.pop(context, ex);
  }
}

void showDataObjectDialog(
    BuildContext context,
    List<DataObject> data,
    List<List<String>> fieldNames,
    Map<String, DataSpecification> specifications,
    Function callback) {
  var f = showDialog(
      context: context,
      builder: (context) {
        return DataObjectDialog(
            data: data, fieldNames: fieldNames, specifications: specifications);
      });

  f.then((r) {
    callback(r);
  });
}
