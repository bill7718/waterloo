

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo.dart';

class WaterlooEventButton extends StatelessWidget {

  final String text;
  final String event;
  final Function? payload;
  final GlobalKey? formKey;
  final Function? validator;

  const WaterlooEventButton({Key? key, required this.text, required this.event, this.payload, this.formKey, this.validator }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var handler  = Provider.of<WaterlooEventHandler>(context);

    return WaterlooTextButton(text: text, exceptionHandler: handler.handleException, onPressed: () {
      if (formKey != null) {
        var formState = formKey!.currentState as FormState;
        if (!formState.validate()) {
          return;
        }
      }

      if (validator != null) {
        if (!validator!()) {
          return;
        }
      }

      handler.handleEvent(context, event: event, output: payload == null ? null : payload!());
    });

  }



}