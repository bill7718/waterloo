import 'dart:math';

import 'package:flutter/material.dart';

class WaterlooGrid extends StatelessWidget {
  final List<Widget> children;

  final double minimumColumnWidth;

  final double maximumColumnWidth;

  final int preferredColumnCount;

  final double columnSeparation;

  final double rowSeparation;

  final bool pad;

  const WaterlooGrid({
    Key? key,
    required this.children,
    this.minimumColumnWidth = 0.0,
    this.maximumColumnWidth = 999,
    this.preferredColumnCount = 3,
    this.columnSeparation = 25,
    this.rowSeparation = 25,
    this.pad = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      var layoutConstraints = WaterlooGridLayoutConstraints.calculateConstraints(
          gridWidth: constraints.maxWidth,
          minimumColumnWidth: minimumColumnWidth,
          maximumColumnWidth: maximumColumnWidth,
          preferredColumnCount: preferredColumnCount,
          columnSeparation: columnSeparation,
          pad: pad);

      List<Row> rows = <Row>[];

      // compute the layout for each widget in turn - this is needed because each widgets needs
      // to know the layout for the next widget in the list to determine the correct flex values
      List<WaterlooGridElementLayout> layouts = <WaterlooGridElementLayout>[];
      var remainingColumns = layoutConstraints.numberOfColumns;
      for (var widget in children) {
        if (widget is HasWaterlooGridChildLayout) {
          var w = widget as HasWaterlooGridChildLayout;
          layouts.add(WaterlooGridChild.getChildLayout(
              layoutConstraints.columnWidth, remainingColumns, layoutConstraints.numberOfColumns,
              preferredColumnCount: w.columnCount, preferredColumnWidth: w.preferredWidth, rule: w.layoutRule));
        } else {
          layouts.add(WaterlooGridChild.getChildLayout(
              layoutConstraints.columnWidth, remainingColumns, layoutConstraints.numberOfColumns));
        }
        if (layouts.last.newRow) {
          remainingColumns = layoutConstraints.numberOfColumns - layouts.last.columnCount;
        } else {
          remainingColumns = remainingColumns - layouts.last.columnCount;
        }
      }

      // add a dummy layouts row that indicates a new row after the last widget
      layouts.add(WaterlooGridElementLayout(0, true));

      // now add widgets to the rows based on the widgets
      var i = 0;
      var rowContents = <Widget>[];
      var cumulativeFlex = 0;
      while (i < children.length) {
        if (pad && columnSeparation > 0 && rowContents.isEmpty) {
          rowContents.add(Expanded(
            child: Container(),
            flex: layoutConstraints.columnSeparatorFlex,
          ));
          cumulativeFlex = cumulativeFlex + layoutConstraints.columnSeparatorFlex;
        }
        Widget w = children[i];
        if (w is WaterlooGridChild) {
          w = w.child;
        }
        rowContents.add(Expanded(
          child: w,
          flex: layouts[i].columnCount * layoutConstraints.columnFlex,
        ));
        cumulativeFlex = cumulativeFlex + layouts[i].columnCount * layoutConstraints.columnFlex;

        if (layouts[i + 1].newRow) {
          if (cumulativeFlex < layoutConstraints.totalFlex) {
            rowContents.add(Expanded(
              child: Container(),
              flex: layoutConstraints.totalFlex - cumulativeFlex,
            ));
            cumulativeFlex = cumulativeFlex + layoutConstraints.columnSeparatorFlex;
          }
          rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: rowContents,
          ));
          rowContents = <Widget>[];
          cumulativeFlex = 0;
        } else {
          rowContents.add(Expanded(
            child: Container(),
            flex: layoutConstraints.columnSeparatorFlex,
          ));
          cumulativeFlex = cumulativeFlex + layoutConstraints.columnSeparatorFlex;
        }
        i++;
      }


      return Column(children: rows);
    });
  }
}

class WaterlooGridLayoutConstraints {
  final int numberOfColumns;
  final double columnWidth;
  final int columnFlex;
  final int columnSeparatorFlex;
  final bool pad;

  WaterlooGridLayoutConstraints(
      this.numberOfColumns, this.columnWidth, this.columnFlex, this.columnSeparatorFlex, this.pad);

