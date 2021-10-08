import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'waterloo_text_field.dart';
import 'waterloo_text_provider.dart';
import 'waterloo_theme.dart';

///
/// A [WaterlooTextField] that allows input of a currency amount.
///
class WaterlooCurrencyField extends StatefulWidget {
  /// The text field label - passed directly to the [WaterlooTextField]
  final String label;

  /// The initial value to show in the field - this class converts to a String with a decimal point
  /// and passes it to the initialValue in the [WaterlooTextField]
  final int? initialValue;

  /// Optional help - passed directly to the [WaterlooTextField]
  final String help;

  /// Passed directly to the [WaterlooTextField] - defaults to [false]
  final bool readOnly;

  /// Binds this value to an external object. The value is exchanged as an integer
  final Function valueBinder;

  /// Validates the entered value. Returns an error message
  /// This widget validates that the value is a valid currency amount and then applies the
  /// validation specified in this parameter.
  final FormFieldValidator<String> validator;

  const WaterlooCurrencyField(
      {Key? key,
      required this.label,
      this.initialValue,
      this.help = '',
      this.readOnly = false,
      this.valueBinder = emptyBinder,
      this.validator = WaterlooTextField.emptyValidator})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooCurrencyFieldState();

  static void emptyBinder(int? v) {}
}

class WaterlooCurrencyFieldState extends State<WaterlooCurrencyField> {
  static const String formatError = 'currencyFormatError';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final decimalPlaces = Provider.of<WaterlooTheme>(context, listen: false).currencyFieldTheme.decimalPlaces;
    final decimalPoint = Provider.of<WaterlooTheme>(context, listen: false).currencyFieldTheme.decimalPoint;

    return Row(children: [
      WaterlooTextField(
        label: widget.label,
        readOnly: widget.readOnly,
        help: widget.help,
        initialValue: toDecimal(widget.initialValue, decimalPlaces, decimalPoint),
        valueBinder: (v) {
          if (validateCurrencyAmount(v, decimalPlaces, decimalPoint)) {
            int? amount = toAmount(v, decimalPlaces, decimalPoint);
            widget.valueBinder(amount);
          }
        },
        validator: (v) {
          var valid = validateCurrencyAmount(v, decimalPlaces, decimalPoint);
          var error = valid ? widget.validator(v) : formatError;
          return error == null ? null : Provider.of<WaterlooTextProvider>(context, listen: false).get(error);
        },
      )
    ]);
  }
}

///
/// Default parameters used by the [WaterlooCurrencyField]
///
class WaterlooCurrencyFieldTheme {

  /// The width to apply to the currency input field
  final double inputFieldWidth;

  /// The number of decimal places for the currency amount
  final int decimalPlaces;

  /// The character to use for the decimal point
  final String decimalPoint;

  const WaterlooCurrencyFieldTheme({this.inputFieldWidth = 250, this.decimalPlaces = 2, this.decimalPoint = '.'});
}
