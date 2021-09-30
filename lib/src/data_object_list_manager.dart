

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/data_object_widgets.dart';
import 'package:waterloo/waterloo.dart';


class DataObjectListManager extends StatefulWidget {

  final String fieldName;
  final DataObject data;
  final Map<String, DataSpecification> specifications;

  const DataObjectListManager({Key? key, required this.fieldName, required this.data, required this.specifications }) : super(key: key);


  @override
  State<StatefulWidget> createState()=>DataObjectListManagerState();


}

class DataObjectListManagerState extends State<DataObjectListManager> {

  bool switchValue = false;
  ChangeNotifierList<DataObject> list = ChangeNotifierList<DataObject>();

  @override
  void initState() {
    switchValue = widget.data.get(widget.fieldName).isNotEmpty;
    list.replaceAll(widget.data.get(widget.fieldName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WaterlooGrid(preferredColumnCount: 1,
        children: [
          WaterlooGridChild(layoutRule: WaterlooGridChildLayoutRule.full,
              child: WaterlooSwitchTile(label: widget.specifications[widget.fieldName]?.label ?? '',
                initialValue: switchValue,
                valueBinder: (v) => setState(
                    () {
                      switchValue = v;
                    }
                ) ,


              )),
          if (switchValue && list.list.isNotEmpty) WaterlooGridChild(child: DataObjectTable(data: list, fieldNames: list.list.first.fields, specifications: widget.specifications),layoutRule: WaterlooGridChildLayoutRule.full),
          if (switchValue && list.list.isNotEmpty) WaterlooGridChild(child:
          WaterlooTextButton(text: widget.specifications[widget.fieldName]?.label ?? '', exceptionHandler: () {},
            onPressed: () {
            var o = widget.specifications[widget.fieldName]!.constructor!();
              showDataObjectDialog(
                  context, [o], [o.fields], widget.specifications, (d) {
                if (d != null) {
                  list.add(d);
                  widget.data.set(widget.fieldName, list.list);
                }
              });
            }),
          )
        ]);

  }


}
