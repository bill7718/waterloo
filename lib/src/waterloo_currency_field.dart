import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'waterloo_text_field.dart';
import 'waterloo_text_provider.dart';
import 'waterloo_theme.dart';

class WaterlooCurrencyField extends StatefulWidget {
  final String label;
  final int? initialValue;
  final int decimalPlaces;

  final Function valueBinder;

  /// Validates the entered value. Returns an error message
  final FormFieldValidator<String> validator;

  const WaterlooCurrencyField(
      {Key? key,
      required this.label,
      this.initialValue,
      this.decimalPlaces = 2,
      this.valueBinder = WaterlooTextField.emptyBinder,
      this.validator = WaterlooTextField.emptyValidator})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooCurrencyFieldState();
}

class WaterlooCurrencyFieldState extends State<WaterlooCurrencyField> {
  static const String error = 'Please enter a valid  monetary amount';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decimalPlaces =
        Provider.of<WaterlooTheme>(context).currencyFieldTheme.decimalPlaces;

    final decimalPoint =
        Provider.of<WaterlooTheme>(context).currencyFieldTheme.decimalPoint;

    return Row(children: [
      WaterlooTextField(
        label: widget.label,
        initialValue:
            toDecimal(widget.initialValue, decimalPlaces, decimalPoint),
        width: Provider.of<WaterlooTheme>(context)
            .currencyFieldTheme
            .inputFieldWidth,
        valueBinder: (v) {
          if (validateCurrencyAmount(v, decimalPlaces, decimalPoint)) {
            int? amount = toAmount(v, decimalPlaces, decimalPoint);
            widget.valueBinder(amount);
          }
        },
        validator: (v) {
          var valid = validateCurrencyAmount(v, decimalPlaces, decimalPoint);
          var s = valid ?  widget.validator(v) : error;
          return s == null ? null : Provider.of<WaterlooTextProvider>(context).get(s);
        },
      )
    ]);
  }

  
  static String? toDecimal(int? v, int decimalPlaces, String decimalPoint) {
    if (v == null) {
      return null;
    }
    var s = v.toString().padLeft(decimalPlaces, '0');

    if (s.length == decimalPlaces) {
      return '0' + decimalPoint + s;
    }

    return s.substring(0, s.length - decimalPlaces) +
        decimalPoint +
        s.substring(s.length - decimalPlaces);
  }


}

class WaterlooCurrencyFieldTheme {
  final double inputFieldWidth;
  //final double iconFieldWidth;
  //final IconData currencyIcon;
  final int decimalPlaces;
  final String decimalPoint;

  const WaterlooCurrencyFieldTheme(
      {this.inputFieldWidth = 250,
      //this.iconFieldWidth = 50,
      //this.currencyIcon = FontAwesomeIcons.poundSign,
      this.decimalPlaces = 2,
      this.decimalPoint = '.'});
}
