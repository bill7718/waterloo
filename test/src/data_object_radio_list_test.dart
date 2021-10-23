import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/data_object_radio_list.dart';
import 'package:waterloo/src/data_object_drop_down_list.dart';
import 'package:waterloo/src/waterloo_drop_down_list.dart';

import '../util.dart';

void main() {
  var testObject = TestObject(<String, dynamic>{});

  group('Test DataObjectRadioList', () {
    setUp(() {
      testObject = TestObject(<String, dynamic>{});
    });

    testWidgets('Add a DataObjectRadioList with an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];
      testObject.set('appType', 'hp');

      Widget page = MockPage(DataObjectRadioList(
        label: label,
        items: items,
        data: testObject,
        fieldName: 'appType',
      ));

      await tester.pumpWidget(page);
      expect(checkRadioButtonList(label, initialValue: 'hp', items: items), true);
    });

    testWidgets('Add a DataObjectRadioList without an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(DataObjectRadioList(
        label: label,
        items: items,
        data: testObject,
        fieldName: 'appType',
      ));

      await tester.pumpWidget(page);
      expect(checkRadioButtonList(label, items: items), true);
    });

    testWidgets('When I select an option I expect the value to be updated ', (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(DataObjectRadioList(
        label: label,
        items: items,
        data: testObject,
        fieldName: 'appType',
      ));

      await tester.pumpWidget(page);
      expect(checkRadioButtonList(label, items: items), true);
      await tapRadioTile(label, 'RM1', tester);
      await tester.pumpWidget(page);
      expect(checkRadioButtonList(label, initialValue: 'rm', items: items), true);
      expect(testObject.get('appType'), 'rm');
    });
  });
}

class TestObject extends DataObject {
  TestObject(Map<String, dynamic> data) : super(data);
}
