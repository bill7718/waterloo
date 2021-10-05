import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_switch_tile.dart';

import '../util.dart';

void main() {
  bool currentValue = false;

  void binder(bool? v) {
    currentValue = v ?? false;
  }

  group('Test WaterlooSwitchTile', () {
    setUp(() {
      currentValue = false;
    });

    testWidgets('Add a WaterlooSwitchTile to a page checking that parameters are passed in correctly', (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = false;

      Widget page = MockPage(WaterlooSwitchTile(
        valueBinder: binder,
        label: label,
        initialValue: initialValue,
      ));

      await tester.pumpWidget(page);
      expect(
          checkSwitchTile(
            label,
            initialValue: initialValue,
          ),
          true);
    });

    testWidgets('When I enter tap the tile the value is updated ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooSwitchTile(
        valueBinder: binder,
        label: label,
      ));

      await tester.pumpWidget(page);
      await tapSwitchTile(label, tester);
      expect(currentValue, true);
      await tester.pumpWidget(page);
      await tapSwitchTile(label, tester);
      expect(currentValue, false);
    });

    testWidgets('When I enter tap the tile without a binder then nothing happens ', (WidgetTester tester) async {
      var label = 'Greeting';
      Widget page = MockPage(WaterlooSwitchTile(
        label: label,
      ));

      await tester.pumpWidget(page);
      await tapSwitchTile(label, tester);
      expect(currentValue, false);
    });
  });
}
