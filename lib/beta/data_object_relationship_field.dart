import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serializable_data/serializable_data.dart';

import 'data_object_list.dart';

class DataObjectRelationshipField extends StatelessWidget {
  final DataObjectRelationship data;

  final RelationshipSpecification relationshipSpecification;

  const DataObjectRelationshipField({Key? key, required this.data, required this.relationshipSpecification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataObjectList(
      reader: Provider.of<DatabaseReader>(context),
      objectType: relationshipSpecification.to,
      filterLabel: relationshipSpecification.filterLabel,
      filterValue: relationshipSpecification.filterValue,
      descriptionLabel: relationshipSpecification.descriptionLabel ?? '',
      valueBinder: (id) {
        data.set(DataObjectRelationship.toLabel, PersistableDataObject.buildDBReference(relationshipSpecification.to, id));
      },
    );
  }
}
