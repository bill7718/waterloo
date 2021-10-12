import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/data_object_widgets.dart';
import 'package:waterloo/src/waterloo_text_provider.dart';
import 'package:waterloo/src/waterloo_theme.dart';
import 'data_object_cell_content.dart';

import '../src/change_notifier_list.dart';

class DataObjectTable<T extends DataObject> extends StatelessWidget {
  final ChangeNotifierList<T> data;
  final Map<String, DataSpecification> specifications;
  final List<String> fieldNames;
  final bool edit;
  final bool delete;

  const DataObjectTable(
      {Key? key,
      required this.data,
      required this.specifications,
      required this.fieldNames,
      this.edit = false,
      this.delete = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeNotifierList<T>>.value(
        value: data,
        child: Consumer<ChangeNotifierList<T>>(builder: (context, l, _) {
          var columns = <DataColumn>[];
          for (var field in fieldNames) {
            columns.add(
                DataColumn(label: Text(Provider.of<WaterlooTextProvider>(context).get(specifications[field]?.label ?? field) ?? '')));
          }
          if (edit) {
            columns.add(
                const DataColumn(label: Text('')));
          }

          if (delete) {
            columns.add(
                const DataColumn(label: Text('')));
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

            if (edit) {
              cells.add(DataCell(IconButton(
                icon: Icon(Provider.of<WaterlooTheme>(context).tableTheme.editIcon),
                onPressed: () {
                  showDataObjectDialog(
                      context, [item], [item.fields], specifications, (d) {
                    data.replaceAll(data.list);
                  });
                },
              )));
            }

            if (delete) {
              cells.add(DataCell(IconButton(
                icon: Icon(Provider.of<WaterlooTheme>(context).tableTheme.deleteIcon),
                onPressed: () {
                  showDataObjectDeleteDialog(context, item, (d) {
                    if (d) {
                      data.remove(item);
                    }
                  });
                },
              )));
            }

            rows.add(DataRow(cells: cells));
          }

          if (rows.isNotEmpty) {
            return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: columns, rows: rows));
          } else {
            return Container();
          }
        }));
  }
}


class DataObjectTableTheme {
  final IconData editIcon;
  final IconData deleteIcon;

  const DataObjectTableTheme({this.editIcon = Icons.edit, this.deleteIcon = Icons.delete });
}