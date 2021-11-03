import 'dart:async';

import 'package:serializable_data/serializable_data.dart';

import '../waterloo.dart';



///
/// Gets the data from the database used by a [DataObjectList]
///
class DataListGetter<T extends PersistableDataObject> implements ListGetter {

  /// The field used to filter the data.
  ///
  ///
  /// {@macro filter}
  final String? filterLabel;

  /// The object type to use in the filter. If not supplied then this value is derived from the
  /// parameter T
  ///
  ///
  /// {@macro filter}
  final String? filterRef;

  /// The value to use for the filter
  ///
  ///
  /// {@macro filter}
  final dynamic filterValue;

  /// This label identifies the value to show on the screen that is selected
  ///
  /// {@macro filter}
  final String descriptionLabel;

  /// The label of value actually selected (normally an id)
  ///
  ///
  /// {@macro filter}
  final String idLabel;

  /// The object used to retrieve the data from the database
  final DatabaseReader reader;

  DataListGetter(this.filterLabel, this.filterValue,
      this.descriptionLabel, this.idLabel, this.filterRef, this.reader);

  @override
  Future<List<ListItem>> getList() {
    var c = Completer<List<ListItem>>();

    var f = reader.query<T>(ref: filterRef, field: filterLabel, value: filterValue);

    f.then( (r) {
      var response = <ListItem>[];
      for (var item in r) {
        response.add(ListItem(item.get(idLabel),  item.get(descriptionLabel)));
      }
      c.complete(response);

    });

    return c.future;
  }


}