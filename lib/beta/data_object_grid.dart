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

  const DataObjectGrid({Key? key, required this.data, required this.fieldNames, required this.specifications, this.rebuildFields}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    if (rebuildFields == null) {
      return WaterlooGrid(
          children: widgets,
          minimumColumnWidth: Provider.of<WaterlooTheme>(context, listen: false).dataObjectFormTheme.minimumColumnWidth,
          pad: false);
    } else {
      return DataObjectChangeNotifier(
          data: [data],
          fieldNames: [rebuildFields!],
          child: WaterlooGrid(
              children: widgets,
              minimumColumnWidth: Provider.of<WaterlooTheme>(context, listen: false).dataObjectFormTheme.minimumColumnWidth,
              pad: false));
    }
  }
}
