import 'dart:math';

///
/// Specifies the layout constraints used to build a rid of widgets
///
class WaterlooGridLayoutConstraints {
  /// The number of columns in the Grid
  final int numberOfColumns;

  /// The width of the column
  final double columnWidth;

  /// The size of the left and right margin
  final double margin;

  WaterlooGridLayoutConstraints(this.numberOfColumns, this.columnWidth, this.margin);

  @override
  String toString()=>'$numberOfColumns : $columnWidth : $margin';

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

    // initialise the width and column count constraints
    double maxColWidth = maximumColumnWidth ?? 999.00;
    double minColWidth = minimumColumnWidth ?? 10.00;
    int minColCount = 1;
    int maxColCount = maximumColumnCount ?? 999;

    // if we respect the minimum column count then this implies a maximum column width
    maxColWidth = min(maxColWidth, (availableWidth / minColCount - separation ));

    // if we respect the minimum column width then this implies a maximum column count
    maxColCount = min(maxColCount, availableWidth ~/ (minColWidth + separation));
    maxColCount == 0 ? maxColCount = 1 : {};

    // if we respect the maximum column count then this implies a minimum column width
    minColWidth = max(minColWidth, (availableWidth / maxColCount - separation));

    // if we respect the maximum column width then this implies a minimum column count
    minColCount = max(minColCount, (availableWidth ~/ (maxColWidth + separation)));


    if (preferredWidth != null) {
      double actColWidth = preferredWidth;
      actColWidth = min(actColWidth, maxColWidth);
      actColWidth = max(actColWidth, 10.01);
      actColWidth = actColWidth - 0.0000001;

      int actColCount = availableWidth ~/ (actColWidth + separation);
      actColCount = min(actColCount, preferredColumnCount ?? 999);

      // now I know the column count the columnWidth and the separation I can calculate the margin
      double margin = (gridWidth - actColCount * actColWidth - (actColCount - 1) * separation) / 2;
      margin = margin - 0.0001;
      if (margin < 0.00 && margin > -0.01) margin = 0.00;
      if (margin > 0.00 && margin < 0.001) margin = 0.00;

      return WaterlooGridLayoutConstraints(actColCount, actColWidth, margin);
    } else {
      int actColCount = maxColCount;
      actColCount = min(actColCount, preferredColumnCount ?? 999);

      double actColWidth = availableWidth / actColCount - separation;
      actColWidth = min(actColWidth, maxColWidth);
      actColWidth = actColWidth - 0.0000001;

      // now I know the column count the columnWidth and the separation I can calculate the margin
      double margin = (gridWidth - actColCount * actColWidth - (actColCount - 1) * separation) / 2;
      margin = margin - 0.0001;
      if (margin < 0.00 && margin > -0.01) margin = 0.00;
      if (margin > 0.00 && margin < 0.001) margin = 0.00;

      return WaterlooGridLayoutConstraints(actColCount, actColWidth, margin);
    }
  }
}