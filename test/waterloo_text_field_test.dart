
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/waterloo_text_field.dart';

import 'util.dart';

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


 testWidgets('Add a WaterlooTextField to a page', (WidgetTester tester) async {

    Widget page = MockPage(
      WaterlooTextField(
        valueBinder: binder,
          initialValue: 'Hello',
          label: 'Greeting',
          validator: validator,
          )
    );

    await tester.pumpWidget(page);
    expect (findTextInputFieldByLabel('Greeting'), findsOneWidget);
    expect(find.text('Greeting'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('When I enter valid  text the value is updated ', (WidgetTester tester) async {

    Widget page = MockPage(
      WaterlooTextField(
        valueBinder: binder,
        initialValue: 'Hello',
          label: 'Greeting',
          validator: validator,
                help: 'assistanceHere',)
    );

    await tester.pumpWidget(page);
    await enterText(tester, 'Greeting', 'hi');
    expect(find.text('error'), findsNothing);
    expect(find.text('assistanceHere'), findsOneWidget);
    expect(currentValue, 'hi');
  });

  testWidgets('When I enter a invalid value a message is shown ', (WidgetTester tester) async {


    Widget page = MockPage(
      WaterlooTextField(
        valueBinder: binder,
        initialValue: 'Hello',
        label: 'Greeting',
        validator: validator,
        help: 'assistanceHere',)
    );

    await tester.pumpWidget(page);
    await enterText(tester, 'Greeting', 'bad');
    expect(find.text('error'), findsOneWidget);
    expect(currentValue, 'bad');
  });
}




