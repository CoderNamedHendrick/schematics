/// Represents a cell in a grid with a specific row and column.
class GridCell implements Comparable<GridCell> {
  final int row;
  final int column;

  const GridCell({required this.row, required this.column});

  /// Returns the [GridCell] to the left of this cell.
  GridCell get left => GridCell(row: row, column: column - 1);

  /// Returns the [GridCell] to the right of this cell.
  GridCell get right => GridCell(row: row, column: column + 1);

  /// Returns the [GridCell] above this cell.
  GridCell get above => GridCell(row: row - 1, column: column);

  /// Returns the [GridCell] below this cell.
  GridCell get below => GridCell(row: row + 1, column: column);

  @override
  int compareTo(GridCell other) {
    return row.compareTo(other.row) + column.compareTo(other.column);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GridCell && other.row == row && other.column == column;
  }

  @override
  int get hashCode => row.hashCode ^ column.hashCode;
}
