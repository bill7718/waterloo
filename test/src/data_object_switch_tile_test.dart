import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/data_object_switch_tile.dart';

import '../util.dart';

void main() {

  var testObject = TestObject(<String, dynamic>{});
  group('Test DataObjectSwitchTile', () {
    setUp(() {
      testObject = TestObject(<String, dynamic>{});
    });

    testWidgets('Add a DataObjectSwitchTile to a page checking that parameters are passed in correctly', (WidgetTester tester) async {
      var label = 'Greeting';

      testObject.set('brian', false);

      Widget page = MockPage(DataObjectSwitchTile(
        label: label,
        data: testObject,
        fieldName: 'brian'
      ));

      await tester.pumpWidget(page);
      expect(
          checkSwitchTile(
            label,
            initialValue: false,
          ),
          true);
    });

    testWidgets('When I enter tap the tile the value is updated ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(DataObjectSwitchTile(
        label: label,
        data: testObject,
        fieldName: 'brian',
      ));

      await tester.pumpWidget(page);
      await tapSwitchTile(label, tester);
      expect(testObject.get('brian'), true);
      await tester.pumpWidget(page);
      await tapSwitchTile(label, tester);
      expect(testObject.get('brian'), false);
    });


  });
}

class TestObject extends DataObject {
  TestObject(Map<String, dynamic> data) : super(data);
}