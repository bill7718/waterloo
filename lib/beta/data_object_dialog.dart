import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/waterloo_text_provider.dart';
import 'data_object_grid.dart';
import 'waterloo_event_handler.dart';
import '../src/waterloo_text_button.dart';

import '../alpha/data_object_form.dart';

class DataObjectDialog extends StatelessWidget {
  final List<DataObject> data;
  final List<List<String>> fieldNames;
  final Map<String, DataSpecification> specifications;
  final String? title;
  final Function? validator;

  const DataObjectDialog({Key? key, this.validator, required this.data, required this.fieldNames, required this.specifications, this.title = 'Dialog'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: DataObjectForm(
      formTitle: Provider.of<WaterlooTextProvider>(context, listen: false).get(title) ?? '',
      data: data,
      eventHandler: DataObjectDialogEventHandler(),
      events:  [
        const EventSpecification(event: 'cancel', description: 'Cancel', mustValidate: false),
        EventSpecification(event: 'Ok', description: 'Ok', additionalValidation: validator),
      ],
      children: dataObjectGridBuilder(data, fieldNames, specifications),
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
  void handleException(context, dynamic ex, StackTrace? st) {
    Navigator.pop(context, ex);
  }
}

void showDataObjectDialog(
    BuildContext context, List<DataObject> data, List<List<String>> fieldNames, String? title,
    Map<String, DataSpecification> specifications, Function callback, { Function? validator }) {
  var f = showDialog(
      context: context,
      builder: (context) {
        return DataObjectDialog(data: data, fieldNames: fieldNames, specifications: specifications, title: title, validator: validator,);
      });

  f.then((r) {
    callback(r);
  });
}


void showDataObjectDeleteDialog(BuildContext context, DataObject data, Function callback) {
  var f = showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Card(
              child: Column(
            children: [
              const Text('Confirm Delete'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  WaterlooTextButton(
                      text: 'Confirm',
                      exceptionHandler: () {},
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                  WaterlooTextButton(
                      text: 'Cancel',
                      exceptionHandler: () {},
                      onPressed: () {
                        Navigator.pop(context, false);
                      })
                ],
              )
            ],
          )),
        );
      });

  f.then((r) {
    callback(r);
  });
}
