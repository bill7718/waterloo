
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/data_object_view.dart';

import '../util.dart';

void main() {
  var data = TestDataObject(<String, dynamic>{});

  group('Test DataObjectTextField', () {
    setUp(() {
      data = TestDataObject(<String, dynamic>{});
    });

    testWidgets('When I view a field with value of null I expect to see a Container',
            (WidgetTester tester) async {
          var field = 'brian';
          var spec = DataSpecification(type: DataSpecification.boolType);

          Widget page = MockPage(DataObjectView(
              data: data,
              fieldName: field,
              dataSpecification: spec
          ));

          await tester.pumpWidget(page);
          expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
              matching: find.byWidgetPredicate((widget) => widget is Container)), findsOneWidget);

        });

    group('Test boolean fields', ()
    {
      testWidgets('When I view a boolean field with value true I expect to see "Yes"',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.boolType);
            data.set('brian', true);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('Yes')), findsOneWidget);
          });

      testWidgets('When I view a boolean field with value false I expect to see "No"',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.boolType);
            data.set('brian', false);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('No')), findsOneWidget);
          });
    });

    group('Test currency fields', ()
    {
      testWidgets('When I view a currency field with a positive value I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.currencyType);
            data.set('brian', 2354);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('23.54')), findsOneWidget);
          });

      testWidgets('When I view a currency field with a zero value I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.currencyType);
            data.set('brian', 0);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('0.00')), findsOneWidget);
          });

      testWidgets('When I view a currency field with a negative value I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.currencyType);
            data.set('brian', -12435);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('-124.35')), findsOneWidget);
          });
    });

    group('Test text fields', ()
    {
      testWidgets('When I view a text field I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.textType);
            data.set('brian', 'Hello Brian');

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('Hello Brian')), findsOneWidget);
          });

      testWidgets('When I view an empty text field I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.textType);
            data.set('brian', '');

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('')), findsOneWidget);
          });
    });


    group('Test date fields', ()
    {
      testWidgets('When I view a date field with I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.dateType);
            data.set('brian', 18324);

            DateTime? d = toDateTime(18324);
            var dateValue = '${d?.day.toString().padLeft(2, '0')}/${d?.month.toString().padLeft(2, '0')}/${d?.year}';

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text(dateValue)), findsOneWidget);
          });
    });


    group('Test list fields', ()
    {
      testWidgets('When I view a list field I expect to see the description',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.listType, list: [
              ListEntry('M', 'Monthly'),
              ListEntry('A', 'Annually'),
            ]);
            data.set('brian', 'M');

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('Monthly')), findsOneWidget);
          });

      testWidgets('When I view a list field with no descriptions I expect an empty field',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.listType
            );
            data.set('brian', 'M');

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.byWidgetPredicate((widget) => widget is Container)), findsOneWidget);
          });
    });

    group('Test list fields', ()
    {
      testWidgets('When I view a radio list field I expect to see the description',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.radioListType, list: [
              ListEntry('M', 'Monthly'),
              ListEntry('A', 'Annually'),
            ]);
            data.set('brian', 'A');

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('Annually')), findsOneWidget);
          });

      testWidgets('When I view a list field with no descriptions I expect an empty field',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.radioListType
            );
            data.set('brian', 'M');

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.byWidgetPredicate((widget) => widget is Container)), findsOneWidget);
          });
    });

    group('Test integer fields', ()
    {
      testWidgets('When I view an integer field I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.integerType);
            data.set('brian', 1234);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('1234')), findsOneWidget);
          });

      testWidgets('When I view an zero integer field I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.integerType);
            data.set('brian', 0);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('0')), findsOneWidget);
          });


      testWidgets('When I view a negative field I expect to see it',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.integerType);
            data.set('brian', -194);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.text('-194')), findsOneWidget);
          });
    });

    group('Test other fields', ()
    {
      testWidgets('When I view a data object field I expect to see an empty field',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.dataObjectType);
            data.set('brian', TestDataObject(<String, dynamic>{}));

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.byWidgetPredicate((widget) => widget is Container)), findsOneWidget);
          });

      testWidgets('When I view a percent field I expect to see an empty field',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.percentType);
            data.set('brian', 1265);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.byWidgetPredicate((widget) => widget is Container)), findsOneWidget);
          });

      testWidgets('When I view a data list field I expect to see an empty field',
              (WidgetTester tester) async {
            var field = 'brian';
            var spec = DataSpecification(type: DataSpecification.dataObjectListType);
            data.set('brian', <TestDataObject>[]);

            Widget page = MockPage(DataObjectView(
                data: data,
                fieldName: field,
                dataSpecification: spec
            ));

            await tester.pumpWidget(page);
            expect(find.descendant(of: find.byWidgetPredicate((widget) => widget is DataObjectView),
                matching: find.byWidgetPredicate((widget) => widget is Container)), findsOneWidget);
          });
    });

  });
}

class TestDataObject extends DataObject {
  TestDataObject(Map<String, dynamic> data) : super(data);

  @override
  String? validate({List<String>? fields}) {
    if (fields?.contains('brian') ?? false) {
      if (get('brian') == 'hi') {
        return 'badBrian';
      }
    }
    return null;
  }
}