import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/waterloo_form_message.dart';


import 'util.dart';

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
}
