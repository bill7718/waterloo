import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';

import 'data_object_list.dart';

class DataObjectRelationshipField<T extends PersistableDataObject> extends StatelessWidget {
  final DataObjectRelationship data;

  final RelationshipSpecification relationshipSpecification;

  const DataObjectRelationshipField({Key? key, required this.data, required this.relationshipSpecification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataObjectList<T>(
      reader: Provider.of<DatabaseReader>(context),
      filterLabel: relationshipSpecification.filterLabel,
      filterValue: relationshipSpecification.filterValue,
      descriptionLabel: relationshipSpecification.descriptionLabel ?? '',
      screenFieldLabel : relationshipSpecification.relationshipLabel,
      initialValue: data.get(DataObjectRelationship.toIdLabel),
      filterRef: relationshipSpecification.to,
      valueBinder: (id) {
        data.set(DataObjectRelationship.toIdLabel, id);
      },
    );
  }
}
