import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'waterloo_text_field.dart';
import 'waterloo_theme.dart';

class WaterlooDateField extends StatefulWidget {
  final String label;
  final Duration maxFutureDuration;
  final Duration maxPastDuration;
  final DateTime? initialValue;

  final Function valueBinder;

  const WaterlooDateField(
      {Key? key,
      required this.label,
      this.initialValue,
      this.valueBinder = emptyBinder,
      this.maxFutureDuration = const Duration(),
      this.maxPastDuration = const Duration()})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooDateFieldState();

  static void emptyBinder(DateTime? v) {}
}

class WaterlooDateFieldState extends State<WaterlooDateField> {
  static const String error = 'Please enter a valid date in the form dd/mm/yyyy(e.g 12/11/2014)';

  static const List<int> monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  static const List<int> leapMonthDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  DateTime first = DateTime.now();
  DateTime last = DateTime.now();
  DateTime initial = DateTime.now();

  DateTime? value;

  @override
  void initState() {
    value = widget.initialValue;

    first = DateTime.now().subtract(widget.maxPastDuration);
    last = DateTime.now().add(widget.maxFutureDuration);

    if (widget.initialValue?.isBefore(first) ?? false) {
      first = widget.initialValue!;
    }

    if (widget.initialValue?.isAfter(last) ?? false) {
      last = widget.initialValue!;
    }

    initial = widget.initialValue ?? initial;

    if (initial.isBefore(first)) {
      initial = first;
    }

    if (initial.isAfter(last)) {
      initial = last;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String dateValue = '';
    if (value != null) {
      dateValue = '${value?.day.toString().padLeft(2, '0')}/${value?.month.toString().padLeft(2, '0')}/${value?.year}';
    }

    return Row(children: [
      WaterlooTextField(
          label: widget.label,
          initialValue: dateValue,
          readOnly: false,
          hint: 'dd/mm/yyyy',
          width: Provider.of<WaterlooTheme>(context).dateFieldTheme.inputFieldWidth,
          valueBinder: (v) {
            if (validateDate(v) == null) {
              var split = v.split('/');
              var year = int.parse(split.last);
              if (year < 100) {
                year = year + 2000;
              }
              value = DateTime(int.parse(split.last), int.parse(split[1]), int.parse(split.first));
              widget.valueBinder(value);
            }
          },
          validator: (v) {
            return validateDate(v);
          }),
      SizedBox(
        width: 50,
      child: IconButton(
        icon: const Icon(Icons.calendar_today_outlined),
        onPressed: () {
          var f = showDatePicker(context: context, initialDate: initial, firstDate: first, lastDate: last);
          f.then((r) {
            if (r != null) {
              setState(() {
                widget.valueBinder(r);
                value = r;
              });
            }
          });
        },
      ))
    ]);
  }

  String? validateDate(String? v) {
    if (v != null) {
      var split = v.split('/');
      if (split.length != 3) {
        return error;
      }
      var year = int.tryParse(split.last);
      if (year == null) {
        return error;
      }
      var month = int.tryParse(split[1]);
      if (month == null) {
        return error;
      } else {
        if (month > 12 || month < 1) {
          return error;
        }
      }
      var day = int.tryParse(split.first);
      if (day == null) {
        return error;
      } else {
        if (day > 31 || day < 1) {
          return error;
        }
      }
      int y = year ~/ 4;
      if (y * 4 == year) {
        if (day > leapMonthDays[month - 1]) {
          return error;
        }
      } else {
        if (day > monthDays[month - 1]) {
          return error;
        }
      }
    }
    return null;
  }
}

class WaterlooDateFieldTheme {
  final double inputFieldWidth;

  const WaterlooDateFieldTheme({this.inputFieldWidth = 250 });
}