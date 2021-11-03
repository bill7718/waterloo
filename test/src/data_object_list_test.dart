

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injector/injector.dart';
import 'package:serializable_data/serializable_data.dart';
import '../../lib/src/data_object_list.dart';

import '../mock_firebase_service.dart';
import '../util.dart';

void main() {

  var mock = MockFirebaseService();
  var reader = DatabaseReader(mock);
  late TestObject firm;
  late TestObject club1;
  late TestObject club2;


  void binder(String? v) {

  }



  group('Test DataObjectList', () {
    setUp(() async {
      mock = MockFirebaseService();
      reader = DatabaseReader(mock);

      club1 = TestObject();
      club1.set('name', 'L&G Mortgage Club');
      club1.set('type', 'club');

      await mock.set(club1.dbReference, club1.data);

      club2 = TestObject();
      club2.set('type', 'club');
      club2.set('name', 'Pink Mortgage Club');

      await mock.set(club2.dbReference, club2.data);

      firm = TestObject();
      firm.set('type', 'firm');
      firm.set('name', 'Greens');

      await mock.set(firm.dbReference, firm.data);

      Injector.appInstance.registerDependency<TestObject>(() => TestObject(), override: true);
      Injector.appInstance.registerDependency<PersistableDataObject>(() => TestObject(), override: true, dependencyName: 'Test');
    });

    testWidgets('Add a DataObjectList with an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {


      Widget page = MockPage(DataObjectList<TestObject>(
        valueBinder: binder,
        descriptionLabel: 'name',
        filterLabel: 'type',
        filterValue: 'club',
        screenFieldLabel: 'Club',
        reader: reader,
      ));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
      expect(
          checkClosedDropDownList(
'Club'
          ),
          true);
    });

  });
}


class TestObject extends PersistableDataObject {
  TestObject({Map<String, dynamic>? data}) : super('Test',  data: data);
}