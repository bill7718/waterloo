import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/data_object_change_notifier.dart';

import '../util.dart';

void main() {
  int count = 0;

  group('Test DataChangeNotifier', () {
    setUp(() {
      count = 0;
    });

    testWidgets('Add a DataChangeNotifier to a page with no notifiers', (WidgetTester tester) async {
      Widget page = MockPage(DataObjectChangeNotifier(
        data: const [],
        fieldNames: const [],
        builder: (context) {
          return Text('Change Count:$count');
        },
      ));

      await tester.pumpWidget(page);
      expect(find.text('Change Count:0'), findsOneWidget);
    });

    testWidgets('When I change  a listened for value where there is one dataobject and one field then the child is rebuilt', (WidgetTester tester) async {

      var object1 = TestObject();
      var field1 = 'field1';

      Widget page = MockPage(DataObjectChangeNotifier(
        data:  [object1],
        fieldNames: [ [field1]],
        builder: (context) {
          count++;
          return Text('Change Count:$count');
        },
      ));

      await tester.pumpWidget(page);
      expect(find.text('Change Count:1'), findsOneWidget);
      object1.set(field1, 1);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:2'), findsOneWidget);
      object1.set(field1, 2);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:3'), findsOneWidget);
    });

    testWidgets('When I change  a not listened for value where there is one dataobject and one field then the child is not rebuilt', (WidgetTester tester) async {

      var object1 = TestObject();
      var field1 = 'field1';
      var field2 = 'field2';

      Widget page = MockPage(DataObjectChangeNotifier(
        data:  [object1],
        fieldNames: [ [field1]],
        builder: (context) {
          count++;
          return Text('Change Count:$count');
        },
      ));

      await tester.pumpWidget(page);
      expect(find.text('Change Count:1'), findsOneWidget);
      object1.set(field2, 1);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:1'), findsOneWidget);
      object1.set(field2, 2);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:1'), findsOneWidget);
    });

    testWidgets('When I change  a listened for value where there is one dataobject and many fields then the child is rebuilt', (WidgetTester tester) async {

      var object1 = TestObject();
      var field1 = 'field1';
      var field2 = 'field2';

      Widget page = MockPage(DataObjectChangeNotifier(
        data:  [object1],
        fieldNames: [ [field1, field2]],
        builder: (context) {
          count++;
          return Text('Change Count:$count');
        },
      ));

      await tester.pumpWidget(page);
      expect(find.text('Change Count:1'), findsOneWidget);
      object1.set(field1, 1);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:2'), findsOneWidget);
      object1.set(field2, 2);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:3'), findsOneWidget);
    });

    testWidgets('When I change  a listened for value where there are many dataobject and many fields then the child is rebuilt', (WidgetTester tester) async {

      var object1 = TestObject();
      var object2 = TestObject();
      var field1 = 'field1';
      var field2 = 'field2';
      var field3 = 'field3';

      Widget page = MockPage(DataObjectChangeNotifier(
        data:  [object1, object2],
        fieldNames: [ [field1, field2], [ field2, field3]],
        builder: (context) {
          count++;
          return Text('Change Count:$count');
        },
      ));

      await tester.pumpWidget(page);
      expect(find.text('Change Count:1'), findsOneWidget);

      object1.set(field1, 1);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:2'), findsOneWidget);

      object1.set(field2, 2);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:3'), findsOneWidget);

      object2.set(field1, 1);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:3'), findsOneWidget);

      object2.set(field3, 1);
      await tester.pumpWidget(page);
      expect(find.text('Change Count:4'), findsOneWidget);
    });
  });
}

class TestObject extends DataObject {
  TestObject({Map<String, dynamic>? data}) : super(data ?? <String, dynamic>{});


}
