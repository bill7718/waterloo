import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'data_object_cell_content.dart';

import 'change_notifier_list.dart';

class DataObjectTable<T extends DataObject> extends StatelessWidget {
  final ChangeNotifierList<T> data;
  final Map<String, DataSpecification> specifications;
  final List<String> fieldNames;

  const DataObjectTable({Key? key, required this.data, required this.specifications, required this.fieldNames})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<ChangeNotifierList<T>>.value(
        value: data,
        child: Consumer<ChangeNotifierList<T>>(builder: (context, l, _) {
          var columns = <DataColumn>[];
          for (var field in fieldNames) {
            columns.add(DataColumn(label: Text(specifications[field]?.label ?? '')));
          }

          var rows = <DataRow>[];
          for (var item in data.list) {
            var cells = <DataCell>[];
            for (var field in fieldNames) {
              cells.add(DataCell(DataObjectCellContent(
                data: item,
                fieldName: field,
                dataSpecification: specifications[field],
              )));
            }
            rows.add(DataRow(cells: cells));
          }

          if (rows.isNotEmpty) {
            return DataTable(columns: columns, rows: rows);
          } else {
            return Container();
          }

        }));
  }
}
