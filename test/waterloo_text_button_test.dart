
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/beta/waterloo_text_button.dart';

import 'util.dart';

void main() {

  bool exceptionThrown = false;
  bool pressed = false;

  void exceptionHandler(BuildContext context, Exception ex, StackTrace st) {
    exceptionThrown = true;
  }

  setUp(() {
    pressed = false;
    exceptionThrown = false;
  });

 testWidgets('Add a WaterlooTextButton to a page', (WidgetTester tester) async {
    Widget page = MockPage(
      WaterlooTextButton(text: 'Hello', exceptionHandler: exceptionHandler ,
        onPressed: () {
        pressed = true;
        },

          )
    );

    await tester.pumpWidget(page);
    expect(find.text('Hello'), findsOneWidget);
    var f = findButtonByText('Hello');
    expect (f, findsOneWidget);
  });

  testWidgets('Tap the button', (WidgetTester tester) async {
    Widget page = MockPage(
      WaterlooTextButton(text: 'Hello', exceptionHandler: exceptionHandler ,
        onPressed: () {
          pressed = true;
        },

      )
    );

    await tester.pumpWidget(page);
    await tap('Hello',  tester);
    expect(pressed, true);

  });


  testWidgets('Tap the button but generate an exception', (WidgetTester tester) async {
    Widget page = MockPage(
      WaterlooTextButton(text: 'Hello', exceptionHandler: exceptionHandler ,
        onPressed: () {
          throw Exception('hi');
        },

      )
    );

    await tester.pumpWidget(page);
    await tap('Hello',  tester);
    expect(exceptionThrown, true);

  });
}




