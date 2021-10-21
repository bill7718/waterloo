
import 'dart:async';
import 'package:flutter/material.dart';

abstract class WaterlooEventHandler {

  Future<void> handleEvent( dynamic context,
      {String event = '', dynamic output });

  ///
  /// Process an Exception thrown by the Application
  ///
  void handleException(dynamic context, dynamic ex, StackTrace? st );
}

class DialogEventHandler implements WaterlooEventHandler {
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
    Navigator.pop(context, DialogException(ex.toString()));
  }
}

class DialogException implements Exception {
  final String _message;

  DialogException(this._message);

  @override
  String toString() => _message;
}

class EventSpecification {

  final String event;
  final bool mustValidate;
  final String description;
  final Function? additionalValidation;

  const EventSpecification({ required this.event, required this.description, this.mustValidate = true, this.additionalValidation });

  factory EventSpecification.from(EventSpecification specification, { String? event, String? description, Function? additionalValidation }) {
    return EventSpecification(event: event ?? specification.event, description: description = description ?? specification.description,
    additionalValidation: additionalValidation ?? specification.additionalValidation);
  }

  static List<EventSpecification> addValidator(List<EventSpecification> events, Function validator) {
    var response = <EventSpecification>[];
    for (var event in events) {
      if (event.mustValidate) {
        response.add(EventSpecification.from(event, additionalValidation: validator));
      } else {
        response.add(event);
      }
    }

    return response;
  }

}