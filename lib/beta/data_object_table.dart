import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/data_object_widgets.dart';
import 'package:waterloo/src/waterloo_text_provider.dart';
import 'package:waterloo/src/waterloo_theme.dart';
import 'data_object_view.dart';

import '../src/change_notifier_list.dart';

class DataObjectTable<T extends DataObject> extends StatelessWidget {
  final ChangeNotifierList<T> data;
  final Map<String, DataSpecification> specifications;

  final List<String> fieldNames;

  /// The field names to use in the dialog. If not provided then the default list of fields for the
  /// DataObject is used
  final List<String>? dialogFieldNames;

  final bool edit;
  final Function? editor;
  final bool delete;

  /// Title to use for the edit dialog if edit is enabled
  final String? title;

  const DataObjectTable(
      {Key? key,
      required this.data,
      required this.specifications,
      required this.fieldNames,
      this.dialogFieldNames,
      this.edit = false,
      this.editor,
      this.delete = false,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<WaterlooTheme>(context).tableTheme;
    return ChangeNotifierProvider<ChangeNotifierList<T>>.value(
        value: data,
        child: Consumer<ChangeNotifierList<T>>(builder: (context, l, _) {
          var columns = <DataColumn>[];
          for (var field in fieldNames) {
            columns.add(DataColumn(label: Text(Provider.of<WaterlooTextProvider>(context).get(specifications[field]?.label ?? field) ?? '')));
          }
          if (edit) {
            columns.add(const DataColumn(label: Text('')));
          }

          if (delete) {
            columns.add(const DataColumn(label: Text('')));
          }

          var rows = <DataRow>[];
          for (var item in data.list) {
            var cells = <DataCell>[];
            for (var field in fieldNames) {
              cells.add(DataCell(DataObjectView(
                data: item,
                fieldName: field,
                dataSpecification: specifications[field],
              )));
            }

            if (edit) {
              cells.add(DataCell(IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(theme.editIcon),
                onPressed: () {
                  if (editor != null) {
                    editor!(item);
                  } else {
                    showDataObjectDialog(context, [item], [dialogFieldNames ?? item.fields], title, specifications, (d) {
                      data.notify();
                    });
                  }
                },
              )));
            }

            if (delete) {
              cells.add(DataCell(IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(theme.deleteIcon),
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
            return Scrollbar(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, child: DataTable(columnSpacing: theme.columnSpacing, columns: columns, rows: rows)));
          } else {
            return Container();
          }
        }));
  }
}

class DataObjectTableTheme {
  final IconData editIcon;
  final IconData deleteIcon;
  final double columnSpacing;

  const DataObjectTableTheme({this.editIcon = Icons.edit, this.deleteIcon = Icons.delete, this.columnSpacing = 28});
}

//TODO Horizontal scrolling
