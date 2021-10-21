import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/data_object_widgets.dart';
import 'package:waterloo/waterloo.dart';

class DataObjectListManager extends StatefulWidget {
  final String fieldName;
  final DataObject data;
  final Map<String, DataSpecification> specifications;
  final bool edit;
  final bool delete;

  const DataObjectListManager(
      {Key? key,
      required this.fieldName,
      required this.data,
      required this.specifications,
      this.edit = true,
      this.delete = true,
      })
      : super(key: key);

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

    var handler = Provider.of<WaterlooEventHandler>(context);
    var object = Injector.appInstance.get<DataObject>(dependencyName: widget.specifications[widget.fieldName]!.dataType!);
    var fieldNames = object.fields;

    return WaterlooGrid(
        preferredColumnCount: 3,
        children: [
      if (widget.specifications[widget.fieldName]?.showAddItemQuestion ?? true) WaterlooGridChild(
          layoutRule: WaterlooGridChildLayoutRule.full,
          child: WaterlooSwitchTile(
            label:
                widget.specifications[widget.fieldName]?.addItemQuestion ?? '',
            initialValue: switchValue,
            valueBinder: (v) => setState(() {
              switchValue = v;
            }),
          )),
        WaterlooGridChild(
            child: DataObjectTable(
                data: list,
                fieldNames: fieldNames,
                specifications: widget.specifications,
            edit: widget.edit,
              delete: widget.delete
            ),
            layoutRule: WaterlooGridChildLayoutRule.full),
      if (switchValue || list.list.isNotEmpty)
        WaterlooGridChild(
          child: WaterlooTextButton(
              text: widget.specifications[widget.fieldName]?.addItemButton ??
                  'Add',
              exceptionHandler: handler.handleException,
              onPressed: () {
                var o = Injector.appInstance.get<DataObject>(dependencyName: widget.specifications[widget.fieldName]!.dataType!);
                showDataObjectDialog(
                    context, [o], [o.fields],  widget.specifications[widget.fieldName]!.itemDialogTitle,
                    widget.specifications,
                        (d) {
                  if (d != null) {
                    if (d is List) {
                      list.add(d.first);
                      widget.data.set(widget.fieldName, list.list);
                    } else {
                      print(d.toString());
                    }
                  }
                });
              }),
        )
    ]);
  }
}
