import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/waterloo_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../src/waterloo_theme.dart';

class WaterlooPercentField extends StatefulWidget {
  final String label;
  final int? initialValue;
  final int decimalPlaces;

  final Function valueBinder;

  /// Validates the entered value. Returns an error message
  final FormFieldValidator<String> validator;

  const WaterlooPercentField(
      {Key? key,
      required this.label,
      this.initialValue,
      this.decimalPlaces = 0,
      this.valueBinder = WaterlooTextField.emptyBinder,
      this.validator = WaterlooTextField.emptyValidator})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooPercentFieldState();
}

class WaterlooPercentFieldState extends State<WaterlooPercentField> {
  static const String error = 'Please enter a number between zero and 99';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decimalPlaces =
        Provider.of<WaterlooTheme>(context).percentFieldTheme.decimalPlaces;

    final decimalPoint =
        Provider.of<WaterlooTheme>(context).percentFieldTheme.decimalPoint;

    return Row(children: [
      WaterlooTextField(
        label: widget.label,
        initialValue:
            toDecimal(widget.initialValue, decimalPlaces, decimalPoint),
        valueBinder: (v) {
          if (validatePercentAmount(v, decimalPlaces, decimalPoint) == null) {
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
          var s = validatePercentAmount(v, decimalPlaces, decimalPoint);
          if (s != null) {
            return widget.validator(v);
          }
        },
      ),
      SizedBox(
          width: Provider.of<WaterlooTheme>(context)
              .percentFieldTheme
              .iconFieldWidth,
          child: FaIcon(Provider.of<WaterlooTheme>(context)
              .percentFieldTheme
              .percentIcon)),
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

  String? validatePercentAmount(
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

    var n = int.parse(l.first);
    if (n < 0 || n > 99) {
      return error;
    }

    return null;
  }
}

class WaterlooPercentFieldTheme {
  final double inputFieldWidth;
  final double iconFieldWidth;
  final IconData percentIcon;
  final int decimalPlaces;
  final String decimalPoint;

  const WaterlooPercentFieldTheme(
      {this.inputFieldWidth = 250,
      this.iconFieldWidth = 50,
      this.percentIcon = FontAwesomeIcons.percent,
      this.decimalPlaces = 0,
      this.decimalPoint = '.'});
}
