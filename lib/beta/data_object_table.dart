import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/beta/data_object_widget_list.dart';
import 'package:waterloo/data_object_widgets.dart';
import 'package:waterloo/src/waterloo_text_provider.dart';
import 'package:waterloo/src/waterloo_theme.dart';
import '../src/data_object_view.dart';

import '../src/change_notifier_list.dart';

class DataObjectTable<T extends DataObject> extends StatelessWidget {
  final ChangeNotifierList<T> data;
  final Map<String, DataSpecification> specifications;

  final List<String> fieldNames;

  final Map<Icon, Function> functionMap;

  const DataObjectTable({
    Key? key,
    required this.data,
    required this.specifications,
    required this.fieldNames,
    this.functionMap = const <Icon, Function>{},
  }) : super(key: key);

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
          for (var icon in functionMap.keys) {
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

            for (var icon in functionMap.keys) {
              cells.add(DataCell(IconButton(icon: icon, onPressed: () => functionMap[icon]!(item))));
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

class DataObjectTableEditor<T extends DataObject> extends StatelessWidget {
  final ChangeNotifierList<T> data;
  final Map<String, DataSpecification> specifications;
  final Map<String, RelationshipSpecification> relationships;

  final List<String> fieldNames;

  /// The field names to use in the dialog. If not provided then the default list of fields for the
  /// DataObject is used
  final List<String>? dialogFieldNames;

  /// Title to use for the edit dialog if edit is enabled
  final String? title;

  final String subTitle;

  const DataObjectTableEditor(
      {Key? key,
      required this.data,
      required this.specifications,
      required this.relationships,
      required this.fieldNames,
      this.dialogFieldNames,
      this.title,
      this.subTitle = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<WaterlooTheme>(context).tableTheme;
    var textProvider = Provider.of<WaterlooTextProvider>(context);

    var map = <Icon, Function>{
      Icon(theme.editIcon): (object) {
        showWaterlooGridFormDialog(context,
            payload: object,
            formTitle: title ?? '',
            formSubtitle: subTitle,
            children: dataObjectWidgetList(object, [dialogFieldNames ?? fieldNames], specifications, relationships, textProvider),
            callback: (response) {
          if (response != null) {
            data.notify();
          }
        });
      }
    };

    return DataObjectTable<T>(
      data: data,
      specifications: specifications,
      fieldNames: fieldNames,
      functionMap: map,
    );
  }
}
