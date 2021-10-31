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
      );

      var rowSep = rowSeparation ?? Provider.of<WaterlooTheme>(context).gridTheme.rowSeparation;

      List<Widget> rows = <Widget>[];
      var i = 0;
      var rowContents = <Widget>[];
      var remainingWidth = constraints.maxWidth;

      while (i < children.length) {
        // work out the left margin. First item in row uses the column margin
        // other items use the column separation
        double colSeparation = columnSeparation ?? Provider.of<WaterlooTheme>(context).gridTheme.columnSeparation;
        late double leftMargin;
        if (rowContents.isEmpty) {
          leftMargin = layoutConstraints.margin;
        } else {
          leftMargin = colSeparation;
        }

        // now determine the layout rule to apply to this widget
        var rule = WaterlooGridChildLayoutRule.normal;
        var columnCount = 1;
        double? preferredWidth;
        if (children[i] is HasWaterlooGridChildLayout) {
          var w = children[i] as HasWaterlooGridChildLayout;
          rule = w.layoutRule;
          columnCount = w.columnCount;
          preferredWidth = w.preferredWidth;
        }

        switch (rule) {
          case WaterlooGridChildLayoutRule.normal:
            var width = getWidth(columnCount, layoutConstraints.columnWidth, colSeparation, preferredWidth);
            if (width > remainingWidth) {
              if (rowContents.isNotEmpty) {
                rowContents.add(SizedBox(
                  width: remainingWidth,
                ));
                var row = Row(
                  children: rowContents,
                );
                rows.add(Padding(
                  child: row,
                  padding: EdgeInsets.only(top: rowSep / 2, bottom: rowSep / 2),
                ));
              }

              rowContents = <Widget>[];
              rowContents.add(Padding(
                  child: SizedBox(width: width, child: children[i]),
                  padding: EdgeInsets.only(left: layoutConstraints.margin)));
              remainingWidth = remainingWidth = constraints.maxWidth - width - layoutConstraints.margin;
            } else {
              rowContents.add(
                  Padding(child: SizedBox(width: width, child: children[i]), padding: EdgeInsets.only(left: leftMargin)));
              remainingWidth = remainingWidth - width - leftMargin;
            }
            break;

          case WaterlooGridChildLayoutRule.start:
            var width = getWidth(columnCount, layoutConstraints.columnWidth, colSeparation, preferredWidth);
            if (rowContents.isNotEmpty) {
              rowContents.add(SizedBox(
                width: remainingWidth,
              ));
              var row = Row(
                children: rowContents,
              );
              rows.add(Padding(
                child: row,
                padding: EdgeInsets.only(top: rowSep / 2, bottom: rowSep / 2),
              ));
            }

            rowContents = <Widget>[];
            rowContents.add(Padding(
                child: SizedBox(width: width, child: children[i]),
                padding: EdgeInsets.only(left: layoutConstraints.margin)));
            remainingWidth = remainingWidth = constraints.maxWidth - width - layoutConstraints.margin;
            break;

          case WaterlooGridChildLayoutRule.full:
            var width = constraints.maxWidth - 2 * layoutConstraints.margin;
            if (rowContents.isNotEmpty) {
              rowContents.add(SizedBox(
                width: remainingWidth,
              ));
              var row = Row(
                children: rowContents,
              );
              rows.add(Padding(
                child: row,
                padding: EdgeInsets.only(top: rowSep / 2, bottom: rowSep / 2),
              ));
            }

            rowContents = <Widget>[];
            rowContents.add(Padding(
                child: SizedBox(width: width, child: children[i]),
                padding: EdgeInsets.only(left: layoutConstraints.margin, right: layoutConstraints.margin)));
            var row2 = Row(
              children: rowContents,
            );
            rows.add(Padding(
              child: row2,
              padding: EdgeInsets.only(top: rowSep / 2, bottom: rowSep / 2),
            ));

            rowContents = <Widget>[];
            remainingWidth = constraints.maxWidth;
            break;

          case WaterlooGridChildLayoutRule.fill:
            var width = getWidth(columnCount, layoutConstraints.columnWidth, colSeparation, preferredWidth);
            if (width > remainingWidth) {
              width = constraints.maxWidth - 2 * layoutConstraints.margin;
              if (rowContents.isNotEmpty) {
                rowContents.add(SizedBox(
                  width: remainingWidth,
                ));
                var row = Row(
                  children: rowContents,
                );
                rows.add(Padding(
                  child: row,
                  padding: EdgeInsets.only(top: rowSep / 2, bottom: rowSep / 2),
                ));
              }

              rowContents = <Widget>[];
              rowContents.add(Padding(
                  child: SizedBox(width: width, child: children[i]),
                  padding: EdgeInsets.only(left: layoutConstraints.margin, right: layoutConstraints.margin)));
              var row2 = Row(
                children: rowContents,
              );
              rows.add(Padding(
                child: row2,
                padding: EdgeInsets.only(top: rowSep / 2, bottom: rowSep / 2),
              ));

              rowContents = <Widget>[];
              remainingWidth = constraints.maxWidth;
            } else {
              rowContents.add(Padding(
                  child: SizedBox(width: remainingWidth - leftMargin - layoutConstraints.margin, child: children[i]),
                  padding: EdgeInsets.only(left: leftMargin, right: layoutConstraints.margin)));
              var row2 = Row(
                children: rowContents,
              );
              rows.add(Padding(
                child: row2,
                padding: EdgeInsets.only(top: rowSep / 2, bottom: rowSep / 2),
              ));

              rowContents = <Widget>[];
              remainingWidth = constraints.maxWidth;
            }
            break;
        }
        i++;
      }
      if (rowContents.isNotEmpty) {
        rowContents.add(SizedBox(
          width: remainingWidth,
        ));
        var row = Row(
          children: rowContents,
        );
        rows.add(Padding(
          child: row,
          padding: EdgeInsets.only(top: rowSep / 2, bottom: rowSep / 2),
        ));
      }

      return Column(children: rows);
    });
  }

  double getWidth(int columnCount, double columnWidth, double columnSeparation, double? preferredWith) {
    var width = 0.00;
    if (preferredWith != null) {
      var cols = preferredWith ~/ (columnWidth + columnSeparation) + 1;
      width = cols * columnWidth + (cols - 1) * columnSeparation;
    } else {
      width = columnCount * columnWidth + (columnCount - 1) * columnSeparation;
    }
    return width;
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
    return LayoutBuilder(builder: (context, constraints) {
      return child;
    });
  }
}

