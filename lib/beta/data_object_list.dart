import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serializable_data/serializable_data.dart';
import '../src/waterloo_future_drop_down_list.dart';
import 'data_list_getter.dart';

///
/// Shows data from a [DataObject] as a list. Wraps a [Future] around a [WaterlooFutureDropDownList]
///
///
/// The parameters control which DataObject and how the data is selected
///
class DataObjectList<T extends PersistableDataObject> extends StatelessWidget {

 /// {@template filter}
 /// Suppose I filter Students by year I might have
 /// - filterLabel = 'year'
 /// - filterValue = 2021
 /// - filterRef = 'Student'
 /// - descriptionLabel = 'studentName'
 /// - idLabel = 'studentId'
 /// {@endtemplate}


  /// The field used to filter the data.
  ///
  ///
  /// {@macro filter}
  final String? filterLabel;

  /// The value to use for the filter
  ///
  ///
  /// {@macro filter}
  final dynamic filterValue;

  /// This label identifies the value to show on the screen that is selected
  ///
  /// {@macro filter}
  final String descriptionLabel;

  /// The label used to describe the field on the screen.
  ///
  ///
  /// If not provided the system uses the [descriptionLabel] to obtain the label text.
  final String? screenFieldLabel;


  /// {@macro initialValue}
  final String? initialValue;

  /// The object type to use in the filter. If not supplied then this value is derived from the
  /// parameter T
  ///
  ///
  /// {@macro filter}
  final String? filterRef;

  /// The label of value actually selected (normally an id)
  ///
  ///
  /// {@macro filter}
  final String idLabel;

  /// The object used to retrieve the data from the database
  final DatabaseReader reader;

  /// {@macro valueBinder}
  final Function valueBinder;

  const DataObjectList({Key? key, required this.filterLabel, this.filterValue, this.filterRef,
    required this.descriptionLabel, this.idLabel = PersistableDataObject.idLabel, required this.reader,
    required this.valueBinder, this.screenFieldLabel,  this.initialValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WaterlooFutureDropDownList(label: screenFieldLabel ?? descriptionLabel, valueBinder: valueBinder, initialValue: initialValue,
    getter: DataListGetter<T>(filterLabel, filterValue, descriptionLabel, idLabel, filterRef, reader),);
  }
}

