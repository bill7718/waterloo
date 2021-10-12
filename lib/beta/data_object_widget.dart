import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'data_object_currency_field.dart';
import 'data_object_date_field.dart';
import '../src/data_object_drop_down_list.dart';
import 'data_object_list_manager.dart';
import 'data_object_percent_field.dart';
import '../src/data_object_text_field.dart';
import 'data_object_radio_list.dart';
import '../src/waterloo_drop_down_list.dart';
import 'data_object_switch_tile.dart';

class DataObjectWidget extends StatelessWidget {
  final DataObject data;
  final String fieldName;
  final Map<String, DataSpecification> specifications;

  const DataObjectWidget({Key? key, required this.data, required this.fieldName, required this.specifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    if (specifications[fieldName]?.type == DataSpecification.boolType) {
      return DataObjectSwitchTile(
        label: specifications[fieldName]?.label ?? fieldName,
        data: data,
        fieldName: fieldName,
      );
    }

    if (specifications[fieldName]?.type == DataSpecification.listType) {
      var items = <ListItem>[];
      for (var entry in specifications[fieldName]!.list) {
        items.add(ListItem(entry.id, entry.description));
      }
      return DataObjectDropDownList(
          label: specifications[fieldName]?.label ?? fieldName, data: data, fieldName: fieldName, items: items);
    }

    if (specifications[fieldName]?.type == DataSpecification.radioListType) {
      var items = <ListItem>[];
      for (var entry in specifications[fieldName]!.list) {
        items.add(ListItem(entry.id, entry.description));
      }
      return DataObjectRadioList(
          label: specifications[fieldName]?.label ?? fieldName, data: data, fieldName: fieldName, items: items);
    }

    if (specifications[fieldName]?.type == DataSpecification.dateType) {
      return DataObjectDateField(
        label: specifications[fieldName]?.label ?? fieldName,
        data: data,
        fieldName: fieldName,
        help: specifications[fieldName]?.help ?? '',
        maxDurationAfter: specifications[fieldName]?.maxDurationAfter,
        maxDurationBefore: specifications[fieldName]?.maxDurationBefore,
      );
    }

    if (specifications[fieldName]?.type == 'currency') {
      return DataObjectCurrencyField(
        label: specifications[fieldName]?.label ?? fieldName,
        data: data,
        fieldName: fieldName,
        help: specifications[fieldName]?.help ?? '',
      );
    }

    if (specifications[fieldName]?.type == 'percent') {
      return DataObjectPercentField(
        label: specifications[fieldName]?.label ?? fieldName,
        data: data,
        fieldName: fieldName,
        help: specifications[fieldName]?.help ?? '',
      );
    }

    if (specifications[fieldName]?.type == DataSpecification.dataObjectListType) {
      return DataObjectListManager(
        data: data,
        fieldName: fieldName,
          specifications: specifications

      );
    }

    return DataObjectTextField(
      label: specifications[fieldName]?.label ?? fieldName,
      data: data,
      fieldName: fieldName,
      obscure: specifications[fieldName]?.obscure ?? false,
      help: specifications[fieldName]?.help ?? '',
      validator: v,
    );
  }

  String? v(String? v) => specifications[fieldName]?.validator(v);
}

