
abstract class WaterlooEventHandler {

  Future<void> handleEvent( dynamic context,
      {String event = '', dynamic output });

  ///
  /// Process an Exception thrown by the Application
  ///
  void handleException(dynamic context, dynamic ex, StackTrace? st );
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
}