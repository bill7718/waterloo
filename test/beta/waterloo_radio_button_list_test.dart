import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/beta/waterloo_drop_drown_list.dart';
import 'package:waterloo/beta/waterloo_radio_button_list.dart';


import '../util.dart';

void main() {
  String? currentValue = '';

  void binder(String? v) {
    currentValue = v;
  }

  group('Test WaterlooRadioButtonList', () {
    setUp(() {
      currentValue = '';
    });

    testWidgets('Add a WaterlooRadioButtonList to a page checking that parameters are passed in correctly', (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = 'hp';
      var items = [ ListItem('hp', 'HP1'), ListItem('rm', 'RM1'),];

      Widget page = MockPage(WaterlooRadioButtonList(
        valueBinder: binder,
        label: label,
        initialValue: initialValue,
        items: items,
      ));

      await tester.pumpWidget(page);
      expect(
          checkRadioButtonList(
            label,
            initialValue: initialValue,
            items: items
          ),
          true);
    });

    /*
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

     */
  });
}
