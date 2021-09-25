import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

class DataObjectCellContent extends StatelessWidget {
  final DataObject data;
  final String fieldName;
  final DataSpecification? dataSpecification;

  const DataObjectCellContent({Key? key, required this.data, required this.fieldName, this.dataSpecification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = data.get(fieldName);
    if (value is bool) {
      if (value) {
        return const Text('Yes');
      } else {
        return const Text('No');
      }
    }

    if (value == null && dataSpecification?.type == 'bool') {
      return const Text('No');
    }

    if ((dataSpecification?.list ?? []).isNotEmpty) {
      return Text(ListEntry.getDescription(value, dataSpecification!.list) ?? '');
    }

    if (dataSpecification?.type == 'date') {
      String dateValue = '';
      DateTime? d = toDateTime(value);
      if (d != null) {
        dateValue = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
        return Text(dateValue);
      } else {
        return Container();
      }
    }

    return Text(value);
  }
}