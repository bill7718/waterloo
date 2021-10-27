import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/beta/data_object_widget_list.dart';
import 'package:waterloo/beta/waterloo_grid_form_dialog.dart';
import 'package:waterloo/waterloo.dart';

import 'data_object_table.dart';

class DataObjectListManager extends StatefulWidget {
  final String fieldName;
  final DataObject data;
  final Map<String, DataSpecification> specifications;
  final Map<String, RelationshipSpecification> relationships;
  final bool edit;
  final bool delete;

  const DataObjectListManager({
    Key? key,
    required this.fieldName,
    required this.data,
    required this.specifications,
    required this.relationships,
    this.edit = true,
    this.delete = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DataObjectListManagerState();
}

class DataObjectListManagerState extends State<DataObjectListManager> {
  bool switchValue = false;
  ChangeNotifierList<DataObject> list = ChangeNotifierList<DataObject>();

  @override
  void initState() {
    switchValue = widget.data.get(widget.fieldName).isNotEmpty | !(widget.specifications[widget.fieldName]?.showAddItemQuestion ?? true);
    list.replaceAll(widget.data.get(widget.fieldName) ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textProvider = Provider.of<WaterlooTextProvider>(context, listen: false);
    var handler = Provider.of<WaterlooEventHandler>(context, listen: false);
    var object = Injector.appInstance.get<DataObject>(dependencyName: widget.specifications[widget.fieldName]!.dataType!);
    var fieldNames = object.fields;

    return WaterlooGrid(preferredColumnCount: 3, children: [
      if (widget.specifications[widget.fieldName]?.showAddItemQuestion ?? true)
        WaterlooGridChild(
            layoutRule: WaterlooGridChildLayoutRule.full,
            child: WaterlooSwitchTile(
              label: widget.specifications[widget.fieldName]?.addItemQuestion ?? '',
              initialValue: switchValue,
              valueBinder: (v) => setState(() {
                switchValue = v;
              }),
            )),
      WaterlooGridChild(
          child: DataObjectTableEditor(
            data: list,
            fieldNames: fieldNames,
            specifications: widget.specifications,
            relationships: widget.relationships,
            editDialogTitle: widget.specifications[widget.fieldName]?.itemDialogTitle ?? '',
          ),
          layoutRule: WaterlooGridChildLayoutRule.full),
      if (switchValue || list.list.isNotEmpty)
        WaterlooGridChild(
          child: WaterlooTextButton(
              text: widget.specifications[widget.fieldName]?.addItemButton ?? 'Add',
              exceptionHandler: handler.handleException,
              onPressed: () {
                var o = Injector.appInstance.get<DataObject>(dependencyName: widget.specifications[widget.fieldName]!.dataType!);
                showWaterlooGridFormDialog(context,
                    formTitle: widget.specifications[widget.fieldName]?.itemDialogTitle ?? '',
                    payload: [o],
                    children: dataObjectWidgetList([o], [fieldNames], widget.specifications, widget.relationships, textProvider),
                    callback: (response) {
                  if (response != null) {
                    widget.data.set(widget.fieldName, list.list);
                    list.add(response.first);
                  }
                });
              }),
        )
    ]);
  }
}
