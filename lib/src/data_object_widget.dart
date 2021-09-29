import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'data_object_currency_field.dart';
import 'data_object_date_field.dart';
import 'data_object_drop_down_list.dart';
import 'data_object_text_field.dart';
import 'waterloo_drop_drown_list.dart';
import 'data_object_switch_tile.dart';

class DataObjectWidget extends StatelessWidget {
  final DataObject data;
  final String fieldName;
  final DataSpecification dataSpecification;

  const DataObjectWidget({Key? key, required this.data, required this.fieldName, required this.dataSpecification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var value = data.get(fieldName);
    if (value is bool || (value == null && dataSpecification.type == 'bool')) {
      return DataObjectSwitchTile(
        label: dataSpecification.label ?? '',
        data: data,
        fieldName: fieldName,
      );
    }

    if (dataSpecification.list.isNotEmpty) {
      var items = <ListItem>[];
      for (var entry in dataSpecification.list) {
        items.add(ListItem(entry.id, entry.description));
      }
      return DataObjectDropDownList(
          label: dataSpecification.label ?? '', data: data, fieldName: fieldName, items: items);
    }

    if (dataSpecification.type == 'date') {
      return DataObjectDateField(
        label: dataSpecification.label ?? '',
        data: data,
        fieldName: fieldName,
        help: dataSpecification.help ?? '',
        maxDurationAfter: dataSpecification.maxDurationAfter,
        maxDurationBefore: dataSpecification.maxDurationBefore,
      );
    }

    if (dataSpecification.type == 'currency') {
      return DataObjectCurrencyField(
        label: dataSpecification.label ?? '',
        data: data,
        fieldName: fieldName,
        help: dataSpecification.help ?? '',
      );
    }

    return DataObjectTextField(
      label: dataSpecification.label ?? '',
      data: data,
      fieldName: fieldName,
      obscure: dataSpecification.obscure,
      help: dataSpecification.help ?? '',
      validator: v,
    );
  }

  String? v(String? v) => dataSpecification.validator(v);
}



class DataObjectCard extends StatelessWidget {


  final String? title;
  final DataObject data;
  final List<String> fieldNames;
  final Map<String, DataSpecification> dataSpecifications;

  const DataObjectCard({Key? key, this.title, required this.data, required this.fieldNames, required this.dataSpecifications})
      : super(key: key);


  @override
  Widget build(BuildContext context) {

    var widgets = <Widget>[];
    for (var field in fieldNames) {

      if (dataSpecifications[field] != null) {
        widgets.add(DataObjectWidget(data: data, dataSpecification: dataSpecifications[field]!, fieldName: field,));
      }
    }

    if (title == null) {
      return Card(
        child: Column(children: widgets, mainAxisAlignment: MainAxisAlignment.start,)
      );
    } else {
      return Card(
        child: Column (
          children: [
            Text(title!),
              Column(
              mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgets,)
          ],
        )
      );
    }


  }

}
