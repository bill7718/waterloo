import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/beta/data_object_change_notifier.dart';
import 'package:waterloo/src/waterloo_theme.dart';
import 'data_object_widget.dart';
import 'waterloo_grid.dart';

class DataObjectGrid extends StatelessWidget {
  final DataObject data;
  final List<String> fieldNames;
  final List<String>? rebuildFields;
  final Map<String, DataSpecification> specifications;
  final int? preferredColumnCount;

  const DataObjectGrid({Key? key, required this.data, required this.fieldNames, required this.specifications, this.rebuildFields, this.preferredColumnCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rebuildFields == null) {
      return WaterlooGrid(
          children: buildWidgets(),
          minimumColumnWidth: Provider.of<WaterlooTheme>(context, listen: false).dataObjectFormTheme.minimumColumnWidth,
          preferredColumnWidth: Provider.of<WaterlooTheme>(context, listen: false).dataObjectFormTheme.preferredColumnWidth,
          preferredColumnCount: preferredColumnCount ?? 3,
          pad: false);
    } else {
      return DataObjectChangeNotifier(
          data: [data],
          fieldNames: [rebuildFields!],
          builder: () => WaterlooGrid(
              children: buildWidgets(),
              minimumColumnWidth: Provider.of<WaterlooTheme>(context, listen: false).dataObjectFormTheme.minimumColumnWidth,
              preferredColumnWidth: Provider.of<WaterlooTheme>(context, listen: false).dataObjectFormTheme.preferredColumnWidth,
              preferredColumnCount: preferredColumnCount ?? 3,
              pad: false));
    }
  }

  List<Widget> buildWidgets() {
    var widgets = <Widget>[];
    for (var field in fieldNames) {
      if (specifications[field] != null) {
        widgets.add(DataObjectWidget(
          data: data,
          specifications: specifications,
          fieldName: field,
        ));
      }
    }
    return widgets;
  }
}
