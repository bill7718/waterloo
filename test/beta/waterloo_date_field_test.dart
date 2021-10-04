import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/beta/waterloo_date_field.dart';

import '../mocks/mock_text_provider.dart';
import '../util.dart';

void main() {
  DateTime? currentValue;
  const String error = 'error';

  String? validator(String? s) {
    if (s == '21/12/1999') {
      return error;
    }
    return null;
  }

  void binder(DateTime? v) {
    currentValue = v;
  }

  group('Test WaterlooDateField', ()
  {
    setUp(() {
      currentValue = null;
    });

    testWidgets('Add a WaterlooDateField to a page checking that parameters are passed in correctly', (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = DateTime(2015, 12, 21);
      var help = 'help';

      Widget page = MockPage(WaterlooDateField(
        label: label,
        initialValue: initialValue,
        help: help,
      ));

      await tester.pumpWidget(page);
      expect(checkTextInputField(label, initialValue: '21/12/2015',
          obscure: false,
          readOnly: false,
          hint: 'dd/mm/yyyy',
          help: help,
          width: 250), true);

      expect(checkIconButton(Icons.calendar_today_outlined), true);
    });

    testWidgets('Add a read only WaterlooDateField to a page checking that parameters are passed in correctly - specifically that the date icon is not present and the width is the text field default', (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = DateTime(2015, 12, 21);
      var help = 'help';

      Widget page = MockPage(WaterlooDateField(
        label: label,
        initialValue: initialValue,
        help: help,
        readOnly: true,
      ));

      await tester.pumpWidget(page);
      expect(checkTextInputField(label, initialValue: '21/12/2015',
          obscure: false,
          readOnly: true,
          hint: 'dd/mm/yyyy',
          help: help,
          width: 400), true);

      expect(checkIconButton(Icons.calendar_today_outlined), false);
    });

    testWidgets('When I enter a valid date the value is updated ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooDateField(
        valueBinder: binder,
        label: label,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '17/9/1997');
      expect(checkTextInputField(label), true);
      expect(currentValue?.year, 1997);
      expect(currentValue?.month, 9);
      expect(currentValue?.day, 17);
    });

    testWidgets('When I enter a date in a valid format the value is updated but an error is shown ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooDateField(
        valueBinder: binder,
        validator: validator,
        label: label,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '21/12/1999');
      expect(checkTextInputField(label), true);
      expect(currentValue?.year, 1999);
      expect(currentValue?.month, 12);
      expect(currentValue?.day, 21);
      expect(find.text(MockTextProvider.text(error) ?? ''), findsOneWidget);
    });

    testWidgets('When I enter a date in an in valid format the value is null and an error is shown ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooDateField(
        valueBinder: binder,
        validator: validator,
        label: label,
      ));

      await tester.pumpWidget(page);
      await enterText(tester, label, '35/12/1999');
      expect(checkTextInputField(label), true);
      expect(currentValue, null);
      expect(find.text(MockTextProvider.text(WaterlooDateFieldState.formatError) ?? ''), findsOneWidget);
    });
  });
}