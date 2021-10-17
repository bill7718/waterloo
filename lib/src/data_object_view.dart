import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/waterloo_theme.dart';

///
/// A view only widget which displays the contents of a field in a [DataObject]
///
class DataObjectView extends StatelessWidget {

  ///
  /// The object containing the data to be shown
  ///
  final DataObject data;

  ///
  /// The field displayed in the widget
  ///
  final String fieldName;

  ///
  /// Specifies how the
  ///
  final DataSpecification? dataSpecification;

  const DataObjectView({Key? key, required this.data, required this.fieldName, this.dataSpecification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = data.get(fieldName);
    var theme = Provider.of<WaterlooTheme>(context).viewTheme;

    if (value == null) {
      return Container();
    }

    switch (dataSpecification?.dataType) {

      case DataSpecification.boolType:
        if (value) {
          return const Text('Yes');
        } else {
          return const Text('No');
        }

      case DataSpecification.currencyType:
        return Text(toDecimal(value, theme.numberOfDecimalPlaces, theme.decimalPointCharacter)!);

      case DataSpecification.textType:
        return Text(value);

      case DataSpecification.dateType:
        String dateValue = '';
        DateTime? d = toDateTime(value);
        dateValue = '${d?.day.toString().padLeft(2, '0')}/${d?.month.toString().padLeft(2, '0')}/${d?.year}';
        return Text(dateValue);

      case DataSpecification.listType:
        if ((dataSpecification?.list ?? []).isNotEmpty) {
          return Text(ListEntry.getDescription(value, dataSpecification!.list) ?? '');
        } else {
          return Container();
        }

      case DataSpecification.radioListType:
        if ((dataSpecification?.list ?? []).isNotEmpty) {
          return Text(ListEntry.getDescription(value, dataSpecification!.list) ?? '');
        } else {
          return Container();
        }

      case DataSpecification.integerType:
        return Text(value.toString());

      default:
        /// [dataObjectType] [dataObjectListType] [percentType]
        return Container();
    }
  }
}

///
/// Default parameters used by the [DataObjectView]
///
class DataObjectViewTheme {

  /// The number of decimal places in the view
  final int numberOfDecimalPlaces;

  /// The character to use for the decimal 'point'
  final String decimalPointCharacter;

  const DataObjectViewTheme({this.numberOfDecimalPlaces = 2, this.decimalPointCharacter = '.'});
}
