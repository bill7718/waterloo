import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/waterloo.dart';


import '../util.dart';

void main() {
  testWidgets('Add a WaterlooFormMessage to a page - then set an error', (WidgetTester tester) async {
    var error = FormError();

    Widget page = MockPage(WaterlooFormMessage(text: 'Hello', error: error));

    await tester.pumpWidget(page);
    expect(find.text('Hello'), findsOneWidget);
    error.error = 'Bad Thing';
    await tester.pumpWidget(page);
    expect(find.text('Bad Thing'), findsOneWidget);
    expect(find.text('Hello'), findsNothing);
  });

  testWidgets('When I create WaterlooFormMessage with no message there is no problem', (WidgetTester tester) async {
    var error = FormError();

    Widget page = MockPage(WaterlooFormMessage(text: '', error: error));

    await tester.pumpWidget(page);
  });

  testWidgets('When I create WaterlooFormMessage with a message and I unset an error the original message is reinstated', (WidgetTester tester) async {
    var error = FormError();

    Widget page = MockPage(WaterlooFormMessage(text: 'Hello', error: error));

    await tester.pumpWidget(page);
    error.error = 'Bad Thing';
    await tester.pumpWidget(page);
    expect(find.text('Bad Thing'), findsOneWidget);
    expect(find.text('Hello'), findsNothing);
    error.error = '';
    await tester.pumpWidget(page);
    expect(find.text('Hello'), findsOneWidget);
  });
}
