import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:waterloo/src/waterloo_grid_layout_constraints.dart';

import '../util.dart';

void main() {
  group('Test WaterlooGridLayoutConstraints', () {
    setUp(() {});

    testWidgets('If the width is 900 then I expect 81 columns of with roughly 10 and zero margin',
        (WidgetTester tester) async {
      var constraints = WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900);
      expect(constraints.numberOfColumns, 81);
      expect(constraints.margin, 0);
      var w = constraints.numberOfColumns * constraints.columnWidth +
          (constraints.numberOfColumns - 1) * 1.0 +
          2 * constraints.margin;
      expect(isCloseTo(900, w), true);
    });

    group('Test minimum columnWidth', () {
      testWidgets('If the width is 900 and the minimum columnwidth is 280 I expect 3 columns a bit less than 300 in width',
          (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900, minimumColumnWidth: 280);
        expect(constraints.numberOfColumns, 3);
        expect(constraints.margin, 0);
        expect(isCloseTo(300.0, constraints.columnWidth, marginOfError: 1), true);
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);
      });

      testWidgets('If the width is 900 and the minimum columnwidth is 300 I expect 2 columns a bit less than 450 in width',
          (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900, minimumColumnWidth: 300);
        expect(constraints.numberOfColumns, 2);
        expect(constraints.margin, 0);
        expect(isCloseTo(450.0, constraints.columnWidth, marginOfError: 1), true);
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);
      });
    });

    group('Test maximum columnWidth', () {
      testWidgets(
          'If the width is 900 and the maximumcolumnwidth is 200 then I expect 81 columns of with roughly 10 and zero margin ',
          (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900, maximumColumnWidth: 200);
        expect(constraints.numberOfColumns, 81);
        expect(constraints.margin, 0);
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);
      });

      testWidgets(
          'If the width is 900 and the maximumcolumnwidth is 200 and the preferred column count is 3 then I expect 3 columns of width 200',
          (WidgetTester tester) async {
        var constraints =
            WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900, maximumColumnWidth: 200, preferredColumnCount: 3);
        expect(constraints.numberOfColumns, 3);
        expect(constraints.columnWidth, 199.9999999);
        expect(isCloseTo(constraints.margin, 149), true);
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);
      });
    });

    group('Test preferred ColumnWidth', () {
      testWidgets('If the width is 900 and the preferredcolumnwidth is 200 then I expect 4 columns of width 200',
          (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900, preferredWidth: 200);
        expect(constraints.numberOfColumns, 4);
        expect(constraints.columnWidth, 199.9999999);
        expect(isCloseTo(constraints.margin, 48.5), true);
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);
      });
    });

    group('Test preferred ColumnCount', () {
      testWidgets('If the width is 900 and the preferredcolumncount is 5 then I expect 5 columns of width about 180',
          (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900, preferredColumnCount: 5);
        expect(constraints.numberOfColumns, 5);
        expect(isCloseTo(constraints.columnWidth, 179.199), true, reason: constraints.toString());
        expect(constraints.margin, 0);
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);

      });
    });

    group('Test preferred ColumnCount', () {
      testWidgets('If the width is 900 and the maxcolumncount is 5 then I expect 5 columns of width about 180',
          (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900, maximumColumnCount: 5);
        expect(constraints.numberOfColumns, 5);
        expect(isCloseTo(constraints.columnWidth, 179.199), true, reason: constraints.toString());
        expect(constraints.margin, 0);
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);

      });
    });

    group('Test columnSeparation', () {
      testWidgets(
          'If the width is 900 and the preferredColumnCount is 4 and the columnseparation is 5, then I expect 4 columns of width about 220',
          (WidgetTester tester) async {
        var constraints =
            WaterlooGridLayoutConstraints.getConstraints(gridWidth: 900, preferredColumnCount: 4, columnSeparation: 5);
        expect(constraints.numberOfColumns, 4);
        expect(isCloseTo(constraints.columnWidth, 221.249), true, reason: constraints.toString());
        expect(constraints.margin, 0);
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 5.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);

      });
    });

    group('Test attempt to break the algorithm', () {
      testWidgets(
          'If I randomly apply 10000 variations on the inputs to see if I can make it do something silly then I fail ',
          (WidgetTester tester) async {
        var r = Random();
        var i = 0;
        while (i < 10000) {
          var r1 = r.nextDouble();
          var gridWith = 10 + 1000 * r1;
          var r2 = r.nextDouble();
          var minColumnWidth = r2 < 0.5 ? null : 10 + (r2 - 0.5) * 800;
          var r3 = r.nextDouble();
          var maxColumnWidth = r3 < 0.5 ? null : (minColumnWidth ?? 10) + (r3 - 0.5) * 800;
          var r4 = r.nextInt(9);
          var preferredCount = r4 < 5 ? null : r4 - 4;
          var r5 = r.nextInt(9);
          var maxColCount = r5 < 5 ? null : r5 - 4;
          var r6 = r.nextDouble();
          var separation = r6 < 0.5 ? null : 1 + (r6 - 0.49) * 50;
          var r7 = r.nextDouble();
          var preferredWidth = r7 < 0.5 ? null : 10 + (r7 - 0.5) * 800;

          var constraints = WaterlooGridLayoutConstraints.getConstraints(
              gridWidth: gridWith,
              minimumColumnWidth: minColumnWidth,
              maximumColumnWidth: maxColumnWidth,
              preferredWidth: preferredWidth,
              preferredColumnCount: preferredCount,
              maximumColumnCount: maxColCount,
              columnSeparation: separation);

          var w = constraints.numberOfColumns * constraints.columnWidth +
              (constraints.numberOfColumns - 1) * (separation ?? 1.0) +
              2 * constraints.margin;
          expect(isCloseToButLessThanOrEqual(gridWith, w), true,
              reason:
                  '$gridWith : $w : $minColumnWidth : $maxColumnWidth : $preferredWidth : $maxColCount : $preferredCount : $separation : ${constraints.toString()}');
          expect(constraints.margin >= 0.00, true,
              reason:
                  '$gridWith : $w : $minColumnWidth : $maxColumnWidth : $preferredWidth : $maxColCount : $preferredCount : $separation : ${constraints.toString()}');
          expect(constraints.columnWidth >= 10.00, true,
              reason:
                  '$gridWith : $w : $minColumnWidth : $maxColumnWidth : $preferredWidth : $maxColCount : $preferredCount : $separation : ${constraints.toString()}');
          expect(constraints.numberOfColumns >= 1, true,
              reason:
                  '$gridWith : $w : $minColumnWidth : $maxColumnWidth : $preferredWidth : $maxColCount : $preferredCount : $separation : ${constraints.toString()}');

          i++;
        }
      });

      testWidgets('Test a specific case #1', (WidgetTester tester) async {
        var separation = 17.00;
        var gridWidth = 37.53;

        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: gridWidth, minimumColumnWidth: 268, maximumColumnWidth: 367, columnSeparation: separation);

        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * (separation) +
            2 * constraints.margin;

        expect(isCloseToButLessThanOrEqual(gridWidth, w), true, reason: '$w : ${constraints.toString()}');

        expect(constraints.numberOfColumns >= 1, true, reason: '$w : ${constraints.toString()}');
      });

      testWidgets('Test a specific case #2', (WidgetTester tester) async {
        var separation = 1.00;
        var gridWidth = 47.82;

        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: gridWidth, minimumColumnWidth: 312,  columnSeparation: separation);

        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * (separation) +
            2 * constraints.margin;

        expect(isCloseToButLessThanOrEqual(gridWidth, w), true, reason: '$w : ${constraints.toString()}');

        expect(constraints.numberOfColumns >= 1, true, reason: '$w : ${constraints.toString()}');
        expect(constraints.margin >= 0.00, true, reason: '$w : ${constraints.toString()}');
      });

    });

    group('Test min/max/preferred ColumnWidth where min width is 200, preferred is 300 and max is 400', () {
      testWidgets('If grid withs is 900 I expect 2 columns', (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: 900, preferredWidth: 300, maximumColumnWidth: 400, minimumColumnWidth: 200);
        expect(constraints.numberOfColumns, 2);
        expect(isCloseTo(300, constraints.columnWidth), true);
        expect(isCloseTo(constraints.margin, 149.5), true, reason: constraints.toString());
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(900, w), true);

      });

      testWidgets('If grid withs is 1000 I expect 3 columns', (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: 1000, preferredWidth: 300, maximumColumnWidth: 400, minimumColumnWidth: 200);
        expect(constraints.numberOfColumns, 3);
        expect(isCloseTo(300, constraints.columnWidth), true);
        expect(isCloseTo(constraints.margin, 49), true, reason: constraints.toString());
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(1000, w), true);

      });

      testWidgets('If grid withs is 800 I expect 2 columns', (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: 800, preferredWidth: 300, maximumColumnWidth: 400, minimumColumnWidth: 200);
        expect(constraints.numberOfColumns, 2);
        expect(isCloseTo(300, constraints.columnWidth), true);
        expect(isCloseTo(constraints.margin, 99.5), true, reason: constraints.toString());
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(800, w), true);

      });

      testWidgets('If grid withs is 700 I expect 2 columns', (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: 700, preferredWidth: 300, maximumColumnWidth: 400, minimumColumnWidth: 200);
        expect(constraints.numberOfColumns, 2);
        expect(isCloseTo(300, constraints.columnWidth), true);
        expect(isCloseTo(constraints.margin, 49.5), true, reason: constraints.toString());
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(700, w), true);

      });

      testWidgets('If grid withs is 605 I expect 2 columns', (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: 605, preferredWidth: 300, maximumColumnWidth: 400, minimumColumnWidth: 200);
        expect(constraints.numberOfColumns, 2);
        expect(isCloseTo(300, constraints.columnWidth), true);
        expect(isCloseTo(constraints.margin, 2), true, reason: constraints.toString());
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(605, w), true);

      });

      testWidgets('If grid withs is 600 I expect 1 column', (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: 600, preferredWidth: 300, maximumColumnWidth: 400, minimumColumnWidth: 200);
        expect(constraints.numberOfColumns, 1);
        expect(isCloseTo(300, constraints.columnWidth), true);
        expect(isCloseTo(constraints.margin, 150), true, reason: constraints.toString());
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(600, w), true);

      });

      testWidgets('If grid withs is 500 I expect 1 column', (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: 500, preferredWidth: 300, maximumColumnWidth: 400, minimumColumnWidth: 200);
        expect(constraints.numberOfColumns, 1);
        expect(isCloseTo(300, constraints.columnWidth), true);
        expect(isCloseTo(constraints.margin, 100), true, reason: constraints.toString());
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(500, w), true);

      });

      testWidgets('If grid withs is 400 I expect 1 column', (WidgetTester tester) async {
        var constraints = WaterlooGridLayoutConstraints.getConstraints(
            gridWidth: 400, preferredWidth: 300, maximumColumnWidth: 400, minimumColumnWidth: 200);
        expect(constraints.numberOfColumns, 1);
        expect(isCloseTo(300, constraints.columnWidth), true, reason: constraints.toString());
        expect(isCloseTo(constraints.margin, 50), true, reason: constraints.toString());
        var w = constraints.numberOfColumns * constraints.columnWidth +
            (constraints.numberOfColumns - 1) * 1.0 +
            2 * constraints.margin;
        expect(isCloseTo(400, w), true);

      });
    });
  });
}
