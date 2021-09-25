
abstract class WaterlooEventHandler {

  Future<void> handleEvent( dynamic context,
      {String event = '', dynamic output });

  ///
  /// Process an Exception thrown by the Application
  ///
  void handleException(dynamic context, Exception ex, StackTrace? st );
}