import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/waterloo.dart';

import 'mocks/mock_text_provider.dart';

class MockPage extends StatelessWidget {
  final Widget child;

  const MockPage(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = WaterlooTheme();
    var text = MockTextProvider();

    return MultiProvider(
        providers: [Provider<WaterlooTheme>.value(value: theme), Provider<WaterlooTextProvider>.value(value: text)],
        child: MaterialApp(
            home: Card(
          child: child,
        )));
  }
}

Finder findTextInputFieldByLabel(String label) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextField && widget.label == label);
  return f;
}

bool checkTextInputField(String label,
    {String? initialValue, bool obscure = false, bool readOnly = false, String? hint, String? help, double? width}) {
  try {
    Finder fWaterloo = find.byWidgetPredicate((widget) => widget is WaterlooTextField && widget.label == label);
    expect(fWaterloo, findsOneWidget);
    if (initialValue != null) {
      Finder fInitial = find.descendant(
          of: fWaterloo, matching: find.byWidgetPredicate((widget) => widget is TextFormField && widget.initialValue == initialValue));
      expect(fInitial, findsOneWidget);
    }
    Finder fObscure =
        find.descendant(of: fWaterloo, matching: find.byWidgetPredicate((widget) => widget is TextField && widget.obscureText == obscure));
    expect(fObscure, findsOneWidget);
    Finder fReadOnly =
        find.descendant(of: fWaterloo, matching: find.byWidgetPredicate((widget) => widget is TextField && widget.readOnly == readOnly));
    expect(fReadOnly, findsOneWidget);
    if (hint != null) {
      Finder fHint =
          find.descendant(of: fWaterloo, matching: find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.hintText == hint));
      expect(fHint, findsOneWidget);
    }
    if (help != null) {
      Finder fHelp =
          find.descendant(of: fWaterloo, matching: find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.helperText == help));
      expect(fHelp, findsOneWidget);
    }
    if (width != null) {
      Finder fWidth = find.descendant(of: fWaterloo, matching: find.byWidgetPredicate((widget) => widget is SizedBox && widget.width == width));
      expect(fWidth, findsOneWidget);
    }
    return true;
  } catch (ex) {
    return false;
  }
}

bool checkIconButton(IconData iconData) {
  try {
    Finder fIconButton = find.byWidgetPredicate((widget) => widget is IconButton);
    expect(fIconButton, findsOneWidget);
    Finder fIcon = find.descendant(of: fIconButton, matching: find.byWidgetPredicate((widget) => widget is Icon && widget.icon == iconData));
    expect(fIcon, findsOneWidget);
    return true;
  } catch (ex) {
    return false;
  }
}

bool checkSwitchTile(String label, { bool? initialValue } ) {
  try {
    Finder fWaterloo = find.byWidgetPredicate((widget) => widget is WaterlooSwitchTile && widget.label == label);
    Finder fTile = find.descendant(
        of: fWaterloo, matching: find.byWidgetPredicate((widget) => widget is SwitchListTile && ((widget.title as Text).data?.contains(label) ?? false)));
    expect(fTile, findsOneWidget);
    if (initialValue != null) {
      Finder fInitial = find.descendant(
          of: fWaterloo, matching: find.byWidgetPredicate((widget) => widget is SwitchListTile && widget.value == initialValue));
      expect(fInitial, findsOneWidget);
    }

    return true;
  } catch (ex) {
    return false;
  }
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

///
/// Finds a [WaterlooTextButton] using the text provided and taps it
///
/// Note that the [text] is provided as given to the [WaterlooTextButton].
///
Future<void> tap(String text, WidgetTester tester) async {
  var c = Completer<void>();
  var f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && widget.text == text);
  expect(f, findsOneWidget);
  await tester.tap(f);
  c.complete();
  return c.future;
}

Future<void> tapIcon(IconData icon, WidgetTester tester) async {
  var c = Completer<void>();
  Finder fIconButton = find.byWidgetPredicate((widget) => widget is IconButton && (widget.icon as Icon).icon == icon);
  expect(fIconButton, findsOneWidget);
  await tester.tap(fIconButton);
  c.complete();
  return c.future;
}



Finder findButtonByText(String text) {
  Finder f = find.byWidgetPredicate((widget) => widget is WaterlooTextButton && widget.text == text);
  return f;
}

Future<void> enterTextInCalendarWidget(String text, WidgetTester tester) async {
  var c = Completer<void>();
  Finder fIconButton = find.byWidgetPredicate((widget) => widget is IconButton && (widget.icon as Icon).icon == Icons.edit);
  expect(fIconButton, findsOneWidget);
  await tester.tap(fIconButton);
  c.complete();
  return c.future;
}

Future<void> tapSwitchTile(String label, WidgetTester tester) async {
  var c = Completer<void>();
  Finder fTile = find.byWidgetPredicate((widget) => widget is WaterlooSwitchTile && widget.label == label);
  expect(fTile, findsOneWidget);
  await tester.tap(fTile);
  c.complete();
  return c.future;
}