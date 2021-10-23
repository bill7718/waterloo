import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'waterloo_text_field.dart';
import 'waterloo_theme.dart';

/// {@template maxDurationBefore}
/// Used by the calendar widget to control the smallest allowable date that can be selected.
/// Specified as a duration relative to the current date/time.
/// {@endtemplate}
///
///
/// {@template maxDurationAfter}
/// Used by the calendar widget to control the largest allowable date that can be selected.
/// Specified as a duration relative to the current date/time.
/// {@endtemplate}


///
/// A [WaterlooTextField] that allows input of a date.
///
/// It includes an icon that opens a date selection dialog so that the user
/// can select the date or enter it directly.
///
class WaterlooDateField extends StatefulWidget {

  /// {@macro label}
  final String label;

  /// {@macro maxDurationAfter}
  final Duration? maxFutureDuration;

  /// {@macro maxDurationBefore}
  final Duration? maxPastDuration;

  /// {@macro initialValue}
  ///
  ///
  /// This class converts to a DD/MM/YYYY date
  /// and passes it to the initialValue in the [WaterlooTextField]
  final DateTime? initialValue;

  /// Optional help - passed directly to the [WaterlooTextField]
  final String help;

  /// Passed directly to the [WaterlooTextField] - defaults to [false]
  /// If true then the icon which opens the Calendar widget is not shown
  final bool readOnly;

  /// {@macro valueBinder}
  ///
  ///
  /// The date is passed on as a [DateTime] object
  final Function valueBinder;

  /// Validates the entered value. Returns an error message
  /// This widget validates that the date is a valid date and then applies the
  /// validation specified in this parameter.
  final FormFieldValidator<String> validator;

  const WaterlooDateField(
      {Key? key,
      required this.label,
      this.initialValue,
      this.help = '',
      this.readOnly = false,
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
    var calendar = Provider.of<Calendar>(context);

    if (widget.readOnly) {
      return WaterlooTextField(label: widget.label, initialValue: dateValue, readOnly: true, help: widget.help);
    }

    return Row(children: [
      Expanded(
          child: WaterlooTextField(
              label: widget.label,
              initialValue: dateValue,
              readOnly: widget.readOnly,
              help: widget.help,
              hint: Provider.of<WaterlooTheme>(context).dateFieldTheme.dateHint,
              valueBinder: (v) {
                if (validateDDMMYYYY(v)) {
                  value = ddmmyyyyToDateTime(v);
                  widget.valueBinder(value);
                }
              },
              validator: (v) {
                var valid = validateDDMMYYYY(v);
                var error = valid ? widget.validator(v) : formatError;
                return error;
              })),
      if (!widget.readOnly)
        SizedBox(
            width: Provider.of<WaterlooTheme>(context, listen: false).dateFieldTheme.iconWidth,
            child: IconButton(
              icon: Icon(
                Provider.of<WaterlooTheme>(context, listen: false).dateFieldTheme.dateIcon,
              ),
              onPressed: () {
                var f = showDatePicker(
                  context: context,
                  initialDate: value ?? DateTime.now(),
                  firstDate:
                  calendar.now.subtract(widget.maxPastDuration ?? Provider.of<WaterlooTheme>(context, listen: false).dateFieldTheme.past),
                  lastDate: calendar.now.add(widget.maxFutureDuration ?? Provider.of<WaterlooTheme>(context, listen: false).dateFieldTheme.future),
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

///
/// Default parameters used by the [WaterlooDateField]
///
class WaterlooDateFieldTheme {
  /// The width to apply to the date input field
  final double inputFieldWidth;

  /// The icon which the user selects to open the calendar widget
  final IconData dateIcon;

  /// The width allocated to the icon
  final double iconWidth;

  /// The input field hint - defaults to dd/mm/yyyy
  final String dateHint;

  /// Default value for the [maxPastDuration] parameter
  final Duration past;

  /// Default value for the [maxFutureDuration] parameter
  final Duration future;

  const WaterlooDateFieldTheme(
      {this.inputFieldWidth = 250,
      this.dateIcon = Icons.calendar_today_outlined,
      this.dateHint = 'dd/mm/yyyy',
      this.iconWidth = 50,
      this.past = const Duration(days: 99999),
      this.future = const Duration(days: 99999)});
}



