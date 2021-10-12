import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_drop_down_list.dart';
import 'package:waterloo/beta/waterloo_radio_button_list.dart';

import '../util.dart';

void main() {
  String? currentValue = '';

  void binder(String? v) {
    currentValue = v;
  }

  group('Test WaterlooDropDownList', () {
    setUp(() {
      currentValue = '';
    });

    testWidgets('Add a WaterlooDropDownList with an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = 'hp';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(WaterlooDropDownList(
        valueBinder: binder,
        label: label,
        initialValue: initialValue,
        items: items,
      ));

      await tester.pumpWidget(page);
      expect(
          checkClosedDropDownList(
            label,
            initialValue: 'HP1',
          ),
          true);
    });

    testWidgets('Add a WaterlooDropDownList without an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(WaterlooDropDownList(
        valueBinder: binder,
        label: label,
        items: items,
      ));

      await tester.pumpWidget(page);
      expect(
          checkClosedDropDownList(
            label,
          ),
          true);
    });

    testWidgets('When I tap the drop down icon I expect to see a list of values to select', (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(WaterlooDropDownList(
        valueBinder: binder,
        label: label,
        items: items,
      ));

      await tester.pumpWidget(page);
      expect(
          checkClosedDropDownList(
            label,
          ),
          true);
      await tapIcon(Icons.keyboard_arrow_down, tester);
      await tester.pumpWidget(page);
      expect(
          checkOpenDropDownList(
            label,
            items: items
          ),
          true);
    });

    testWidgets('When I select an option I expect the TextField to be updated and the bound value to be updated', (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(WaterlooDropDownList(
        valueBinder: binder,
        label: label,
        items: items,
      ));

      await tester.pumpWidget(page);

      await tapIcon(Icons.keyboard_arrow_down, tester);
      await tester.pumpWidget(page);
      await tapTile(label, 'HP1', tester);
      await tester.pumpWidget(page);

      expect(
          checkClosedDropDownList(
            label,
            initialValue: 'HP1'
          ),
          true);
      expect(currentValue, 'hp');


    });

    testWidgets('When I select an option for a widget with a value already present I expect the bound value to change', (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [
        ListItem('hp', 'HP1'),
        ListItem('rm', 'RM1'),
      ];

      Widget page = MockPage(WaterlooDropDownList(
        valueBinder: binder,
        label: label,
        items: items,
      ));

      await tester.pumpWidget(page);

      await tapIcon(Icons.keyboard_arrow_down, tester);
      await tester.pumpWidget(page);
      await tapTile(label, 'HP1', tester);
      await tester.pumpWidget(page);
      expect(currentValue, 'hp');

      await tapIcon(Icons.keyboard_arrow_down, tester);
      await tester.pumpWidget(page);
      await tapTile(label, 'RM1', tester);
      await tester.pumpWidget(page);
      expect(currentValue, 'rm');
    });

  });
}
