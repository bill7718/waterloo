import 'waterloo_currency_field.dart';
import 'waterloo_date_field.dart';

///
/// A simple class that converts a [reference] into a text value
///
/// Intended for use with error messages and/or text fields on a screen
///
abstract class WaterlooTextProvider {

  ///
  /// Look a text value based on the reference passed
  ///
  /// Where the reference cannot be found we expect implementations to
  /// just return the [reference] value passed in
  ///
  /// Where the [reference] is null return null
  ///
  String? get(String? reference);

  ///
  /// Contains default text values for field references used by the Waterloo base widgets
  ///
  static const Map<String, String> defaultErrorMessages = <String, String>{
    WaterlooDateFieldState.formatError: 'Please enter a date in dd/mm/yyyy format',
    WaterlooCurrencyFieldState.formatError: 'Please enter a monetary amount'
  };
}
