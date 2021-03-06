import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_text_field.dart';

import '../mocks/mock_text_provider.dart';
import '../util.dart';

void main() {
  String currentValue = '';
  const String error = 'error';

  String? validator(String? s) {
    if (s == 'bad') {
      return error;
    }
    return null;
  }

  void binder(String? v) {
    currentValue = v ?? '';
  }

  group('Test WaterlooTextField', ()
  {
    setUp( () {
      currentValue = '';
    });

    testWidgets('Add a WaterlooTextField to a page checking that parameters are passed in correctly', (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = 'Hello';
      var obscure = true;
      var readOnly = true;
      var hint = 'hint';
      var help = 'help';
      var width = 500.0;

      Widget page = MockPage(WaterlooTextField(
        valueBinder: binder,
        label: label,
        initialValue: initialValue,
        obscure: obscure,
        hint: hint,
        help: help,
        readOnly: readOnly,
      ));

      await tester.pumpWidget(page);
      expect(checkTextInputField(label, initialValue: initialValue,
          obscure: obscure,
          readOnly: readOnly,
          hint: MockTextProvider.text(hint),
          help: MockTextProvider.text(help) ?? '',
          ), true);
    });

    testWidgets('When I enter valid  text the value is updated ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooTextField(
        valueBinder: binder,
        label: label,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, 'hi');
      expect(checkTextInputField(label), true);
      expect(currentValue, 'hi');
    });

    testWidgets('When I enter a invalid value a message is shown ', (WidgetTester tester) async {
      Widget page = MockPage(WaterlooTextField(
        valueBinder: binder,
        initialValue: 'Hello',
        label: 'Greeting',
        validator: validator,
        help: 'assistanceHere',
      ));

      await tester.pumpWidget(page);
      await enterText(tester, 'Greeting', 'bad');
      expect(find.text('lookup_error'), findsOneWidget);
      expect(currentValue, 'bad');
    });

    testWidgets('When I do not provide a binder then no binding takes place ', (WidgetTester tester) async {
      Widget page = MockPage(WaterlooTextField(
        initialValue: 'Hello',
        label: 'Greeting',
        validator: validator,
        help: 'assistanceHere',
      ));

      await tester.pumpWidget(page);
      await enterText(tester, 'Greeting', 'bad');
      expect(find.text('lookup_error'), findsOneWidget);
      expect(currentValue.isEmpty , true, reason: currentValue);
    });
  });
}
