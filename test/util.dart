

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_text_button.dart';
import 'package:waterloo/src/waterloo_text_field.dart';

class MockPage extends StatelessWidget {

  final Widget child;

  const MockPage(this.child, { Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp (home: Card ( child: child));
  }
}


Finder findTextInputFieldByLabel(String label) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextField && widget.label == label);
  return f;
}

Future<void> enterText(WidgetTester tester, String label, String text) {
  var c = Completer<void>();
  tester.enterText(findTextInputFieldByLabel(label), text).then((v) {
    tester.pumpAndSettle().then((value) {
      c.complete();
    });
  });

  return c.future;
}

Future<void> tap(String text, WidgetTester tester) async  {
  var c = Completer<void>();
  var f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && widget.text == text);
  expect(f, findsOneWidget);
  await tester.tap(f);
  c.complete();
  return c.future;
}

Finder findButtonByText(String text) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && widget.text == text);
  return f;
}