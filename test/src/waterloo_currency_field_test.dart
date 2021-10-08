import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_currency_field.dart';
import 'package:waterloo/src/waterloo_date_field.dart';

import '../mocks/mock_text_provider.dart';
import '../util.dart';

void main() {
  int? currentValue;
  const String error = 'error';

  String? validator(String? s) {
    if (s == '15.21') {
      return error;
    }
    return null;
  }

  void binder(int? v) {
    currentValue = v;
  }

  group('Test WaterlooCurrencyField', ()
  {
    setUp(() {
      currentValue = null;
    });

    testWidgets('Add a WaterlooCurrencyField to a page checking that parameters are passed in correctly', (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = 2115;
      var help = 'help';

      Widget page = MockPage(WaterlooCurrencyField(
        label: label,
        initialValue: initialValue,
        help: help,
      ));

      await tester.pumpWidget(page);
      expect(checkTextInputField(label, initialValue: '21.15',
          obscure: false,
          readOnly: false,
          help: MockTextProvider.text(help),
         ), true);

    });

    testWidgets('Add a read only WaterlooCurrencyField to a page checking that parameters are passed in correctly - specifically that the date icon is not present and the width is the text field default', (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = 2115;
      var help = 'help';


      Widget page = MockPage(WaterlooCurrencyField(
        label: label,
        initialValue: initialValue,
        help: help,
        readOnly: true,
      ));

      await tester.pumpWidget(page);
      expect(checkTextInputField(label, initialValue: '21.15',
          obscure: false,
          readOnly: true,
          ), true);
    });

    testWidgets('When I enter a valid currency amount the value is updated ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooCurrencyField(
        valueBinder: binder,
        label: label,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '18.23');
      expect(checkTextInputField(label), true);
      expect(currentValue, 1823);
    });

    testWidgets('When I enter an invalid currency amount in a valid format the value is updated but an error is shown ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooCurrencyField(
        valueBinder: binder,
        validator: validator,
        label: label,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '15.21');
      expect(checkTextInputField(label), true);
      expect(currentValue, 1521);
      expect(find.text(MockTextProvider.text(error) ?? ''), findsOneWidget);
    });

    testWidgets('When I enter a currency amount in an invalid format the value is null and an error is shown ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooCurrencyField(
        valueBinder: binder,
        validator: validator,
        label: label,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, 'a.b');
      expect(checkTextInputField(label), true);
      expect(currentValue, null);
      expect(find.text(MockTextProvider.text(WaterlooCurrencyFieldState.formatError) ?? ''), findsOneWidget);
    });

    testWidgets('When I do not provide a binder then no binding takes place ', (WidgetTester tester) async {
      Widget page = const MockPage(WaterlooCurrencyField(
        label: 'Greeting',
        help: 'assistanceHere',
      ));

      await tester.pumpWidget(page);
      await enterText(tester, 'Greeting', '12.12');
      expect(currentValue , null);
    });
  });
}