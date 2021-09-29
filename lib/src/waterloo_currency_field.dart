import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'waterloo_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      SizedBox(
          width: Provider.of<WaterlooTheme>(context)
              .currencyFieldTheme
              .iconFieldWidth,
          child: FaIcon(Provider.of<WaterlooTheme>(context)
              .currencyFieldTheme
              .currencyIcon)),
      WaterlooTextField(
        label: widget.label,
        initialValue:
            toDecimal(widget.initialValue, decimalPlaces, decimalPoint),
        width: Provider.of<WaterlooTheme>(context)
            .currencyFieldTheme
            .inputFieldWidth,
        valueBinder: (v) {
          if (validateCurrencyAmount(v, decimalPlaces, decimalPoint) == null) {
            List<String> l = v.split(decimalPoint);
            while (l.length < 2) {
              l.add('0');
            }
            int amount = int.parse(l.first) * pow(10, decimalPlaces) as int;
            amount = amount + int.parse(l.last.padRight(decimalPlaces, '0'));
            widget.valueBinder(v);
          }
        },
        validator: (v) {
          var s = validateCurrencyAmount(v, decimalPlaces, decimalPoint);
          if (s != null) {
            return widget.validator(v);
          }
        },
      )
    ]);
  }

  String toDecimal(int? v, int decimalPlaces, String decimalPoint) {
    if (v == null) {
      return '';
    }
    var s = v.toString().padLeft(decimalPlaces, '0');

    if (s.length == decimalPlaces) {
      return '0' + decimalPoint + s;
    }

    return s.substring(0, s.length - decimalPlaces) +
        decimalPoint +
        s.substring(s.length - decimalPlaces);
  }

  String? validateCurrencyAmount(
      String? v, int decimalPlaces, String decimalPoint) {
    if (v == null) {
      return null;
    }

    List<String> l = v.split(decimalPoint);

    if (l.length > 2) {
      return error;
    }

    if (l.isEmpty) {
      return null;
    }

    if (l.length == 1) {
      l.add('0');
    }

    for (var i in l) {
      if (int.tryParse(i) == null) {
        return error;
      }
    }
    return null;
  }
}

class WaterlooCurrencyFieldTheme {
  final double inputFieldWidth;
  final double iconFieldWidth;
  final IconData currencyIcon;
  final int decimalPlaces;
  final String decimalPoint;

  const WaterlooCurrencyFieldTheme(
      {this.inputFieldWidth = 250,
      this.iconFieldWidth = 50,
      this.currencyIcon = FontAwesomeIcons.poundSign,
      this.decimalPlaces = 2,
      this.decimalPoint = '.'});
}
