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


  });
}
