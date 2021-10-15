import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/data_object_currency_field.dart';
import 'package:waterloo/src/data_object_text_field.dart';
import '../mocks/mock_text_provider.dart';
import '../util.dart';

void main() {
  var data = TestDataObject(<String, dynamic>{});

  group('Test DataObjectTextField', () {
    setUp(() {
      data = TestDataObject(<String, dynamic>{});
    });

    testWidgets('Add a DataObjectCurrencyField to a page checking that parameters are passed in correctly for an empty field',
        (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';

      Widget page = MockPage(DataObjectCurrencyField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      expect(checkTextInputField(label, initialValue: data.get(field), readOnly: false, help: MockTextProvider.text(help)), true);
    });

    testWidgets('Add a DataObjectCurrencyField to a page checking that parameters are passed in correctly for anfield with a value',
        (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 5000);

      Widget page = MockPage(DataObjectCurrencyField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      expect(checkTextInputField(label, initialValue: toDecimal(data.get(field), 2 , '.'), readOnly: false, help: MockTextProvider.text(help)), true);
    });

    testWidgets('When I enter an value the value is updated in the data object ', (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 12300);

      Widget page = MockPage(DataObjectCurrencyField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '35.11');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 3511);
    });

    testWidgets('When I enter an invalid value the value is updated in the data object and a message is shown ', (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 4511);

      Widget page = MockPage(DataObjectCurrencyField(
        data: data,
        label: label,
        help: help,
          fieldName: field,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '27');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 2700);
      expect(find.text(MockTextProvider.text('badBrian') ?? ''), findsOneWidget);
    });

    testWidgets('When I provide my own validator this is applied ', (WidgetTester tester) async {
      var help = 'help';
      var label = 'Hello';
      var field = 'brian';
      data.set(field, 3500);

      Widget page = MockPage(DataObjectCurrencyField(
        data: data,
        label: label,
        help: help,
        fieldName: field,
        validator: (v) {
          if (v == '19.11') {
            return 'notBye';
          }
        },
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '19.11');
      expect(checkTextInputField(label), true);
      expect(data.get(field), 1911);
      expect(find.text(MockTextProvider.text('notBye') ?? ''), findsOneWidget);
    });
  });
}

class TestDataObject extends DataObject {
  TestDataObject(Map<String, dynamic> data) : super(data);

  @override
  String? validate({List<String>? fields}) {
    if (fields?.contains('brian') ?? false) {
      if (get('brian') == 2700) {
        return 'badBrian';
      }
    }
    return null;
  }
}
