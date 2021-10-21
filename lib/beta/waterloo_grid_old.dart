import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waterloo/src/waterloo_theme.dart';

class WaterlooGrid extends StatelessWidget {
  final List<Widget> children;

  final double? minimumColumnWidth;

  final double? maximumColumnWidth;

  final int? preferredColumnCount;

  final int? maximumColumnCount;

  final double? preferredColumnWidth;

  final double? columnSeparation;

  final double? rowSeparation;

  final bool pad;

  const WaterlooGrid({
    Key? key,
    required this.children,
    this.minimumColumnWidth,
    this.maximumColumnWidth,
    this.preferredColumnWidth,
    this.preferredColumnCount,
    this.maximumColumnCount,
    this.columnSeparation,
    this.rowSeparation,
    this.pad = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var layoutConstraints = WaterlooGridLayoutConstraints.getConstraints(
          gridWidth: constraints.maxWidth,
          minimumColumnWidth: minimumColumnWidth,
          maximumColumnWidth: maximumColumnWidth,
          preferredColumnCount: preferredColumnCount ?? Provider.of<WaterlooTheme>(context).gridTheme.preferredColumnCount,
          preferredWidth: preferredColumnWidth,
          maximumColumnCount: maximumColumnCount,
          columnSeparation: columnSeparation ?? Provider.of<WaterlooTheme>(context).gridTheme.columnSeparation,
          pad: pad);



      var rowSep = rowSeparation ?? Provider.of<WaterlooTheme>(context).gridTheme.rowSeparation;

      // compute the layout for each widget in turn - this is needed because each widgets needs
      // to know the layout for the next widget in the list to determine the correct flex values
      List<WaterlooGridElementLayout> layouts = <WaterlooGridElementLayout>[];
      var remainingColumns = layoutConstraints.numberOfColumns;
      for (var widget in children) {
        if (widget is HasWaterlooGridChildLayout) {
          var w = widget as HasWaterlooGridChildLayout;
          layouts.add(WaterlooGridChild.getChildLayout(layoutConstraints.columnWidth, remainingColumns, layoutConstraints.numberOfColumns,
              preferredColumnCount: w.columnCount, preferredColumnWidth: w.preferredWidth, rule: w.layoutRule));
        } else {
          layouts.add(WaterlooGridChild.getChildLayout(layoutConstraints.columnWidth, remainingColumns, layoutConstraints.numberOfColumns));
        }
        if (layouts.last.newRow) {
          remainingColumns = layoutConstraints.numberOfColumns - layouts.last.columnCount;
        } else {
          remainingColumns = remainingColumns - layouts.last.columnCount;
        }
      }

      // add a dummy layouts row that indicates a new row after the last widget
      layouts.add(WaterlooGridElementLayout(0, true, 0));



      // now add widgets to the rows based on the layout rules for each child
      List<Widget> rows = <Widget>[];
      var i = 0;
      var rowContents = <Widget>[];

      while (i < children.length) {



        i++;
      }


      var cumulativeFlex = 0;
      while (i < children.length) {
        if (layouts[i].columnCount != 0) {
          if (rowContents.isEmpty) {
            rowContents.add(Expanded(
              child: Container(),
              flex: layoutConstraints.marginFlex,
            ));
            cumulativeFlex = cumulativeFlex + layoutConstraints.marginFlex;
          }

          var flex = layouts[i].columnCount * layoutConstraints.columnFlex + layoutConstraints.columnSeparatorFlex * (layouts[i].columnCount - 1);

          rowContents.add(Expanded(
            child: children[i],
            flex: flex,
          ));

          cumulativeFlex = cumulativeFlex + flex;

          if (layouts[i + 1].newRow) {
            if (cumulativeFlex < layoutConstraints.totalFlex) {
              rowContents.add(Expanded(
                child: Container(),
                flex: layoutConstraints.totalFlex - cumulativeFlex,
              ));
            }
            rows.add(Container(
                margin: EdgeInsets.fromLTRB(0, rowSep / 2, 0, rowSep / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: rowContents,
                )));
            rowContents = <Widget>[];
            cumulativeFlex = 0;
          } else {
            rowContents.add(Expanded(
              child: Container(),
              flex: layoutConstraints.columnSeparatorFlex,
            ));
            cumulativeFlex = cumulativeFlex + layoutConstraints.columnSeparatorFlex;
          }
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
  final double margin;
  final int marginFlex;

  WaterlooGridLayoutConstraints(this.numberOfColumns, this.columnWidth, this.columnFlex, this.columnSeparatorFlex, this.margin, this.marginFlex);

  static WaterlooGridLayoutConstraints getConstraints(
      {double? minimumColumnWidth,
      double? maximumColumnWidth,
      double? preferredWidth,
      int? preferredColumnCount,
      int? maximumColumnCount,
      double? columnSeparation,
      bool pad = true,
      required double gridWidth}) {
    var separation = columnSeparation ?? 1;

    double availableWidth = gridWidth + separation;
    if (!pad) {
      availableWidth = gridWidth - separation;
    }

    // initialise the width and column count constraints
    double maxColWidth = maximumColumnWidth ?? 999.00;
    double minColWidth = minimumColumnWidth ?? 1.00;
    int minColCount = 1;
    int maxColCount = maximumColumnCount ?? 999;

    // if we respect the minimum column count then this implies a maximum column width
    maxColWidth = min(maxColWidth, (availableWidth / minColCount - separation));

    // if we respect the minimum column width then this implies a maximum column count
    maxColCount = min(maxColCount, availableWidth ~/ (minColWidth + separation));

    // if we respect the maximum column count then this implies a minimum column width
    minColWidth = max(minColWidth, (availableWidth / maxColCount - separation));

    // if we respect the maximum column width then this implies a minimum column count
    minColCount = max(minColCount, (availableWidth ~/ (maxColWidth + separation)));

    if (preferredWidth != null) {
      double actColWidth = preferredWidth;
      actColWidth = min(actColWidth, maxColWidth);
      actColWidth = max(actColWidth, minimumColumnWidth ?? 0);

      int actColCount = availableWidth ~/ (actColWidth + separation);
      actColCount = min(actColCount, preferredColumnCount ?? 999);

      // now I know the column count the columnWidth and the separation I can calculate the margin
      double margin = (gridWidth - actColCount * actColWidth - (actColCount - 1) * separation) / 2;

      // now I can calculate the flex values needed to support this

      int separationFlex = 1000;
      int columnFlex = separationFlex * actColWidth ~/ separation;
      int marginFlex = separationFlex * margin ~/ separation;

      return WaterlooGridLayoutConstraints(actColCount, actColWidth, columnFlex, separationFlex, margin, marginFlex);
    } else {
      int actColCount = availableWidth ~/ (minColWidth + separation);
      actColCount = min(actColCount, preferredColumnCount ?? 999);

      double actColWidth = availableWidth / actColCount - separation;
      actColWidth = min(actColWidth, maxColWidth);
      actColWidth = max(actColWidth, minColWidth);

      // now I know the column count the columnWidth and the separation I can calculate the margin
      double margin = (gridWidth - actColCount * actColWidth - (actColCount - 1) * separation) / 2;

      // now I can calculate the flex values needed to support this

      int separationFlex = 1000;
      int columnFlex = separationFlex * actColWidth ~/ separation;
      int marginFlex = separationFlex * margin ~/ separation;

      return WaterlooGridLayoutConstraints(actColCount, actColWidth, columnFlex, separationFlex, margin, marginFlex);
    }
  }

  int get totalFlex => 2 * marginFlex + columnFlex * numberOfColumns + columnSeparatorFlex * (numberOfColumns - 1);
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
      {Key? key, this.columnCount = 1, required this.child, this.preferredWidth, this.layoutRule = WaterlooGridChildLayoutRule.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return child;
    });
  }

  static WaterlooGridElementLayout getChildLayout(double columnWidth, int remainingColumns, int totalColumnCount,
      {int? preferredColumnCount, double? preferredColumnWidth, WaterlooGridChildLayoutRule rule = WaterlooGridChildLayoutRule.normal}) {
    switch (rule) {
      case WaterlooGridChildLayoutRule.normal:
        var c = min(totalColumnCount, getColumnCount(columnWidth, preferredColumnCount, preferredColumnWidth));
        if (c > remainingColumns) {
          return WaterlooGridElementLayout(c, true, preferredColumnWidth);
        } else {
          return WaterlooGridElementLayout(c, false, preferredColumnWidth);
        }

      case WaterlooGridChildLayoutRule.start:
        var c = min(totalColumnCount, getColumnCount(columnWidth, preferredColumnCount, preferredColumnWidth));
        return WaterlooGridElementLayout(c, true, preferredColumnWidth);

      case WaterlooGridChildLayoutRule.full:
        return WaterlooGridElementLayout(totalColumnCount, true, preferredColumnWidth);

      case WaterlooGridChildLayoutRule.fill:
        var c = min(totalColumnCount, getColumnCount(columnWidth, preferredColumnCount, preferredColumnWidth));
        if (c > remainingColumns) {
          return WaterlooGridElementLayout(totalColumnCount, true, preferredColumnWidth);
        } else {
          return WaterlooGridElementLayout(remainingColumns, false, preferredColumnWidth);
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

  @override
  bool get show => true;
}

class WaterlooGridElementLayout {
  final int columnCount;
  final bool newRow;
  final double? preferredWidth;
  WaterlooGridElementLayout(this.columnCount, this.newRow, this.preferredWidth);
}

enum WaterlooGridChildLayoutRule { start, full, fill, normal }

abstract class HasWaterlooGridChildLayout {
  int get columnCount => 1;
  double? get preferredWidth => null;
  WaterlooGridChildLayoutRule get layoutRule => WaterlooGridChildLayoutRule.normal;
  bool get show => true;
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
      {Key? key, this.columnCount = 1, required this.children, this.preferredWidth, this.layoutRule = WaterlooGridChildLayoutRule.full})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }

  @override
  bool get show => true;
}

///
/// Default parameters used by the [WaterlooGrid]
///
class WaterlooGridTheme {
  /// The default value of the preferred number of columns for a grid
  final int preferredColumnCount;

  /// The default value of the separation between columns
  final double columnSeparation;

  /// The default value of the separation between columns
  final double rowSeparation;

  const WaterlooGridTheme({this.preferredColumnCount = 3, this.columnSeparation = 25, this.rowSeparation = 5});
}
