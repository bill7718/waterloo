import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_future_drop_down_list.dart';
import 'package:waterloo/src/waterloo_drop_down_list.dart';

import '../util.dart';

void main() {
  String? currentValue = '';
  late TestGetter getter;

  void binder(String? v) {
    currentValue = v;
  }



  group('Test WaterlooFutureDropDownList', () {
    setUp(() {
      currentValue = '';
      getter = TestGetter();
    });

    testWidgets('Add a WaterlooFutureDropDownList with an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {
      var label = 'Greeting';
      var initialValue = 'hp';

      Widget page = MockPage(WaterlooFutureDropDownList(
        valueBinder: binder,
        label: label,
        initialValue: initialValue,
        getter: getter
      ));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
      expect(
          checkClosedDropDownList(
            label,
            initialValue: 'HP1',
          ),
          true);


    });

    testWidgets('Add a WaterlooFutureDropDownList without an initial value to a page checking that parameters are passed in correctly',
        (WidgetTester tester) async {
      var label = 'Greeting';


      Widget page = MockPage(WaterlooFutureDropDownList(
          valueBinder: binder,
          label: label,
          getter: getter
      ));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
      expect(
          checkClosedDropDownList(
            label,
          ),
          true);
    });

    testWidgets('When I tap the drop down icon I expect to see a list of values to select', (WidgetTester tester) async {
      var label = 'Greeting';


      Widget page = MockPage(WaterlooFutureDropDownList(
        valueBinder: binder,
        label: label,
          getter: getter
      ));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
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
            items: getter.items
          ),
          true);
    });

    testWidgets('When I select an option I expect the TextField to be updated and the bound value to be updated', (WidgetTester tester) async {
      var label = 'Greeting';


      Widget page = MockPage(WaterlooFutureDropDownList(
        valueBinder: binder,
        label: label,
          getter: getter
      ));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();

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

      Widget page = MockPage(WaterlooFutureDropDownList(
        valueBinder: binder,
        label: label,
          getter: getter
      ));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();

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

    testWidgets('When the WaterlooFutureDropDownList does not get a response then I expect to see a TextField', (WidgetTester tester) async {
      var label = 'Greeting';

      Widget page = MockPage(WaterlooFutureDropDownList(
          valueBinder: binder,
          label: label,
          getter: BadTestGetter()
      ));

      await tester.pumpWidget(page);
      await tester.pumpAndSettle();
      expect(
          checkClosedDropDownList(
              label,
          ),
          false);
      expect(checkTextInputField(label, readOnly: true), true);

    });

  });
}

class TestGetter implements ListGetter {

  List<ListItem> items = [
    ListItem('hp', 'HP1'),
    ListItem('rm', 'RM1'),
  ];

  @override
  Future<List<ListItem>> getList() {
    var c = Completer<List<ListItem>>();
    c.complete(items);
    return c.future;
  }

}

class BadTestGetter implements ListGetter {

  List<ListItem> items = [
    ListItem('hp', 'HP1'),
    ListItem('rm', 'RM1'),
  ];

  @override
  Future<List<ListItem>> getList() {
    var c = Completer<List<ListItem>>();
    c.completeError('no values');
    return c.future;
  }

}