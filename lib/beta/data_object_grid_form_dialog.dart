

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/beta/waterloo_event_handler.dart';

import 'waterloo_grid_form.dart';

class DataObjectGridFormDialog extends StatelessWidget {

  final List<DataObject> data;
  final String formMessage;
  final String formTitle;
  final String? formSubtitle;
  final List<Widget> children;
  final double? minimumColumnWidth;
  final double? maximumColumnWidth;
  final int? preferredColumnCount;
  final int? maximumColumnCount;
  final double? preferredColumnWidth;
  final double? columnSeparation;
  final double? rowSeparation;

  /// If true then the form checks that all the data objects are valid before they are returned to the
  /// event handler. Allows cross field validation to be easily applied at the data object level.
  ///
  /// Defaults to true. Set to false if this page leaves the data object invalid or if
  /// it does not capture all the mandatory data for the objects
  final bool validateDataObjects;

  const DataObjectGridFormDialog({Key? key,
    required this.data,
    required this.formTitle,
    this.formSubtitle,
    this.formMessage = '',
    required this.children,
    this.minimumColumnWidth,
    this.maximumColumnWidth,
    this.maximumColumnCount,
    this.preferredColumnWidth,
    this.preferredColumnCount,
    this.rowSeparation,
    this.columnSeparation,
    this.validateDataObjects = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: WaterlooGridForm(
        eventHandler: DialogEventHandler(),
        events: const [
          EventSpecification(event: 'Cancel', description: 'Cancel', mustValidate: false),
          EventSpecification(event: 'Ok', description: 'Ok', mustValidate: true),
        ],
        payload :data,
        formTitle: formTitle,
        formSubtitle : formSubtitle,
        act: false,
        children: children,
        minimumColumnWidth: minimumColumnWidth,
        maximumColumnWidth: maximumColumnWidth,
        maximumColumnCount: maximumColumnCount,
        preferredColumnWidth: preferredColumnWidth,
        preferredColumnCount: preferredColumnCount,
        rowSeparation: rowSeparation,
        columnSeparation: columnSeparation,
        validateDataObjects :validateDataObjects

      ),
    );
  }


}