enum WaterlooGridChildLayoutRule { start, full, fill, normal }

abstract class HasWaterlooGridChildLayout {
  int get columnCount => 1;
  double? get preferredWidth => null;
  WaterlooGridChildLayoutRule get layoutRule => WaterlooGridChildLayoutRule.normal;
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }
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

///
/// Specifies the layout constraints used to build a rid of widgets
///
class WaterlooGridLayoutConstraints {
  /// The number of columns in the Grid
  final int numberOfColumns;

  /// The width of the column
  final double columnWidth;

  /// The size of hte left and right margin
  final double margin;

  WaterlooGridLayoutConstraints(this.numberOfColumns, this.columnWidth, this.margin);

  ///
  /// Generate constraints based on the values provided
  /// - minimumColumnWidth : The column(s) will not have a width smaller than this unless the available width is too small
  /// - maximumColumnWidth : The column(s) will not have a width greater than this. If necessary the margin will be increased to ensure that this is so.
  /// - preferredWidth : The preferred width for the column. Given a range of possible column counts the system prefers column counts than give a width close to the preferred width
  /// - preferredColumnCount : Given a range of possible column widths the system prefers a with counts that gives a the preferred column count
  /// - maximumColumnCount: The maximum column Count. If necessary the margin is increased to ensure that this constraint is respected
  /// - columnSeparation : The distance between the columns. A fixed value that is always respected
  /// - grid width : the actual available width
  ///
  ///
  /// This method works as follows
  /// - use the gridWidth, minimumColumnCount (1) and the maximum column width provided to calculate an actual maximumColumnWidth
  /// - use the gridWidth, minimum column width, the maximum column count and the separation to calculate an actual maximum column count
  ///
  ///
  static WaterlooGridLayoutConstraints getConstraints(
      {
        double? minimumColumnWidth,
      double? maximumColumnWidth,
      double? preferredWidth,
      int? preferredColumnCount,
      int? maximumColumnCount,
      double? columnSeparation,
      required double gridWidth}) {
    var separation = columnSeparation ?? 1;

    double availableWidth = gridWidth + separation;

    availableWidth = gridWidth - separation;

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

      return WaterlooGridLayoutConstraints(actColCount, actColWidth, margin);
    } else {
      int actColCount = availableWidth ~/ (minColWidth + separation);
      actColCount = min(actColCount, preferredColumnCount ?? 999);

      double actColWidth = availableWidth / actColCount - separation;
      actColWidth = min(actColWidth, maxColWidth);
      actColWidth = max(actColWidth, minColWidth);

      // now I know the column count the columnWidth and the separation I can calculate the margin
      double margin = (gridWidth - actColCount * actColWidth - (actColCount - 1) * separation) / 2;
      return WaterlooGridLayoutConstraints(actColCount, actColWidth, margin);
    }
  }
}
