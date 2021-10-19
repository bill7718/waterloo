import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/data_object_integer_field.dart';
import 'package:waterloo/src/data_object_date_field.dart';
import 'package:waterloo/src/data_object_text_field.dart';
import '../mocks/mock_text_provider.dart';
import '../util.dart';

void main() {
  var data = TestDataObject(<String, dynamic>{});

  group('Test DataObjectIntegerField', () {
    setUp(() {
      data = TestDataObject(<String, dynamic>{});
    });

    testWidgets('Add a DataObjectIntegerField to a page checking that parameters are passed in correctly for an empty field',
        (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      var hint = 'hint';

      Widget page = MockPage(DataObjectIntegerField(
        data: data,
        label: label,
        help: help,
        hint : hint,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      expect(
          checkTextInputField(label, initialValue: data.get(field), readOnly: false, help: MockTextProvider.text(help), hint: MockTextProvider.text(hint)),
          true);
    });

    testWidgets('Add a DataObjectIntegerField to a page checking that parameters are passed in correctly for anfield with a value',
        (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 365);

      Widget page = MockPage(DataObjectIntegerField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      expect(
          checkTextInputField(label, initialValue: '365', readOnly: false, help: MockTextProvider.text(help)),
          true);
    });

    testWidgets('When I enter an value the value is updated in the data object ', (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 365);

      Widget page = MockPage(DataObjectIntegerField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '730');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 730);
    });

    testWidgets('When I enter non integer value the value is not updated in the data object and a message is shown ', (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 365);

      Widget page = MockPage(DataObjectIntegerField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, 'not text');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 365);
      expect(find.text(MockTextProvider.text('integerError') ?? ''), findsOneWidget);
    });


    testWidgets('When I enter an invalid value the value is updated in the data object and a message is shown ', (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 365);

      Widget page = MockPage(DataObjectIntegerField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '366');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 366);
      expect(find.text(MockTextProvider.text('badBrian') ?? ''), findsOneWidget);
    });

    testWidgets('When I provide my own validator this is applied ', (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 365);

      Widget page = MockPage(DataObjectIntegerField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
        validator: (v) {
          if (v == '214') {
            return 'notBye';
          }
        },
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '214');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 214);
      expect(find.text(MockTextProvider.text('notBye') ?? ''), findsOneWidget);
    });
  });
}

class TestDataObject extends DataObject {
  TestDataObject(Map<String, dynamic> data) : super(data);

  @override
  String? validate({List<String>? fields}) {
    if (fields?.contains('brian') ?? false) {
      if (get('brian') == 366) {
        return 'badBrian';
      }
    }
    return null;
  }
}