  static WaterlooGridLayoutConstraints calculateConstraints(
      {double minimumColumnWidth = 0.0,
      double maximumColumnWidth = 999,
      int preferredColumnCount = 3,
      double columnSeparation = 25,
      bool pad = true,
      required double gridWidth}) {
    double availableWidth = gridWidth + columnSeparation;
    if (pad) {
      availableWidth = gridWidth - columnSeparation;
    }

    int maxColumnCount = 32;
    if (minimumColumnWidth > 0) {
      maxColumnCount = min(32, availableWidth ~/ (minimumColumnWidth + columnSeparation));
    }

    int minColumnCount = 1;
    if (minimumColumnWidth > 0) {
      minColumnCount = max(1, availableWidth ~/ (minimumColumnWidth + columnSeparation));
    }

    int actualColumnCount = preferredColumnCount;
    if (minColumnCount > preferredColumnCount) {
      actualColumnCount = minColumnCount;
    }

    if (maxColumnCount < preferredColumnCount) {
      actualColumnCount = maxColumnCount;
    }

    double actualColumnWidth = (availableWidth / actualColumnCount) - columnSeparation;
    int columnSeparationFlex = 100;
    int columnFlex = 1;
    if (columnSeparation <= 0) {
      columnSeparationFlex = 0;
    } else {
      columnFlex = (columnSeparationFlex * actualColumnWidth ~/ columnSeparation) + 1;
    }

    return WaterlooGridLayoutConstraints(actualColumnCount, actualColumnWidth, columnFlex, columnSeparationFlex, pad);
  }

  int get totalFlex {
    if (pad) {
      return (columnFlex + columnSeparatorFlex) * numberOfColumns + columnSeparatorFlex;
    } else {
      return (columnFlex + columnSeparatorFlex) * numberOfColumns - columnSeparatorFlex;
    }
  }
}

class WaterlooGridChild extends StatelessWidget implements HasWaterlooGridChildLayout {
  @override
  final int columnCount;
  final Widget child;
  @override
  final double? preferredWidth;
  @override
  final WaterlooGridChildLayoutRule layoutRule;

  const WaterlooGridChild(
      {Key? key,
      this.columnCount = 1,
      required this.child,
      this.preferredWidth,
      this.layoutRule = WaterlooGridChildLayoutRule.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }

  static WaterlooGridElementLayout getChildLayout(double columnWidth, int remainingColumns, int totalColumnCount,
      {int? preferredColumnCount,
      double? preferredColumnWidth,
      WaterlooGridChildLayoutRule rule = WaterlooGridChildLayoutRule.normal}) {
    switch (rule) {
      case WaterlooGridChildLayoutRule.normal:
        var c = min(totalColumnCount, getColumnCount(columnWidth, preferredColumnCount, preferredColumnWidth));
        if (c > remainingColumns) {
          return WaterlooGridElementLayout(c, true);
        } else {
          return WaterlooGridElementLayout(c, false);
        }

      case WaterlooGridChildLayoutRule.start:
        var c = min(totalColumnCount, getColumnCount(columnWidth, preferredColumnCount, preferredColumnWidth));
        return WaterlooGridElementLayout(c, true);

      case WaterlooGridChildLayoutRule.full:
        return WaterlooGridElementLayout(totalColumnCount, true);

      case WaterlooGridChildLayoutRule.fill:
        var c = min(totalColumnCount, getColumnCount(columnWidth, preferredColumnCount, preferredColumnWidth));
        if (c > remainingColumns) {
          return WaterlooGridElementLayout(totalColumnCount, true);
        } else {
          return WaterlooGridElementLayout(remainingColumns, false);
        }

      default:
        throw Exception('Invalid rule');
    }
  }

  static int getColumnCount(double columnWidth, int? preferredColumnCount, double? preferredColumnWidth) {
    var response = 1;
    if (preferredColumnCount != null) {
      response = preferredColumnCount;
    }
    if (preferredColumnWidth != null) {
      response = columnWidth ~/ preferredColumnWidth + 1;
    }

    return response;
  }
}

class WaterlooGridElementLayout {
  final int columnCount;
  final bool newRow;
  WaterlooGridElementLayout(this.columnCount, this.newRow);
}

enum WaterlooGridChildLayoutRule { start, full, fill, normal }

abstract class HasWaterlooGridChildLayout {
  int get columnCount;
  double? get preferredWidth;
  WaterlooGridChildLayoutRule get layoutRule;
}

class WaterlooGridRow extends StatelessWidget implements HasWaterlooGridChildLayout {
  @override
  final int columnCount;
  final List<Widget> children;
  @override
  final double? preferredWidth;
  @override
  final WaterlooGridChildLayoutRule layoutRule;

  const WaterlooGridRow(
      {Key? key,
      this.columnCount = 1,
      required this.children,
      this.preferredWidth,
      this.layoutRule = WaterlooGridChildLayoutRule.full})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children,);
  }
}
