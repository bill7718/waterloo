import 'package:flutter/material.dart';
import 'package:waterloo/waterloo.dart';

import 'waterloo_drop_down_list.dart';

///
/// Wraps a [WaterlooDropDownList about a [FutureBuilder]
///
/// The data to shown is provided by an object that implements the [ListGetter] interface.
///
class WaterlooFutureDropDownList extends StatelessWidget {

  /// THe object that returns the list of values to display
  final ListGetter getter;

  /// {@macro initialValue}
  final String? initialValue;

  /// {@macro label}
  final String label;

  /// {@macro valueBinder}
  final Function valueBinder;

  const WaterlooFutureDropDownList({Key? key, required this.label, required this.getter, required this.valueBinder, this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListItem>>(
        future: getter.getList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return WaterlooDropDownList(label: label, items: snapshot.data ?? [], valueBinder: valueBinder, initialValue: initialValue);
          } else {
            return WaterlooTextField(
              label: label,
              readOnly: true,
            );
          }
        });
  }
}

///
/// Interface specification for classes that provide a list of values to be
/// displayed via a [Future]
///
abstract class ListGetter {

  /// Return the list of values
  Future<List<ListItem>> getList();
}
