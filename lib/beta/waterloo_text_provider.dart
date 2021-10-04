import 'waterloo_date_field.dart';

abstract class WaterlooTextProvider {
  String? get(String? reference);

  static const Map<String, String> defaultErrorMessages = <String, String>{
    WaterlooDateFieldState.formatError: 'Please enter a date in dd/mm/yyyy format'
  };
}
