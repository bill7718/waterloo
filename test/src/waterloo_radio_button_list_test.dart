import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serializable_data/serializable_data.dart';
import 'package:waterloo/src/waterloo_radio_button_list.dart';


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

    testWidgets('Add a WaterlooRadioButtonList without an initial value to a page checking that parameters are passed in correctly', (WidgetTester tester) async {
      var label = 'Greeting';
      var items = [ ListItem('hp', 'HP1'), ListItem('rm', 'RM1'),];

      Widget page = MockPage(WaterlooRadioButtonList(
        valueBinder: binder,
        label: label,
        items: items,
      ));

      await tester.pumpWidget(page);
      expect(
          checkRadioButtonList(
            label,
            items: items
          ),
          true);
    });

    testWidgets('Add a WaterlooRadioButtonList with an initial value to a page checking that parameters are passed in correctly', (WidgetTester tester) async {
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

    testWidgets('When I tap a button the value changes and the abound value is updated', (WidgetTester tester) async {
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
      await tapRadioTile(label, 'RM1', tester);
      await tester.pumpWidget(page);
      expect(
          checkRadioButtonList(
              label,
              initialValue: 'rm',
              items: items
          ),
          true);
      expect(currentValue, 'rm');
    });


  });
}
