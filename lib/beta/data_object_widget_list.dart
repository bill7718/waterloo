

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';

import '../data_object_widgets.dart';
import '../waterloo.dart';

List<Widget> dataObjectWidgetList(
    List<DataObject> data, List<List<String>> fieldNames, Map<String, DataSpecification> specifications,
    Map<String, RelationshipSpecification> relationships, WaterlooTextProvider textProvider) {
  var widgets = <Widget>[];

  var i = 0;
  while (i < data.length) {
    for (var field in fieldNames[i]) {
      String? screenField = field;

      // only show if field 1 is not null
      if (field.contains('>')) {
        var field1 = field.split('>').first.trim();
        var field2 = field.split('>').last.trim();

        if (data[i].get(field1) != null) {
          screenField = field2;
        } else {
          screenField = null;
        }
      }

      // only show if field 1 is null
      if (field.contains('<')) {
        var field1 = field.split('<').first.trim();
        var field2 = field.split('<').last.trim();

        if (data[i].get(field1) == null) {
          screenField = field2;
        } else {
          screenField = null;
        }
      }

      // only show if field 1 is true
      if (field.contains('=')) {
        var field1 = field.split('=').first.trim();
        var field2 = field.split('=').last.trim();

        if (data[i].get(field1) == true) {
          screenField = field2;
        } else {
          screenField = null;
        }
      }

      // only show if field 1 is false
      if (field.contains('!')) {
        var field1 = field.split('!').first.trim();
        var field2 = field.split('!').last.trim();

        if (data[i].get(field1) == false) {
          screenField = field2;
        } else {
          screenField = null;
        }
      }

      if (screenField != null) {
        if (screenField.contains('|')) {
          // add field2 but rebuild if field 1 changes - fields one can be a comma separated list
          var fields1 = screenField.split('|').first.trim().split(',');
          var field2 = screenField.split('|').last.trim();

          widgets.add(DataObjectChangeNotifier(
              data: [ data[i] ],
              fieldNames: [ fields1 ],
              builder: (context) {
                return DataObjectWidget(
                  data: data[i],
                  fieldName: field2,
                  specifications: specifications,
                  relationships: relationships,
                );
              }
          ));
        } else {
          if (specifications[screenField] != null) {
            widgets.add(DataObjectWidget(
              data: data[i],
              fieldName: screenField,
              specifications: specifications,
              relationships: relationships,
            ));
          } else {
            if (textProvider.has(screenField)) {
              widgets.add(MarkdownViewer(content: parse(textProvider.get(screenField) ?? '', data)));
            } else {
              if (relationships[screenField] != null) {
                widgets.add(
                    DataObjectRelationshipField(
                      data: data[i] as DataObjectRelationship,
                      relationshipSpecification: relationships[screenField]!,
                    ));
              }
            }
          }
        }
      }
    }

    i++;
  }
  return widgets;
}

