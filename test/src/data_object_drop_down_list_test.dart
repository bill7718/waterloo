import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/data_object_drop_down_list.dart';
import 'package:waterloo/src/waterloo_drop_down_list.dart';
import 'package:waterloo/beta/waterloo_radio_button_list.dart';

import '../util.dart';

void main() {

  var testObject = TestObject(<String,dynamic>{});

  group('Test DataObjectDropDownList', () {
    setUp(() {
      testObject = TestObject(<String,dynamic>{});
    });

    testWidgets('Add a DataObjectDropDownList with an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];
      testObject.set('appType', 'hp');

      Widget page = MockPage(DataObjectDropDownList(
        label: label,
        items: items,
        data: testObject,
        fieldName: 'appType',
      ));

      await tester.pumpWidget(page);
      expect(
          checkClosedDropDownList(
            label,
            initialValue: 'HP1'
          ),
          true);
    });

    testWidgets('Add a WaterlooDropDownList without an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(DataObjectDropDownList(
        label: label,
        items: items,
        data: testObject,
        fieldName: 'appType',
      ));

      await tester.pumpWidget(page);
      expect(
          checkClosedDropDownList(
            label,
          ),
          true);
    });

        testWidgets('When I select an option I expect the TextField to be updated and the data object to be updated', (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(DataObjectDropDownList(
        label: label,
        items: items,
        data: testObject,
        fieldName: 'appType',
      ));

      await tester.pumpWidget(page);

      await tapIcon(Icons.keyboard_arrow_down, tester);
      await tester.pumpWidget(page);
      await tapTile(label, 'HP1', tester);
      await tester.pumpWidget(page);

      expect(
          checkClosedDropDownList(
            label,
            initialValue: 'HP1'
          ),
          true);
      expect(testObject.get('appType'), 'hp');

    });


  });
}

 class TestObject extends DataObject {
  TestObject(Map<String, dynamic> data) : super(data);
 }
