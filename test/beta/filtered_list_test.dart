import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/waterloo.dart';

import '../util.dart';

void main() {
  final items = StringScorer.make(['Hello', 'Goodbye', 'Colin', 'Mabel']);

  group('Test FilteredList', () {
    testWidgets('When I add a FilteredList to a page I expect the correct widgets to be found',
        (WidgetTester tester) async {
      Widget page = MockPage(FilteredList(
          items: items,
          builder: (context, item) {
            return Text(item.value);
          }));

      await tester.pumpWidget(page);

      expect(findTextInputFieldByLabel(FilteredList.filterLabel), findsOneWidget);

      for (var item in items) {
        expect(find.text(item.value), findsOneWidget);
      }
    });

    testWidgets('When I add a FilteredList to a page with a bespoke label I expect the label to be based on the value passed',
            (WidgetTester tester) async {
          Widget page = MockPage(FilteredList(
              items: items,
              label: 'Hi',
              builder: (context, item) {
                return Text(item.value);
              }));

          await tester.pumpWidget(page);

          expect(findTextInputFieldByLabel(FilteredList.filterLabel), findsNothing);
          expect(findTextInputFieldByLabel('Hi'), findsOneWidget);

        });

    testWidgets('When I enter nothing in the filter I expect no items to be filtered ', (WidgetTester tester) async {
      Widget page = MockPage(FilteredList(
          items: items,
          builder: (context, item) {
            return Text(item.value);
          }));

      await tester.pumpWidget(page);
      await enterText(tester, 'Filter', 'y');

      expect(find.text('Hello'), findsNothing);

      await enterText(tester, 'Filter', '');

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('When I add a enter data in the filter I expect the items to be filtered ',
        (WidgetTester tester) async {
      Widget page = MockPage(FilteredList(
          items: items,
          builder: (context, item) {
            return Text(item.value);
          }));

      await tester.pumpWidget(page);
      await enterText(tester, 'Filter', 'y');

      expect(findTextInputFieldByLabel(FilteredList.filterLabel), findsOneWidget);
      expect(find.text('Hello'), findsNothing);
      expect(find.text('Goodbye'), findsOneWidget);
    });

    testWidgets('When I clear the search cache it is cleared down ',
            (WidgetTester tester) async {
          Widget page = MockPage(FilteredList(
              items: items,
              builder: (context, item) {
                return Text(item.value);
              }));

          await tester.pumpWidget(page);
          await enterText(tester, 'Filter', 'y');

          expect(items.first.isCacheEmpty, false);
          items.first.clearScoreCache();
          expect(items.first.isCacheEmpty, true);

        });
  });
}

class StringScorer with Scored {
  final String value;

  StringScorer(this.value);

  @override
  int score(String filter) {
    if (value.contains(filter)) {
      return value.length;
    } else {
      return 0;
    }
  }

  static List<StringScorer> make(List<String> values) {
    var response = <StringScorer>[];

    for (var item in values) {
      response.add(StringScorer(item));
    }

    return response;
  }
}
