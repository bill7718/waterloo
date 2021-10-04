import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import '../src/waterloo_text_field.dart';
import '../src/waterloo_text_provider.dart';
import '../src/waterloo_theme.dart';

class WaterlooDateField extends StatefulWidget {
  final String label;
  final Duration? maxFutureDuration;
  final Duration? maxPastDuration;
  final DateTime? initialValue;
  final String help;
  final bool readOnly;

  final Function valueBinder;

  /// Validates the entered value. Returns an error message
  final FormFieldValidator<String> validator;

  const WaterlooDateField(
      {Key? key,
      required this.label,
      this.initialValue,
      this.help = '',
      this.readOnly = true,
      this.valueBinder = emptyBinder,
        this.validator = WaterlooTextField.empty,
      this.maxFutureDuration,
      this.maxPastDuration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WaterlooDateFieldState();

  static void emptyBinder(DateTime? v) {}
}

class WaterlooDateFieldState extends State<WaterlooDateField> {
  static const String formatError = 'dateFormatError';

  DateTime? value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dateValue = dateTimeToDDMMYYYY(value) ?? '';

    return Row(children: [
      WaterlooTextField(
          label: widget.label,
          initialValue: dateValue,
          readOnly: widget.readOnly,
          help: widget.help,
          hint: Provider.of<WaterlooTheme>(context).dateFieldTheme.dateHint,
          width: widget.readOnly ? null : Provider.of<WaterlooTheme>(context).dateFieldTheme.inputFieldWidth,
          valueBinder: (v) {
            if (validateDDMMYYYY(v)) {
              value = ddmmyyyyToDateTime(v);
              widget.valueBinder(value);
            }
          },
          validator: (v) {
            var valid = validateDDMMYYYY(v);
            var error = valid ? widget.validator(v) : formatError;
            return Provider.of<WaterlooTextProvider>(context).get(error);
          }),
      if (!widget.readOnly) SizedBox(
          width: Provider.of<WaterlooTheme>(context).dateFieldTheme.iconWidth,
          child: IconButton(
            icon: Icon(
              Provider.of<WaterlooTheme>(context).dateFieldTheme.dateIcon,
            ),
            onPressed: () {
              var f = showDatePicker(context: context,
                  initialDate: value ?? DateTime.now(),
                  firstDate: DateTime.now().subtract(widget.maxPastDuration ?? Provider.of<WaterlooTheme>(context).dateFieldTheme.past),
                  lastDate: DateTime.now().add(widget.maxFutureDuration ?? Provider.of<WaterlooTheme>(context).dateFieldTheme.future),
              );
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
}

class WaterlooDateFieldTheme {
  final double inputFieldWidth;
  final IconData dateIcon;
  final double iconWidth;
  final String dateHint;
  final Duration past;
  final Duration future;

  const WaterlooDateFieldTheme(
      {this.inputFieldWidth = 250, this.dateIcon = Icons.calendar_today_outlined, this.dateHint = 'dd/mm/yyyy',
        this.iconWidth = 50, this.past = const Duration(days: 99999), this.future = const Duration(days: 99999) });
}
